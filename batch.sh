#!/bin/bash

# 集合列表
arg_list="frontpage gateway service"
if [ $# == 0 ]; then
	# 命令行后未传参数则提示命令行使用方法，sed命令将arg_list中的空格替换为竖线
	echo "Usage: $0 [$(echo ${arg_list} | sed 's/ /|/g')] command"
	exit 1
fi

# 前端项目集合
frontpage_list="
CDMPWebFrontPage
CDTPWebFrontPage
CDWPWebFrontPage
"
# 网关项目集合
gateway_list="
CDMPWebGateway
CDTPWebGateway
CDWPWebGateway
"
# 微服务项目集合
service_list="
NDPAuthService
NDPCooperativeService
NDPDemandService
NDPEvaluateService
NDPKnowledgeService
NDPLoggerService
NDPMessageService
NDPOrderService
NDPReportService
NDPScheduleService
NDPSignaturesService
NDPSplitPackageService
NDPSystemService
NDPUserService
"

# 若第一个参数是frontpage gateway service中的一个，则list取上面相应的集合，否则list取当前目录下所有子目录和文件
list=""
if [[ " ${arg_list} " =~ " $1 " ]]; then
	# 用第一个参数拼接_list，取到上面的集合
	list='$'"$1_list"
else
	# list=$(ls)
	list=$(ls -l | grep ^d | awk '{print $9}')
fi
# eval echo ${list}
# find . -mindepth 1 -maxdepth 1 -type d | sort -n
# 对取到的集合进行循环
for item in $(find . -mindepth 1 -maxdepth 1 -type d | sort -n); do
	# 如果是目录且存在则执行，如果是文件或目录不存在则忽略
	if [ ! -d "${item}" ]; then
		# 是文件或目录不存在
		echo "======== IGNORE ${item}"
		echo ""
		continue
	fi
	# 是目录且存在
	echo "${item}"
	cd ${item}
	# 对参数进行循环，若第一个参数是frontpage gateway service中的一个，则跳过直接执行后面的参数
	for ((i=1;i<=$#;i++)); do
		# 判断第一个参数是frontpage gateway service中的一个则跳过
		if [ $i == 1 ] && [[ " ${arg_list} " =~ " $1 " ]]; then
			continue
		fi
		cmd="$(eval echo '$'"$i")"
		echo ">>> ${cmd}"
		eval ${cmd}
	done
	cd ..
	echo ""
done
