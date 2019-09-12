#!/bin/bash

default="local"
if [ $# == 1 ]; then
    default="$1"
fi

data_path="~/dockerVolumn/mysql/data/"

eval "docker run -d -p 3306:3306 \
  -v ${data_path}${default}:/var/lib/mysql \
  -v ~/dockerVolumn/mysql/config/mysql.cnf:/etc/mysql/mysql.cnf \
  --network mynet --name mysql-${default} \
  -e MYSQL_ROOT_PASSWORD=admin123 mysql:5 \
  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci"
docker logs -f "mysql-${default}"
