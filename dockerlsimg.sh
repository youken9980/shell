#!/bin/bash

args=""
if [ $# -gt 0 ]
then
	args="| $1"
fi
images="docker images -f dangling=false | grep -v 'REPOSITORY' | grep -v '<none>' $args"
eval "${images}" | while read img; do
 	echo "$(echo ${img} | awk '{print $1":"$2"    "$3"    "$7}')"
done
