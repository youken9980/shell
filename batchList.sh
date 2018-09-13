#!/bin/bash

list="
"
# 对取到的集合进行循环
for item in $(eval echo ${list}); do
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
	# 对参数进行循环
	for ((i=1;i<=$#;i++)); do
		cmd="$(eval echo '$'"$i")"
		echo ">>> ${cmd}"
		eval ${cmd}
	done
	cd ..
	echo ""
done
