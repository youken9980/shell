#!/bin/bash

default="local"
if [ $# == 1 ]; then
    default="$1"
fi

container_name="mysql-${default}"
data_path="~/dockerVolume/mysql/data/${default}"
logs_path="~/dockerVolume/mysql/logs/${default}"
slow_log_filepath="${logs_path}/mysql-slow.log"
config_filepath="~/dockerVolume/mysql/config/mysql.cnf"

# 不存在则新建目录
if [ ! -e "${data_path}" ]; then
    cmd="mkdir -p ${data_path}"
    echo "${cmd}"
    eval "${cmd}"
fi
if [ ! -e "${slow_log_filepath}" ]; then
    cmd="mkdir -p ${logs_path}"
    echo "${cmd}"
    eval "${cmd}"
    cmd="touch ${slow_log_filepath}"
    echo "${cmd}"
    eval "${cmd}"
fi

# docker rm $(docker stop "${container_name}")
eval "docker run -d -p 3306:3306 \
  -v ${data_path}:/var/lib/mysql \
  -v ${config_filepath}:/etc/mysql/mysql.cnf \
  -v ${slow_log_filepath}:/etc/mysql/logs/mysql-slow.log \
  --network mynet --name ${container_name} \
  -e TZ=\"Asia/Shanghai\" \
  -e MYSQL_ROOT_PASSWORD=admin123 \
  mysql:5 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci"
docker logs -f "${container_name}"
