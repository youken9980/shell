#!/bin/bash
# sed -i "" 's|@CeresReference(domain = "cn.enncloud.ceres.base")|// @CeresReference(domain = "cn.enncloud.ceres.base")|g' src/main/java/com/xindny/ndp/user/service/impl/PlatformUserServiceImpl.java

local_path="/CDI/dev/"

function update_version() {
	pwd=$(pwd)
	dir_list=$(ls -l | grep ^d | awk '{print $9}')
	if [ -n "${dir_list}" ]; then
		file_list=$(ls -l | grep -v ^d | grep .html | awk '{print $9}')
		if [ -n "${file_list}" ]; then
			# 查询当前目录
#			echo "${file_list}" | while read file; do
			for file in $(eval echo ${file_list}); do
				echo ">>> ${pwd#*${local_path}}/${file}"
				cat "${file}" | grep -n "script src="
				echo ""
			done
		fi
		# 递归查询子目录
#		echo "${dir_list}" | while read dir; do
		for dir in $(eval echo ${dir_list}); do
			cd "${dir}"
			update_version
			cd ..
		done
	fi
}

update_version
