#!/bin/bash

default="local"
if [ $# == 1 ]; then
    default="$1"
fi

docker run -it --rm \
    -e TZ="Asia/Shanghai" \
    --cpus 0.1 --memory 31M --memory-swap -1 \
    --network mynet --name redis-${default}-client \
    redis:alpine redis-cli -h redis-${default} -p 6379 --raw
