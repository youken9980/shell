#!/bin/bash

docker run -d -p 3306:3306 \
  -v ~/dockerVolumn/mysql/data:/var/lib/mysql \
  -v ~/dockerVolumn/mysql/config/mysql.cnf:/etc/mysql/mysql.cnf \
  --network mynet --name mysql -h mysql \
  -e MYSQL_ROOT_PASSWORD=admin123 mysql:5 \
  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
