#!/bin/bash

default="local"
if [ $# == 1 ]; then
    default="$1"
fi

container_name="redis-${default}"
data_path="~/dockerVolume/redis/data/${default}"

# docker rm $(docker stop "${container_name}")
eval "docker run -d -p 6379:6379 \
  -v ${data_path}:/data \
  --network mynet --name ${container_name} \
  -e TZ=\"Asia/Shanghai\" \
  redis:alpine redis-server --appendonly yes"
docker logs -f "redis-${default}"
