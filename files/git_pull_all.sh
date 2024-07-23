#!/bin/bash
for org_dir in "$HOME"/GitHub/*; do
	echo "Processing GitHub Organization: $org_dir"
	cd "$org_dir" || return

	for project_dir in "$org_dir"/*; do
		if [ -d "$project_dir" ]; then
			echo "Processing Project: $project_dir"
			cd "$project_dir" || return
			git pull
			if [ -e .gitmodules ]; then
				echo "Processing submodules for Project: $project_dir"
				git submodule update --init --remote --force
			fi
		fi
	done
done
