#!/bin/bash

default="local"
if [ $# == 1 ]; then
    default="$1"
fi

data_path="~/dockerVolumn/mysql/data/"
logs_path="~/dockerVolumn/mysql/logs/"

eval "docker run -d -p 3306:3306 \
  -v ${data_path}${default}:/var/lib/mysql \
  -v ~/dockerVolumn/mysql/config/mysql.cnf:/etc/mysql/mysql.cnf \
  -v ${logs_path}${default}/mysql-slow.log:/etc/mysql/logs/mysql-slow.log \
  --network mynet --name mysql-${default} \
  -e TZ=\"Asia/Shanghai\" \
  -e MYSQL_ROOT_PASSWORD=admin123 mysql:5 \
  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci"
docker logs -f "mysql-${default}"
