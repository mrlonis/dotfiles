#!/bin/bash
for org_dir in "$HOME"/Documents/GitHub/*; do
	echo "Processing GitHub Organization: $org_dir"
	cd "$org_dir" || return

	for project_dir in "$org_dir"/*; do
		if [ -d "$project_dir" ]; then
			echo "Processing Project: $project_dir"
			cd "$project_dir" || return
			git pull
		fi
	done
done
