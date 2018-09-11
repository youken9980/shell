#!/bin/bash

file_name_frontpage="cdiFrontpage.log"
file_name_gateway="cdiGateway.log"
file_name_service="cdiService.log"

local_path="/CDI/dev/"
cmd_list="ps -ef | grep ${local_path} | grep -v 'grep'"
eval "${cmd_list}" | while read cmd; do
	echo "${cmd}"
	pid="$(echo ${cmd} | awk '{print $2}')"
	cmd="kill -9 ${pid}"
 	echo ">>> ${cmd}"
	$(eval echo "${cmd}")
done

rm "${file_name_frontpage}"
rm "${file_name_gateway}"
rm "${file_name_service}"
