#!/bin/bash

repo_path=~/Destiny/Share/maven-repository
echo 正在搜索...
find ${repo_path} -name "*.lastUpdated"
find ${repo_path} -name "*.lastUpdated" -print0 | xargs -0 rm
find ${repo_path} -name "\$\{*"
find ${repo_path} -name "\$\{*" -print0 | xargs -0 rm
echo 搜索完毕
