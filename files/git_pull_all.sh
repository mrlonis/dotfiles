for org_dir in $HOME/Documents/GitHub/*; do
    echo "Processing GitHub Organization: $org_dir"
    cd "$org_dir"

    for project_dir in $org_dir/*; do
        if [ -d "$project_dir" ]; then
            echo "Processing Project: $project_dir"
            cd "$project_dir"
            git pull
        fi
    done
done
