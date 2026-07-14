#!/usr/bin/env fish

set GIT_HOME ~/Documents/GitHub

set REPOS Security how-to docker scripts

for repo in $REPOS
    echo
    echo "======================================"
    echo "Updating: $repo"
    echo "======================================"

    if test -d "$GIT_HOME/$repo/.git"
        cd "$GIT_HOME/$repo"

        echo "Fetching changes..."
        git fetch

        echo "Pulling latest changes..."
        git pull

        echo
        git status

    else
        echo "ERROR: $repo is not a Git repository"
    end
end

echo
echo "All repositories updated."
