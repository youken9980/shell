#!/bin/bash

set -eux
for item in $(aliyunpan ls / | grep -v "#  文件大小" | grep -v "文件总数:" | grep -v "\----" | awk '{ print $5 }' | awk -F '/' '{print $1}'); do echo "${item}"; aliyunpan d "${item}"; done
