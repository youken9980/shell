#!/bin/bash

docker run -d --expose 3306 \
  -v ~/dockerVolumn/mysql/data/gogs:/var/lib/mysql \
  -v ~/dockerVolumn/mysql/config/mysql.cnf:/etc/mysql/mysql.cnf \
  -e MYSQL_ROOT_PASSWORD=admin123 \
  --network mynet --name mysql-gogs \
  mysql:5 \
  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

docker run -d -p 3000:3000 \
  -v ~/dockerVolumn/gogs/data:/data \
  --network mynet --name gogs \
  gogs/gogs

docker logs -f gogs
