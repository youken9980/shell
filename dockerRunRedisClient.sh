#!/bin/bash

# 命令行格式： dockerRunRedisClient.sh 容器标识 服务端主机端口号 密码

default_name="local"
default_port="6379"
default_password=""
if [ $# == 1 ]; then
    default_name="$1"
fi
if [ $# == 2 ]; then
    default_name="$1"
    default_port="$2"
fi
if [ $# == 3 ]; then
    default_name="$1"
    default_port="$2"
    default_password="$3"
fi
if [ "${default_password}" = "" ]; then
    requirepass=""
else
    requirepass="-a ${default_password}"
fi

docker run -it --rm \
    -e TZ="Asia/Shanghai" \
    --cpus 0.1 --memory 32M --memory-swap -1 \
    --network mynet --name redis-${default_name}-client \
    redis:7-alpine redis-cli -h redis-${default_name} -p ${default_port} ${requirepass} --raw
