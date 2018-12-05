#!/bin/bash

old_version="\.js?js_version=20181122\""
origin="\.js\""
new_version="\.js?js_version=20181128\""

file_list="find . -name \"*.html\" -type f -print"
eval "${file_list}" | while read file; do
	echo "${file}"
	# <script src=后面的单引号替换为双引号
	# sed -i "" "s/<script  src=/<script src=/g" "${file}"
	# sed -i "" "s/<script src='/<script src=\"/g" "${file}"
	# sed -i "" "s/.js?d=20180817'/.js?d=20180817\"/g" "${file}"
	# sed -i "" "s/.js?d=20180817 \"/.js?d=20180817\"/g" "${file}"
	# sed -i "" "s/.js'/.js\"/g" "${file}"
	# 旧版本替换为新版本
	# sed -i "" "s/.js?d=20180314/${origin}/g" "${file}"
	# sed -i "" "s/.js?d=20180601/${origin}/g" "${file}"
	sed -i "" "s/${old_version}/${origin}/g" "${file}"
	sed -i "" "s/${origin}/${new_version}/g" "${file}"
	cat "${file}" | grep -n "<script" | grep "src=" | grep -v "${new_version}"
	echo ""
done
