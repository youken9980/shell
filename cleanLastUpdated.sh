#!/bin/bash

repo_path=/Volumes/Destiny/Share/maven-repository
echo 正在搜索...
find ${repo_path} -name "*lastUpdated*"
find ${repo_path} -name "*lastUpdated*" | xargs rm -fr
find ${repo_path} -name "\$\{*"
find ${repo_path} -name "\$\{*" | xargs rm -rf
echo 搜索完毕
