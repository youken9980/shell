#!/bin/bash

# 有一个参数但不是frontpage或大于一个参数
if [ $# == 1 ] && [[ ! " frontpage " =~ " $1 " ]] || [ $# -gt 1 ]; then
	# 命令行后未传参数则提示命令行使用方法
	echo "用法1: $0"
	echo "　　克隆后台开发1个架构项目、3个网关项目、13个微服务项目"
	echo "用法2: $0 frontpage"
	echo "　　克隆前端开发3个页面项目"
	exit 1
fi

frontpage_list="
CDMPWebFrontPage
CDTPWebFrontPage
CDWPWebFrontPage
"
default_list="
CDMPWebGateway
CDTPWebGateway
CDWPWebGateway
NDPAuthService
NDPCooperativeService
NDPDemandService
NDPEvaluateService
NDPFramework
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

list=""
if [[ " frontpage " =~ " $1 " ]]; then
	list=${frontpage_list}
else
	list=${default_list}
fi

for item in ${list}; do
	$(git clone "https://source.enncloud.cn/CDI/${item}.git")
	echo ""
done
