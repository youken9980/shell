#!/bin/bash

# 当前目录下必须有batch.sh文件和NDPFramework目录
# 参数个数为零或有且仅有一个frontpage或有两个参数但第一个不是frontpage或大于两个参数
if [ ! -f "./batch.sh" ] || [ ! -d "NDPFramework" ] || [ $# -gt 0 ]; then
	# 命令行后未传参数则提示命令行使用方法
	echo "当前目录下必须有 batch.sh 文件和 NDPFramework 目录"
	echo "用法: $0"
	echo "　　对后台开发的1个公用包、12个API项目、3个网关项目、13个微服务项目，批量清理并编译"
	exit 1
fi

log_file_name="log.txt"
if [[ -f "${log_file_name}" ]]; then
	rm ${log_file_name}
fi
touch ${log_file_name}

cmd1="rm *.iml"
cmd2="rm -rf target/"
cmd3="rm -rf .idea/"
cmd4="mvn clean compile -Dmaven.test.skip=true -U"
# 在NDPFramework目录下执行操作
cd "NDPFramework"
../batch.sh "${cmd1}" "${cmd2}" "${cmd3}" "${cmd4}" | tee -a "${log_file_name}"
cd ..
# 在当前目录下执行操作
./batch.sh "gateway" "${cmd1}" "${cmd2}" "${cmd3}" "${cmd4}" | tee -a "${log_file_name}"
./batch.sh "service" "${cmd1}" "${cmd2}" "${cmd3}" "${cmd4}" | tee -a "${log_file_name}"
# 删除当前目录下的.idea目录
echo "${cmd3}"
${cmd3}
echo "========"
grep "\[INFO] B" "${log_file_name}"
echo ""

rm ${log_file_name}
