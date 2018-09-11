#!/bin/bash

current_branch="$(git symbolic-ref --short -q HEAD)"

git checkout master
git pull --rebase

# for item in $(git branch | grep -v master); do
# 	git branch -D "${item}"
# done

git remote prune origin
for item in $(git branch -r | grep -v '\->' | sed 's/origin\///g'); do
	if [[ "${item}" == "${current_branch}" ]]; then
		continue;
	fi
 	git checkout "${item}"
 	git pull --rebase
done

git checkout "${current_branch}"
