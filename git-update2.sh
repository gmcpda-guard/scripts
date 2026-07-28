#!/usr/bin/env bash

set -u

TARGET="${1:-.}"

if [[ ! -e "$TARGET" ]]; then
    echo "Error: '$TARGET' does not exist."
    exit 1
fi

update_repo() {
    local repo="$1"

    echo
    echo "=================================================="
    echo "Repository: $repo"
    echo "=================================================="

    if ! git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Not a Git repository."
        return
    fi

    branch=$(git -C "$repo" branch --show-current)

    if [[ -z "$branch" ]]; then
        echo "Unable to determine current branch."
        return
    fi

    echo "Current branch: $branch"
    echo "Fetching updates..."

    if ! git -C "$repo" fetch --prune; then
        echo "Fetch failed."
        return
    fi

    echo "Pulling latest changes..."

    if git -C "$repo" pull --ff-only; then
        echo "Update complete."
    else
        echo "Pull failed."
        echo "Manual attention may be required."
    fi
}

if git -C "$TARGET" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    update_repo "$TARGET"
    exit
fi

found=0

for dir in "$TARGET"/*; do
    [[ -d "$dir/.git" ]] || continue
    found=1
    update_repo "$dir"
done

if [[ $found -eq 0 ]]; then
    echo "No Git repositories found."
fi

