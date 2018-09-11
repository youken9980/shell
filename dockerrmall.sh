#!/bin/bash

docker rm $(docker stop $(docker ps -aq))
