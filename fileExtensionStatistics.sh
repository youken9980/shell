#!/bin/bash
# 为动静分离统计当前目录(static)下所有文件后缀

array=()
for item in $(tree -f); do
    if [ ! -f "${item}" ]; then
        continue
    fi

    echo "${item}"
    size=$(echo "${item}" | awk -F '.' '{ print NF }')
    if [ "${size}" -lt 3 ]; then
        continue
    fi

    ext="${item##*.}"
    count=$(echo "${array[@]}" | grep "${ext}" | wc -l)
    if [ "${count}" -gt 0 ]; then
        continue
    fi

    array+=("${ext}")
done

array=($(echo "${array[@]}" | tr ' ' '\n' | sort -u))
echo "${array[@]}" | tr ' ' '|'
