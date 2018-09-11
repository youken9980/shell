#!/bin/bash

# 集合列表
arg_list="clean compile package install deploy spring-boot:run jetty:run docker:build"
for ((i=1; i<=$#; i++)); do
	# echo "$(eval echo '$'"$i")"
	if [[ ! " ${arg_list} " =~ " $(eval echo '$'"$i") " ]]; then
		# 参数错误则提示命令行使用方法，sed命令将arg_list中的空格替换为竖线
		echo "Usage: $0 [$(echo ${arg_list} | sed 's/ /|/g')]"
		exit 1
	fi
done

cmd="mvn clean"
for ((i=1; i<=$#; i++)); do
	cmd="${cmd} $(eval echo '$'"$i")"
done
cmd="${cmd} -Dmaven.test.skip=true -U"

echo ">>> ${cmd}"
eval ${cmd}
