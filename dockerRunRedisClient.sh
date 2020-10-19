#!/bin/bash

default="local"
if [ $# == 1 ]; then
    default="$1"
fi

docker run -it --rm \
    -e TZ="Asia/Shanghai" \
    --network mynet --name redis-${default}-client \
    redis:alpine redis-cli -h redis-${default} -p 6379 --raw
