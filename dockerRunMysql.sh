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
cleanup="false"
dataHome="~/dockerVolume/mysql/data"
logsHome="~/dockerVolume/mysql/logs"
configHome="~/dockerScripts/mysql/config"
configFilePattern="${configHome}/mysql-{{ node }}.cnf"
configFileDefault="~/dockerScripts/mysql/config/mysql.cnf"
imageTag="mysql:5"
containerNamePrefix="mysql"
network="mynet"
startPort="3306"
if [ "${default_port}" = "0" ]; then
    publishPort="false"
else
    publishPort="true"
fi
mysqlRootPassword="admin123"

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

if [ "${publishPort}" = "first" -a "${port}" = "${startPort}" -o "${publishPort}" = "true" ]; then
    startPort="${default_port}"
fi
port="${startPort}"
for node in ${nodeList[@]}; do
    publish=""
    if [ "${publishPort}" = "first" -a "${port}" = "${startPort}" -o "${publishPort}" = "true" ]; then
        publish="-p 127.0.0.1:${port}:3306"
    fi
    dataPath="$(eval readlink -m ${dataHome}/${node})"
    logsPath="$(eval readlink -m ${logsHome}/${node})"
    slowLogFile="$(eval readlink -m ${logsPath}/mysql-slow.log)"
    configFile="$(echo "${configFilePattern}" | sed "s|{{ node }}|${node}|g")"
    configFile="$(eval readlink -f ${configFile})"
    if [ ! -f "${configFile}" ];then
        configFile="$(eval readlink -f ${configFileDefault})"
    fi
    containerName="${containerNamePrefix}-${node}"
    echo "dataPath: ${dataPath}"
    echo "slowLogFile: ${slowLogFile}"
    echo "configFile: ${configFile}"
    if [ "${cleanup}" = "true" ]; then
        if [ -e "${dataPath}" ]; then
            eval "rm -rf ${dataPath}"
        fi
        if [ -e "${slowLogFile}" ]; then
            eval "rm -rf ${logsPath}"
        fi
    fi
    if [ ! -e "${dataPath}" ]; then
        eval "mkdir -p ${dataPath}"
    fi
    if [ ! -e "${slowLogFile}" ]; then
        eval "mkdir -p ${logsPath}"
        eval "touch ${slowLogFile}"
    fi
    docker run -d ${publish} \
        --cpus 4 --memory 1536M --memory-swap -1 \
        -e TZ="Asia/Shanghai" \
        -e MYSQL_ROOT_PASSWORD="${mysqlRootPassword}" \
        -v ${dataPath}:/var/lib/mysql \
        -v ${configFile}:/etc/mysql/mysql.cnf \
        -v ${slowLogFile}:/etc/mysql/logs/mysql-slow.log \
        --network ${network} --name ${containerName} \
        ${imageTag} --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    dockerLogsUntil "name=${containerName}" "port:[[:space:]]3306[[:space:]][[:space:]]MySQL[[:space:]]Community[[:space:]]Server[[:space:]](GPL)"
    port=$[$port + 1]
done
