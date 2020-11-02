#!/bin/bash

default_suffix="local"
default_port="0"
if [ $# == 1 ]; then
    default_suffix="$1"
fi
if [ $# == 2 ]; then
    default_suffix="$1"
    default_port="$2"
fi

container_name="redis-${default_suffix}"
data_path="$(eval readlink -m ~/dockerVolume/redis/data/${default_suffix})"

if [ ! -e "${data_path}" ]; then
    eval "mkdir -p ${data_path}"
fi
if [ "${default_port}" = "0" ]; then
    default_port=""
else
    default_port="-p ${default_port}:6379"
fi

function dockerRm() {
    containerId=$(docker ps -aq --filter $1)
    runningContainerId=$(docker ps -aq --filter status=running --filter $1)
    if [ "${runningContainerId}" != "" ]; then
        docker stop ${runningContainerId}
    fi
    if [ "${containerId}" != "" ]; then
        docker rm ${containerId}
    fi
}

function dockerLogsUntil() {
    filter="$1"
    endpoint="$2"
    containerId=$(docker ps -aq --filter "${filter}")
    nohup docker logs -f "${containerId}" > "/tmp/${containerId}.log" 2>&1 &
    sleep 3s
    PID=$(ps aux | grep "docker" | grep ${containerId} | awk '{print $2}' | sort -nr | head -1)
    if [ "${PID}" != "" ]; then
        eval "tail -f --pid=${PID} /tmp/${containerId}.log | sed '/${endpoint}/q'"
        kill -9 ${PID}
        rm /tmp/${containerId}.log
    fi
}

dockerRm "name=${container_name}"
docker run -d ${default_port} \
    -v ${data_path}:/data \
    --network mynet --name ${container_name} \
    -e TZ="Asia/Shanghai" \
    redis:alpine redis-server --appendonly yes
dockerLogsUntil "name=${container_name}" "[[:space:]]Ready[[:space:]]to[[:space:]]accept[[:space:]]connections"
