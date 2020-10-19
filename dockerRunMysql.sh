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
echo "Data path: ${data_path}"

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
    containerId=$(docker ps -aq --filter $1)
    if [ "${containerId}" != "" ]; then
        docker rm $(docker stop "${containerId}")
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
    -v ${data_path}:/var/lib/mysql \
    -v ${config_filepath}:/etc/mysql/mysql.cnf \
    -v ${slow_log_filepath}:/etc/mysql/logs/mysql-slow.log \
    --network mynet --name ${container_name} \
    -e TZ="Asia/Shanghai" \
    -e MYSQL_ROOT_PASSWORD=admin123 \
    mysql:5 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
dockerLogsUntil "name=${container_name}" "port:[[:space:]]3306[[:space:]][[:space:]]MySQL[[:space:]]Community[[:space:]]Server[[:space:]](GPL)"
