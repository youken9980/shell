#!/bin/bash

current_branch="$(git symbolic-ref --short -q HEAD)"
default_branch="$(git branch -r | grep '\->' | awk '{ print $3 }' | sed 's/origin\///g')"

git checkout "${default_branch}"
git pull --rebase

git remote prune origin
for item in $(git branch -r | grep -v '\->' | sed 's/origin\///g'); do
 	git checkout "${item}"
 	git pull --rebase
done

git checkout "${current_branch}"
