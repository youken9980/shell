#!/bin/bash

# 集合列表
arg_list="clean compile package install deploy spring-boot:run jetty:run docker:build dockerfile:build -P -X"
for ((i=1; i<=$#; i++)); do
	arg="$(eval echo '$'"$i")"
	if [[ ! "${arg_list}" =~ "${arg}" ]]; then
        if [[ "${arg:0:2}" != "-P" ]]; then
            # echo "${arg} -> ${arg:0:2}"
            # 参数错误则提示命令行使用方法，sed命令将arg_list中的空格替换为竖线
            echo "Usage: $0 [$(echo ${arg_list} | sed 's/ /|/g')]"
            exit 1
        fi
	fi
done

cmd="mvn clean"
for ((i=1; i<=$#; i++)); do
	cmd="${cmd} $(eval echo '$'"$i")"
done
cmd="${cmd} -Dmaven.test.skip=true -U"

echo ">>> ${cmd}"
eval ${cmd}
