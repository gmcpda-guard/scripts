#!/usr/bin/env bash

set -u
TARGET="${1:-.}"

push_repo() {

    local repo="$1"

    branch=$(git -C "$repo" branch --show-current)

    echo
    echo "--------------------------------------------------"
    echo "$repo"
    echo "Branch: $branch"

    if [[ -n "$(git -C "$repo" status --porcelain)" ]]; then
        echo "Working tree has uncommitted changes."
        echo "Skipping."
        return
    fi

    ahead=$(git -C "$repo" rev-list --count "@{u}..HEAD" 2>/dev/null)

    if [[ -z "$ahead" || "$ahead" == "0" ]]; then
        echo "Nothing to push."
        return
    fi

    echo "Commits to push: $ahead"

    if git -C "$repo" push; then
        echo "Push successful."
    else
        echo "Push failed."
    fi
}

repos=()

if [[ -d "$TARGET/.git" ]]; then
    repos+=("$TARGET")
else
    for dir in "$TARGET"/*; do
        [[ -d "$dir/.git" ]] && repos+=("$dir")
    done
fi

if [[ ${#repos[@]} -eq 0 ]]; then
    echo "No repositories found."
    exit 1
fi

echo "Repositories to process:"

for r in "${repos[@]}"; do
    echo "  - $r"
done

echo
read -rp "Continue with push? [y/N] " ans

[[ "$ans" =~ ^[Yy]$ ]] || exit 0

for r in "${repos[@]}"; do
    push_repo "$r"
done

