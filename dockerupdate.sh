#!/bin/bash

args=""
if [ $# -gt 0 ]
then
	args="| $1"
fi
images="docker images -f dangling=false | grep -v 'REPOSITORY' | grep -v '<none>' $args"
eval "${images}" | while read img; do
	repo="$(echo ${img} | awk '{print $1":"$2}')"
	size="$(echo ${img} | awk '{print $7}')"
	echo "${repo} ${size}"
	cmd="docker pull ${repo}"
	eval "${cmd}"
	echo ""
done
echo ""
docker images
