#!/bin/bash

current_branch="$(git symbolic-ref --short -q HEAD)"

git checkout master
git pull --rebase

git remote prune origin
for item in $(git branch -r | grep -v '\->' | grep -v 'master' | sed 's/origin\///g'); do
 	git checkout "${item}"
 	git pull --rebase
done

git checkout "${current_branch}"
