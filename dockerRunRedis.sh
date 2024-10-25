#!/bin/bash

# 命令行格式： dockerRunRedis.sh 容器标识 映射到宿主机的端口号 密码

default_name="local"
default_port="0"
default_password=""
if [ $# == 1 ]; then
    default_name="$1"
fi
if [ $# == 2 ]; then
    default_name="$1"
    default_port="$2"
fi
if [ $# == 3 ]; then
    default_name="$1"
    default_port="$2"
    default_password="$3"
fi

nodeList+=("${default_name}")
cleanup="false"
dataHome="~/dockerVolume/redis/data"
imageTag="redis:7-alpine"
containerNamePrefix="redis"
network="mynet"
startPort="6379"
if [ "${default_port}" = "0" ]; then
    publishPort="false"
else
    publishPort="true"
fi
if [ "${default_password}" = "" ]; then
    requirePassword="false"
else
    requirePassword="true"
fi

function dockerRm() {
    filter="$1"
    containerId=$(docker ps -aq --filter "${filter}")
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
    PID=$(ps aux | grep "docker" | grep ${containerId} | awk '{print $2}' | sort -nr | head -1)
    if [ "${PID}" != "" ]; then
        eval "tail -f --pid=${PID} /tmp/${containerId}.log | sed '/${endpoint}/q'"
        kill ${PID}
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
    requirepass=""
    if [ "${requirePassword}" = "true" ]; then
        requirepass="--requirepass ${default_password}"
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
#        -v ${dataPath}:/data \
        # --restart always \
    docker run -d ${publish} \
        -e TZ="Asia/Shanghai" \
        --memory 32M --memory-swap -1 \
        --network ${network} --name ${containerName} \
        ${imageTag} redis-server --appendonly yes ${requirepass}
    dockerLogsUntil "name=${containerName}" "[[:space:]]Ready[[:space:]]to[[:space:]]accept[[:space:]]connections"
    port=$[$port + 1]
done
