#!/bin/bash
shopt -s nullglob
force_delete_all_local_branches=${1:-0}

# Keep directory changes and temporary variables scoped to one repository.
update_repo() (
	set -o pipefail
	cd -- "$1" || return

	default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p') || return
	current_branch=$(git rev-parse --abbrev-ref HEAD) || return
	# Switch back to default branch if not already on it
	if [ "$current_branch" != "$default_branch" ]; then
		git checkout "$default_branch" || return
	fi

	git fetch --all -p || return
	git pull --all || return
	if [ -e .gitmodules ]; then
		git submodule update --init --remote --force || return
	fi

	# If force_delete_all_local_branches is set to 1, delete all local branches that don't have a remote counterpart
	if [ "$force_delete_all_local_branches" -eq 1 ]; then
		local_branch_output=$(git for-each-ref --format '%(refname:short)' refs/heads) || return
		remote_branch_output=$(git for-each-ref --format '%(refname:short)' refs/remotes/origin) || return
		local_branches=()
		for branch in $local_branch_output; do
			local_branches+=("$branch")
		done

		remote_branches=()
		for branch in $remote_branch_output; do
			# Trim origin/ from the branch name
			branch=${branch#origin/}
			if [ "$branch" != "HEAD" ]; then
				remote_branches+=("$branch")
			fi
		done

		# Delete local branches not present in remote branches
		for local_branch in "${local_branches[@]}"; do
			exists_in_remote=0
			for remote_branch in "${remote_branches[@]}"; do
				if [ "$local_branch" == "$remote_branch" ]; then
					exists_in_remote=1
					break
				fi
			done
			if [ "$exists_in_remote" -eq 0 ]; then
				git branch -D "$local_branch" || return
			fi
		done
	else
		# Delete local branches whose upstream has been removed
		gone_branches=$(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}') || return
		for branch in $gone_branches; do
			git branch -D "$branch" || return
		done
	fi
	return 0
)

status=0
for org_dir in "$HOME"/GitHub/*; do
	[[ -d "$org_dir" ]] || continue
	echo "Processing GitHub Organization: $org_dir"

	for project_dir in "$org_dir"/*; do
		if [ -d "$project_dir" ]; then
			# A .git file also supports linked worktrees and submodules.
			[[ -e "$project_dir/.git" ]] || continue
			[[ $(git -C "$project_dir" rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || continue
			echo " "
			echo "Processing Project: $project_dir"
			if ! update_repo "$project_dir"; then
				printf 'Failed to update repository: %s; continuing to the next repository.\n' "$project_dir" >&2
				status=1
			fi
		fi
	done
done
exit "$status"
