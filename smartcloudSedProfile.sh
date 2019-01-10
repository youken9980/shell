#!/bin/bash

default_profile="yangjian_docker"
if [ $# == 1 ]; then
    default_profile="$1"
fi

flag="spring.cloud.config.profile="
file_list="find . -name bootstrap.properties -type f -print"
eval "${file_list}" | while read file; do
    echo ">>> ${file}"
    count=$(sed -n "/${flag}/=" "${file}")
    if [ ${#count} -gt 0 ]; then
        sed -i "" "/${flag}/d" "${file}"
        echo "${flag}${default_profile}" >> "${file}"
        cat "${file}"
    fi
    echo ""
done
