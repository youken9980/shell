#!/bin/bash
# 各网关、微服务中proto文件所在目录
dir_proto="src/main/proto/"
# 各网关、微服务名称，NDPReportService中无proto文件，故不在列表中
list="
CDMPWebGateway
CDTPWebGateway
CDWPWebGateway
NDPAuthService
NDPCooperativeService
NDPDemandService
NDPEvaluateService
NDPLoggerService
NDPMessageService
NDPOrderService
NDPScheduleService
NDPSplitPackageService
NDPSystemService
NDPUserService
"

# 循环抽取所有服务类名，不去重不排序只按空格分隔，保存至all_service
for dir_project in $list
do
	echo "$dir_project"
	all_service=""
	if [ ! -d "$dir_project/$dir_proto" ]; then
		echo ""
		continue
	fi
	for file_proto in $(ls $dir_project/$dir_proto)
	do
		package=$(cat "$dir_project/$dir_proto$file_proto" | grep "package ")
		# 双井号 "##* " 表示从左边开始删除到最后（最右边）一个空格
		package="${package##* }"
		# 双百分号 "%%;*" 表示从右边开始删除到最后（最左边）一个分号
		package="${package%%;*}"
		service=$(cat "$dir_project/$dir_proto$file_proto" | grep "service ")
		# 单井号 "#* " 表示从左边删除到第一个空格
		service="${service#* }"
		service="${service%% *}"
		service="${service%%'{'*}"
		# echo "$dir_project/$dir_proto$file_proto ---> $package.$service"
		if [ "$service" != "" ]
		then
			all_service+="$package.$service "
		fi
	done
	# 各服务类名抽取完毕，按空格拆分成数组，并去重排序
	for item in $(echo "${all_service}" | tr ' ' '\n' | sort -u)
	do
		# ceres提供的各服务类，非cdi项目提供的服务，均需过滤掉
		if [[ " $item " =~ "cn.enn" ]]
		then
			echo ">>> ignore $item"
		else
			echo "$item"
		fi
	done
	echo ""
done
