#!/bin/bash

########
# 批量更改公用包和API项目版本号，以及其它项目中的引用处。
# 用法：修改下文各项目的版本号，然后执行该脚本。
# 0.0.1-SNAPSHOT
# HOTFIX-SNAPSHOT
# FEATURE-XXX-SNAPSHOT
########

if [ ! -d "NDPFramework" ]; then
	echo "当前路径下没有NDPFramework目录"
	exit 1
fi

default_version="0.0.1-SNAPSHOT"
dev_version="DEV-SNAPSHOT"

NDPCore="${default_version}"
NDPBaseApi="${default_version}"
NDPAuthApi="${default_version}"
NDPCooperativeApi="${default_version}"
NDPDemandApi="${default_version}"
NDPEvaluateApi="${default_version}"
NDPKnowledgeApi="${default_version}"
NDPLoggerApi="${default_version}"
NDPMessageApi="${default_version}"
NDPOrderApi="${default_version}"
NDPSignaturesApi="${default_version}"
NDPSplitPackageApi="${default_version}"
NDPSystemApi="${default_version}"
NDPThirdPartyApi="${default_version}"
NDPUserApi="${default_version}"

file_name="pom.xml"

framework_list="
NDPCore
NDPBaseApi
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
NDPThirdPartyApi
NDPUserApi
"

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

function update_pom_version() {
	file_path=$1
	artifact_id=$2
	new_version=$3
	element_artifact_id="artifactId"
	element_version="version"
	awk_partner_artifact_id="<${element_artifact_id}>${artifact_id}<\/${element_artifact_id}>"
	prompt_artifact_id="$(echo ${awk_partner_artifact_id} | sed 's/\\//g')"
	echo ">>> 在${file_path}中查找${prompt_artifact_id}，将版本号改为${new_version}"
	if [[ ! -f "${file_path}" ]]; then
		echo "${file_path}文件不存在"
		echo ""
		return
	fi
	row_number_artifact_id=$(awk "/${awk_partner_artifact_id}/{print NR}" "${file_path}")
	if [[ "${row_number_artifact_id}" == "" ]]; then
		echo "未找到符合条件的行"
		echo ""
		return
	fi
	count=0
	for line in ${row_number_artifact_id}; do
		let count++
	done
	if [[ ${count} -gt 1 ]]; then
		echo "${file_path}中有多行${prompt_artifact_id}，请检查文件"
		echo ${row_number_artifact_id}
		echo ""
		return
	fi
	row_number_version=$((row_number_artifact_id + 1))
	line_old_version=$(awk "NR==${row_number_version}" "${file_path}")
	if [[ "${line_old_version}" =~ "<${element_version}>" ]] && [[ "${line_old_version}" =~ "</${element_version}>" ]]; then
		if [[ "${line_old_version}" =~ "<!--" ]]; then
			echo "${line_old_version}版本号疑似被注释，请检查文件"
			echo ""
			return
		fi
	else
		echo "$(echo ${awk_partner_artifact_id} | sed 's/\\//g')的下一行${line_old_version}未包含版本号，请检查文件"
		echo ""
		return
	fi
	# 单井号 "#*'>'" 表示从左边删除到第一个大于号
	old_version="${line_old_version#*'>'}"
	# 单百分号 "%'<'*" 表示从右边删除到第一个小于号
	old_version="${old_version%'<'*}"
	echo "替换：${old_version}"
	sed -n "$((row_number_version - 2)), $((row_number_version + 1))"p "${file_path}"
	sed -i "" "${row_number_version}s/${old_version}/${new_version}/g" "${file_path}"
	echo "改为：${new_version}"
	sed -n "$((row_number_version - 2)), $((row_number_version + 1))"p "${file_path}"
}

function update_properties_value() {
	file_path=$1
	properties_key=$2
	new_value=$3
	echo ">>> 在${file_path}中查找<${properties_key}>，将值改为${new_value}"
	if [[ ! -f "${file_path}" ]]; then
		echo "${file_path}文件不存在"
		return
	fi
	row_number_artifact_id=$(awk "/<${properties_key}>/{print NR}" "${file_path}")
	if [[ "${row_number_artifact_id}" == "" ]]; then
		echo "未找到符合条件的行"
		return
	fi
	count=0
	for line in ${row_number_artifact_id}; do
		let count++
	done
	if [[ ${count} -gt 1 ]]; then
		echo "${file_path}中有多行<${properties_key}>，请检查文件"
		echo ${row_number_artifact_id}
		return
	fi
	row_number_version=$((row_number_artifact_id))
	line_old_version=$(awk "NR==${row_number_version}" "${file_path}")
	if [[ "${line_old_version}" =~ "<${properties_key}>" ]] && [[ "${line_old_version}" =~ "</${properties_key}>" ]]; then
		if [[ "${line_old_version}" =~ "<!--" ]]; then
			echo "${line_old_version}版本号疑似被注释，请检查文件"
			echo ""
			return
		fi
	fi
	# 单井号 "#*'>'" 表示从左边删除到第一个大于号
	old_version="${line_old_version#*'>'}"
	# 单百分号 "%'<'*" 表示从右边删除到第一个小于号
	old_version="${old_version%'<'*}"
	echo "替换：${old_version}"
	sed -n "$((row_number_version)), $((row_number_version))"p "${file_path}"
	sed -i "" "${row_number_version}s/${old_version}/${new_value}/g" "${file_path}"
	echo "改为：${new_value}"
	sed -n "$((row_number_version)), $((row_number_version))"p "${file_path}"
}

for framework in ${framework_list}; do
	echo ${framework}
	file_path="NDPFramework/${framework}/${file_name}"
	update_pom_version "${file_path}" "${framework}" "$(eval echo '$'"${framework}")"
	for framework in ${framework_list}; do
		update_properties_value "${file_path}" "${framework}.version" "$(eval echo '$'"${framework}")"
	done
	echo ""
done

for project in ${project_list}; do
	if [ ! -d "${project}" ]; then
		echo "======== IGNORE ${project}"
		echo ""
		continue
	fi
	echo "${project}"
	for framework in ${framework_list}; do
		file_path="${project}/${file_name}"
		update_properties_value "${file_path}" "${framework}.version" "$(eval echo '$'"${framework}")"
	done
	echo ""
done
