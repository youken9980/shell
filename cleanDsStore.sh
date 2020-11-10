#!/bin/bash

echo 正在搜索...
find ~/ -name .DS_Store -type f -print | grep -v 'Destiny/Share/github/' | xargs rm
echo 搜索完毕
