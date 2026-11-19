#!/bin/bash
# Update clones in ~/GitHub/<organization>/<project> and force-update their
# submodules to the configured remote branch. Pass 1 to also delete
# local branches missing from origin, including branches with unmerged work.
shopt -s nullglob
delete_local_branches=${1-0}
if [[ $# -gt 1 || ($delete_local_branches != 0 && $delete_local_branches != 1) ]]; then
	printf 'Usage: %s [0|1]\n' "${0##*/}" >&2
	exit 2
fi

delete_branches_missing_from_origin() {
	local local_refs origin_refs stale_refs ref
	# Query origin itself: a single-branch clone may only track a subset locally.
	origin_refs=$(git ls-remote --exit-code --heads --sort=refname origin | cut -f2) || return
	local_refs=$(git for-each-ref --sort=refname --format='%(refname)' refs/heads) || return
	stale_refs=$(LC_ALL=C comm -23 <(printf '%s\n' "$local_refs") <(printf '%s\n' "$origin_refs")) || return

	while IFS= read -r ref; do
		[[ -n "$ref" && "$ref" != "refs/heads/$1" ]] || continue
		git branch -D -- "${ref#refs/heads/}" || return
	done <<<"$stale_refs"
}

update_repo() (
	set -o pipefail
	cd -- "$1" || return

	git fetch --all --prune || return
	git remote set-head origin --auto >/dev/null || return
	origin_ref=$(git symbolic-ref refs/remotes/origin/HEAD) || return
	default_branch=${origin_ref#refs/remotes/origin/}
	current_branch=$(git branch --show-current) || return
	if [[ "$current_branch" != "$default_branch" ]]; then
		git -c checkout.defaultRemote=origin switch --guess -- "$default_branch" || return
	fi
	git merge --ff-only "$origin_ref" || return

	if [[ -f .gitmodules ]]; then
		git submodule update --init --remote --force || return
	fi
	if [[ $delete_local_branches == 1 ]]; then
		delete_branches_missing_from_origin "$default_branch" || return
	fi
)

status=0
for project_dir in "$HOME"/GitHub/*/*; do
	# Accept .git files (linked worktrees) as well as directories. An empty
	# prefix confirms Git found this project root and did not walk up to a parent.
	[[ -e "$project_dir/.git" ]] || continue
	[[ $(git -C "$project_dir" rev-parse --is-inside-work-tree --show-prefix 2>/dev/null) == true ]] || continue
	printf 'Updating %s\n' "$project_dir"
	if ! update_repo "$project_dir"; then
		printf 'Failed to update repository: %s\n' "$project_dir" >&2
		status=1
	fi
done
exit "$status"
