#!/bin/bash

repo_path=/Volumes/Destiny/Share/maven-repository
echo 正在搜索...
find ${repo_path} -name "*lastUpdated*"
find ${repo_path} -name "*lastUpdated*" | xargs rm -fr
echo 搜索完毕
