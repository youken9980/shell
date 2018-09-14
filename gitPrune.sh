#!/bin/bash

git pull --rebase
git remote prune origin
git gc --prune=now
