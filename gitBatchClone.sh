#!/bin/bash

url=""
list="
"

if [ -z "${url}" ]; then
	exit 1
fi

for item in ${list}; do
	$(git clone "${url}/${item}.git")
	echo ""
done
