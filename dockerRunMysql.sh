#!/bin/bash

default="local"
if [ $# == 1 ]; then
    default="$1"
fi

path_mysql_data="~/dockerVolumn/mysql/data/"

eval "docker run -d -p 3306:3306 \
  -v ${path_mysql_data}${default}:/var/lib/mysql \
  -v ~/dockerVolumn/mysql/config/mysql.cnf:/etc/mysql/mysql.cnf \
  --network mynet --name mysql-${default} \
  -e MYSQL_ROOT_PASSWORD=admin123 mysql:5 \
  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci"
docker logs -f "mysql-${default}"
