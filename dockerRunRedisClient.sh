#!/bin/bash

docker run -it --rm \
  --network mynet --name redis-client \
  redis redis-cli -h redis-local -p 6379 --raw
