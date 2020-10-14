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

container_name="mysql-${default_suffix}"
data_path="$(eval readlink -m ~/dockerVolume/mysql/data/${default_suffix})"
logs_path="$(eval readlink -m ~/dockerVolume/mysql/logs/${default_suffix})"
slow_log_filepath="$(eval readlink -m ${logs_path}/mysql-slow.log)"
config_filepath="$(eval readlink -m ~/dockerVolume/mysql/config/mysql-${default_suffix}.cnf)"
if [ ! -f "${config_filepath}" ];then
    config_filepath="$(eval readlink -f ~/dockerVolume/mysql/config/mysql.cnf)"
fi
echo "Container name: ${container_name}"
echo "Config file: ${config_filepath}"

# 不存在则新建目录
if [ ! -e "${data_path}" ]; then
    eval "mkdir -p ${data_path}"
fi
if [ ! -e "${slow_log_filepath}" ]; then
    eval "mkdir -p ${logs_path}"
    eval "touch ${slow_log_filepath}"
fi
if [ "${default_port}" = "0" ]; then
    default_port=""
else
    default_port="-p ${default_port}:3306"
fi

function dockerRm() {
    containerId=$(docker ps -aq --filter name="${container_name}")
    if [ "${containerId}" != "" ]; then
        docker rm $(docker stop "${containerId}")
    fi
}

function dockerRun() {
    docker run -d ${default_port} \
        -v ${data_path}:/var/lib/mysql \
        -v ${config_filepath}:/etc/mysql/mysql.cnf \
        -v ${slow_log_filepath}:/etc/mysql/logs/mysql-slow.log \
        --network mynet --name ${container_name} \
        -e TZ="Asia/Shanghai" \
        -e MYSQL_ROOT_PASSWORD=admin123 \
        mysql:5 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
}

function dockerLogsUntil() {
    containerId=$(docker ps -aq --filter name="${container_name}")
    nohup docker logs -f "${containerId}" > "/tmp/${containerId}.log" 2>&1 &
    sleep 3s
    PID=$(ps aux | grep "docker logs" | grep ${containerId} | awk '{print $2}' | sort -nr | head -1)
    echo ${PID}
    tail -f --pid=${PID} /tmp/${containerId}.log | sed '/port:[[:space:]]3306[[:space:]][[:space:]]MySQL[[:space:]]Community[[:space:]]Server[[:space:]](GPL)/q'
    kill -9 ${PID}
    rm /tmp/${containerId}.log
}

dockerRm
dockerRun
dockerLogsUntil
