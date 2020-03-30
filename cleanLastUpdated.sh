#!/bin/bash

repo_path=~/Destiny/Share/maven-repository
pattern_list="
*.lastUpdated
\$\{*
"

echo 正在搜索...
for item in ${pattern_list}; do
    find "${repo_path}" -name "${item}" -type f -print -exec rm {} \;
done
echo 搜索完毕
