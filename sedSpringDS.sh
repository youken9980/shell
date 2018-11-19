#!/bin/bash

file_list="find . -name \"spring-ds.xml\" -type f -print"
eval "${file_list}" | while read file; do
	echo "${file}"
	sed -i "" "s/\${MySQL_DB}/127.0.0.1/g" "${file}"
	sed -i "" "s/\${MySQL_US}/root/g" "${file}"
	sed -i "" "s/\${MySQL_PW}/admin123/g" "${file}"
	# cat "${file}" | grep "jdbc:mysql://"
	# echo ""
done
