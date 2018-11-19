#!/bin/bash

########
# 
# 抽取各网关、微服务proto文件中所有Service类，供后台开发同学直连调试使用
# 
########

host_default="10.39.1.237"
# host_default="127.0.0.1"
host_local="127.0.0.1"
# 配置各微服务提供方的IP地址，默认由注册中心提供，直连时修改
service_host_auth="${host_default}"
service_host_cooperative="${host_default}"
service_host_demand="${host_default}"
service_host_evaluate="${host_default}"
service_host_knowledge="${host_default}"
service_host_logger="${host_default}"
service_host_message="${host_default}"
service_host_order="${host_default}"
service_host_schedule="${host_default}"
service_host_signatures="${host_default}"
service_host_split="${host_default}"
service_host_system="${host_default}"
service_host_user="${host_default}"

# 配置各微服务提供方的端口号，与微服务src/main/resources/application.properties中ceres.application.servicePort一致
service_port_auth="50069"
service_port_cooperative="50068"
service_port_demand="50058"
service_port_evaluate="50055"
service_port_knowledge="50063"
service_port_logger="50060"
service_port_message="50061"
service_port_order="50062"
service_port_schedule="50065"
service_port_signatures="50073"
service_port_split="50064"
service_port_system="50066"
service_port_user="50053"

if [ ! -d "NDPFramework" ]; then
	exit 1
fi

# 获取本机IP，暂时无用
# ip_local="$(ifconfig en1 | grep -v 'inet6' | grep 'inet' | awk '{print $2}')"
ip=""
port=""
all_service=""
# 各网关、微服务中proto文件所在目录
dir_proto="src/main/proto/"
# 生成的ceres框架配置文件名称，请勿修改
filepath="resolve.properties"
# 各网关、微服务中资源文件所在目录，需将生成的配置文件放在该目录
dir_resources="src/main/resources/"
# 各微服务API名称，NDPThirdPartyApi中的proto文件无需指定IP和端口号，故不在列表中
list_api="
NDPAuthApi
NDPCooperativeApi
NDPDemandApi
NDPEvaluateApi
NDPKnowledgeApi
NDPLoggerApi
NDPMessageApi
NDPOrderApi
NDPSignaturesApi
NDPSplitPackageApi
NDPSystemApi
NDPUserApi
"
# 循环抽取所有服务类名，不去重不排序只按空格分隔，保存至all_service
for dir_project in ${list_api}
do
	echo "${dir_project}"
	for file_proto in $(ls "NDPFramework/${dir_project}/${dir_proto}")
	do
		package=$(cat "NDPFramework/${dir_project}/${dir_proto}${file_proto}" | grep "package ")
		# 双井号 "##* " 表示从左边开始删除到最后（最右边）一个空格
		package="${package##* }"
		# 双百分号 "%%;*" 表示从右边开始删除到最后（最左边）一个分号
		package="${package%%;*}"
		service=$(cat "NDPFramework/${dir_project}/${dir_proto}${file_proto}" | grep "service ")
		# 单井号 "#* " 表示从左边删除到第一个空格
		service="${service#* }"
		service="${service%% *}"
		service="${service%%'{'*}"
		# echo "NDPFramework/${dir_project}/${dir_proto}${file_proto} ---> ${package}.${service}"
		if [ "${service}" != "" ]
		then
			case ${package} in
				# 鉴权
				"auth")
					ip="${service_host_auth}"
					port="${service_port_auth}"
				;;
				# 协同
				"cooperative")
					ip="${service_host_cooperative}"
					port="${service_port_cooperative}"
				;;
				# 需求
				"demand")
					ip="${service_host_demand}"
					port="${service_port_demand}"
				;;
				# 评价
				"evaluate"|"appraise")
					ip="${service_host_evaluate}"
					port="${service_port_evaluate}"
				;;
				# 知识共享
				"knowledge")
					ip="${service_host_knowledge}"
					port="${service_port_knowledge}"
				;;
				# 日志
				"chart"|"logger")
					ip="${service_host_logger}"
					port="${service_port_logger}"
				;;
				# 消息
				"message")
					ip="${service_host_message}"
					port="${service_port_message}"
				;;
				# 订单
				"order")
					ip="${service_host_order}"
					port="${service_port_order}"
				;;
				# 签章
				"signatures")
					ip="${service_host_signatures}"
					port="${service_port_signatures}"
				;;
				# 拆包
				"split"|"splitpackage")
					ip="${service_host_split}"
					port="${service_port_split}"
				;;
				# 系统
				"system")
					ip="${service_host_system}"
					port="${service_port_system}"
				;;
				# 用户
				"user"|"im"|"zoom")
					ip="${service_host_user}"
					port="${service_port_user}"
				;;
				# 其它
				*)
					ip=""
					port=""
			esac
			if [[ "${ip}" == "" ]]; then
				continue
			fi
			service="${package}.${service}=${ip}:${port}"
			all_service+="${service} "
		fi
	done
done
echo ""

# 各服务类名抽取完毕，按空格拆分成数组，并去重排序，写入filepath指定的文件中
rm "${filepath}"
touch "${filepath}"
for item in $(echo "${all_service}" | tr ' ' '\n' | sort -u)
do
	# ceres提供的各服务类，非cdi项目提供的服务，均需过滤掉
	if [[ " ${item} " =~ "cn.enn" ]]
	then
		echo ">>> ignore ${item}"
	else
		echo "${item}" >> "${filepath}"
	fi
done
# 列印生成的文件内容
cat "${filepath}"
echo ""

# 将生成的文件复制到各网关、微服务项目目标路径下
list_project="
CDMPWebGateway
CDTPWebGateway
CDWPWebGateway
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
for dir_project in ${list_project}
do
	echo "${dir_project}"
	if [ ! -d "${dir_project}" ]; then
		continue
	fi
	cmd="cp ${filepath} ${dir_project}/${dir_resources}${filepath}"
	echo ">>> ${cmd}"
	eval ${cmd}
done
echo ""
