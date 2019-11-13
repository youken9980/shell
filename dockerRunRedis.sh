#!/bin/bash

# docker run -d -p 6379:6379 \
#   -v ~/dockerVolumn/redis/data/local:/data \
#   --network mynet --name redis-local \
#   redis redis-server --appendonly yes

default="local"
if [ $# == 1 ]; then
    default="$1"
fi

data_path="~/dockerVolumn/redis/data/"

eval "docker run -d -p 6379:6379 \
  -e TZ=\"Asia/Shanghai\" \
  -v ${data_path}${default}:/data \
  --network mynet --name redis-${default} \
  redis redis-server --appendonly yes"
docker logs -f "redis-${default}"
