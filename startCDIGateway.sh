#!/bin/bash

file_name_gateway="cdiGateway.log"

list="
CDMPWebGateway
CDTPWebGateway
CDWPWebGateway
"

# 对取到的集合进行循环
for item in ${list}; do
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
	nohup mvn clean jetty:run -Dmaven.test.skip=true -U >> "../${file_name_gateway}" 2>&1 &
	cd ..
done

tail -f "${file_name_gateway}"
