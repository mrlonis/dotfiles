#!/bin/bash
for org_dir in "$HOME"/GitHub/*; do
	echo "Processing GitHub Organization: $org_dir"
	cd "$org_dir" || return

	for project_dir in "$org_dir"/*; do
		if [ -d "$project_dir" ]; then
			echo "Processing Project: $project_dir"
			cd "$project_dir" || return
			default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
			current_branch=$(git rev-parse --abbrev-ref HEAD)
			echo "Default branch: $default_branch"
			echo "Current branch: $current_branch"
			# Switch back to default branch if not already on it
			if [ "$current_branch" != "$default_branch" ]; then
				git checkout "$default_branch"
			fi
			git pull
			if [ -e .gitmodules ]; then
				echo "Processing submodules for Project: $project_dir"
				git submodule update --init --remote --force
			fi
			git fetch -p
			for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
				git branch -D "$branch"
			done
			echo "-"
			default_branch=""
			current_branch=""
		fi
	done
done
