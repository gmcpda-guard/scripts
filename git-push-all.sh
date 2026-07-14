#!/usr/bin/env fish

set GIT_HOME ~/Documents/GitHub
set REPOS Security how-to docker scripts

set MESSAGE "Automated update"

for repo in $REPOS
    echo
    echo "======================================"
    echo "Processing: $repo"
    echo "======================================"

    cd "$GIT_HOME/$repo"

    if not test -d .git
        echo "Skipping $repo - not a git repository"
        continue
    end

    set STATUS (git status --porcelain)

    if test -n "$STATUS"
        echo "Changes detected:"
        git status

        git add .

        git commit -m "$MESSAGE"

        git push

        echo "$repo pushed successfully"
    else
        echo "$repo has no changes"
    end
end

echo
echo "All repositories processed."
