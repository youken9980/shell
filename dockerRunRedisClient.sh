#!/bin/bash

docker run -it --rm \
  --network mynet --name redis-client \
  redis:3 redis-cli -h redis -p 6379 --raw
