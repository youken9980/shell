#!/bin/bash

args=""
if [ $# -gt 0 ]
then
	args="| $1"
fi

docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}" -f dangling=false | grep -v 'REPOSITORY' | grep -v '<none>' ${args}
