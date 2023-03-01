#!/bin/bash

docker run -d --expose 3306 \
  -v ~/dockerVolume/mysql/data/gogs:/var/lib/mysql \
  -v ~/dockerVolume/mysql/config/mysql.cnf:/etc/mysql/mysql.cnf \
  -e TZ="Asia/Shanghai" \
  -e MYSQL_ROOT_PASSWORD=admin123 \
  --network mynet --name mysql-gogs \
  mysql:5.7-debian \
  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

docker run -d -p 3000:3000 \
  -e TZ="Asia/Shanghai" \
  -v ~/dockerVolume/gogs/data:/data \
  --network mynet --name gogs \
  gogs/gogs:latest

docker logs -f gogs
