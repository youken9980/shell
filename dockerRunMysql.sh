#!/bin/bash
# set -eux

# 命令行格式： dockerRunMysql.sh 容器标识 映射到宿主机的端口号 root密码
# 服务端命令： docker exec -it mysql-容器标识 mysql --default-character-set="utf8mb4" -u"root" -p"root密码@2024"
# 客户端命令： docker run -it --rm --net mynet youken9980/mysql:5-debian mysql --default-character-set="utf8mb4" -h"mysql-容器标识" -P"3306" -u"root" -p"root密码"

default_name="local"
default_port="0"
default_password="Admin123"
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
dataHome="~/dockerVolume/mysql/data"
logsHome="~/dockerVolume/mysql/logs"
configHome="~/dockerScripts/mysql/config"
configFilePattern="${configHome}/mysql-{{ node }}.cnf"
configFileDefault="~/dockerScripts/mysql/config/mysql.cnf"
imageTag="youken9980/mysql:5-debian"
containerNamePrefix="mysql"
network="mynet"
startPort="3306"
port=""
if [ "${default_port}" = "0" ]; then
    publishPort="false"
else
    publishPort="true"
fi
mysqlRootPassword="${default_password}"

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
    dataPath="$(eval readlink -f ${dataHome}/${node})"
    logsPath="$(eval readlink -f ${logsHome}/${node})"
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
    if [ ! -e "${logsPath}" ]; then
        eval "mkdir -p ${logsPath}"
    fi
    slowLogFile="$(eval readlink -f ${logsPath}/mysql-slow.log)"
    if [ ! -e "${slowLogFile}" ]; then
        eval "touch ${slowLogFile}"
    fi
    configFile="$(echo "${configFilePattern}" | sed "s|{{ node }}|${node}|g")"
    configFile="$(eval readlink -f ${configFile})"
    if [ ! -f "${configFile}" ];then
        configFile="$(eval readlink -f ${configFileDefault})"
    fi
    containerName="${containerNamePrefix}-${node}"
    echo "dataPath: ${dataPath}"
    echo "slowLogFile: ${slowLogFile}"
    echo "configFile: ${configFile}"
        # --restart always \
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
