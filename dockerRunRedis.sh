#!/bin/bash

docker run -d -p 6379:6379 \
  -v ~/dockerVolumn/redis/data:/data \
  --network mynet --name redis-local \
  redis:3 redis-server --appendonly yes
