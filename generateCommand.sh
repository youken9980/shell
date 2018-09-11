#!/bin/bash

# 分支
branch="feature_demand_of_phase2"
# 脚本保存目录
dest_dir="C:\\Users\\Administrator\\Desktop\\command"
# 代码盘符
project_disk="D:"
# 代码根目录
project_root="\\idea_workspace"
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
jetty_run="mvn clean jetty:run -Dmaven.test.skip=true -U"
sprint_boot_run="mvn clean spring-boot:run -Dmaven.test.skip=true -U"

if [ ! -d "${dest_dir}" ]; then
	mkdir "${dest_dir}"
fi

function generate() {
	list=$1
	run_cmd=$2
	for item in ${list}; do
		if [ ! -d "${item}" ]; then
			echo "======== IGNORE ${item}"
			echo ""
			continue
		fi
		echo "${item}"
		file_name="${dest_dir}\\${item}.cmd"
		echo "title ${item}" > ${file_name}
		echo "${project_disk}" >> ${file_name}
		echo "cd ${project_disk}${project_root}\\${item}" >> ${file_name}
		echo "git checkout ${branch}" >> ${file_name}
		echo "git pull --rebase" >> ${file_name}
		echo "${run_cmd}" >> ${file_name}
	done
}

generate "${service_list}" "${sprint_boot_run}"
generate "${gateway_list}" "${jetty_run}"
