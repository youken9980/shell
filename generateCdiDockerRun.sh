#!/bin/bash

# 当前目录下必须有cdi_env.txt文件、settings_enn_xd.xml文件和generateResolveProperties.sh文件
if [ ! -f "./cdi_env.txt" ] || [ ! -f "./settings_enn_xd.xml" ] || [ ! -f "./generateResolveProperties.sh" ] || [ $# -gt 1 ]; then
	# 命令行后未传参数则提示命令行使用方法
	echo "当前目录下必须有 cdi_env.txt 文件、settings_enn_xd.xml 文件和 generateResolveProperties.sh 文件"
	echo "用法1: $0"
	echo "　　没有参数，默认使用 master 分支生成 docker 启动命令"
	echo "用法2: $0 分支名称"
	echo "　　使用指定分支名称生成 docker 启动命令"
	exit 1
fi

# 分支
branch=""
# 没有参数，或参数为空
if [ $# == 0 ] || [ -z "$1" ]; then
	branch="master"
else
	branch="$1"
fi

# 脚本保存目录
dest_dir="/Volumes/Destiny/Share/docker/cdi/command"
if [ ! -d "${dest_dir}" ]; then
	mkdir -p "${dest_dir}"
fi

# 网关与微服务项目集合
project_list="
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

# 配置各微服务提供方的端口号，与微服务src/main/resources/application.properties中ceres.application.servicePort一致
CDMPWebGateway="8083"
CDTPWebGateway="8081"
CDWPWebGateway="8082"
NDPAuthService="50069"
NDPCooperativeService="50068"
NDPDemandService="50058"
NDPEvaluateService="50055"
NDPKnowledgeService="50063"
NDPLoggerService="50060"
NDPMessageService="50061"
NDPOrderService="50062"
NDPReportService="8888"
NDPScheduleService="50065"
NDPSignaturesService="50070"
NDPSplitPackageService="50064"
NDPSystemService="50066"
NDPUserService="50053"

for item in ${project_list}; do
	port="$(eval echo '$'"${item}")"
	file_name="${dest_dir}/${item}.sh"
	if [ -f "${file_name}" ]; then
		rm "${file_name}"
	fi
	touch "${file_name}"
	chmod a+x "${file_name}"
	echo "#!/bin/bash" >> ${file_name}
	echo "" >> ${file_name}
	echo "container_id=\"\$(docker ps -f name=${item} -aq)\"" >> ${file_name}
	echo "if [ -n \"\${container_id}\" ]; then" >> ${file_name}
	echo "  docker rm \$(docker stop ${item})" >> ${file_name}
	echo "fi" >> ${file_name}
	echo "docker run -it -d \\" >> ${file_name}
	echo "  --env-file ./cdi_env.txt \\" >> ${file_name}
	echo "  -e CDI_PROJECT=${item} \\" >> ${file_name}
	echo "  -e CDI_BRANCH=${branch} \\" >> ${file_name}
	echo "  -v /Volumes/Destiny/Share/maven-repository:/Volumes/Destiny/Share/maven-repository \\" >> ${file_name}
	echo "  -v /Volumes/Destiny/Share/docker/cdi/command/settings_enn_xd.xml:/usr/share/maven/conf/settings.xml \\" >> ${file_name}
	echo "  -v /Volumes/Destiny/Share/docker/cdi/command/generateResolveProperties.sh:/app/generateResolveProperties.sh \\" >> ${file_name}
	echo "  --expose ${port} -p ${port}:${port} --network mynet \\" >> ${file_name}
	echo "  --name ${item} yangjian/cdi-backend" >> ${file_name}
	echo "" >> ${file_name}
	echo "docker logs -f ${item}" >> ${file_name}
done
ls -l
