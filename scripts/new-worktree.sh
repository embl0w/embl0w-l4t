#!/bin/bash

set -eu

git worktree add --force --detach $1

cd $1

if git show-ref -q --heads artifacts; then
    git checkout --ignore-other-worktrees $2
else
    git checkout --orphan $2
    git rm -rf .
    git commit --allow-empty --allow-empty-message -m ""
fi
