#!/bin/bash

# docker run -it --rm \
#   --network mynet --name redis-client \
#   redis redis-cli -h redis-local -p 6379 --raw

default="local"
if [ $# == 1 ]; then
    default="$1"
fi

eval "docker run -it --rm \
  --network mynet --name redis-${default}-client \
  redis redis-cli -h redis-${default} -p 6379 --raw"
