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

nodeList+=("${default_suffix}")
cleanup="true"
dataHome="~/dockerVolume/redis/data"
imageTag="redis:alpine"
containerNamePrefix="redis"
network="mynet"
startPort="6379"
if [ "${default_port}" = "0" ]; then
    publishPort="false"
else
    publishPort="true"
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
    sleep 1s
    PID=$(ps aux | grep "docker" | grep ${containerId} | awk '{print $2}' | sort -nr | head -1)
    if [ "${PID}" != "" ]; then
        eval "tail -f --pid=${PID} /tmp/${containerId}.log | sed '/${endpoint}/q'"
        kill -9 ${PID}
        rm /tmp/${containerId}.log
    fi
}

for node in ${nodeList[@]}; do
    containerName="${containerNamePrefix}-${node}"
    dockerRm "name=${containerName}"
done

port="${startPort}"
for node in ${nodeList[@]}; do
    publish=""
    if [ "${publishPort}" = "first" -a "${port}" = "${startPort}" -o "${publishPort}" = "true" ]; then
        publish="-p ${port}:6379"
    fi
    dataPath="$(eval readlink -m ${dataHome}/${node})"
    containerName="${containerNamePrefix}-${node}"
    echo "dataPath: ${dataPath}"
    if [ "${cleanup}" = "true" ]; then
        if [ -e "${dataPath}" ]; then
            eval "rm -rf ${dataPath}"
        fi
    fi
    if [ ! -e "${dataPath}" ]; then
        eval "mkdir -p ${dataPath}"
    fi
    docker run -d ${publish} \
        -e TZ="Asia/Shanghai" \
        -v ${dataPath}:/data \
        --cpus 0.2 --memory 64M --memory-swap -1 \
        --network ${network} --name ${containerName} \
        ${imageTag} redis-server --appendonly yes
    dockerLogsUntil "name=${containerName}" "[[:space:]]Ready[[:space:]]to[[:space:]]accept[[:space:]]connections"
    port=$[$port + 1]
done
