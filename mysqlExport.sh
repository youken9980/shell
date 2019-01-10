#!/bin/bash

file_path="/etc/mysql/mysql.cnf"
echo "[client]" >> ${file_path}
echo "host=${MySQL_DB}" >> ${file_path}
echo "user=${MySQL_US}" >> ${file_path}
echo "password=${MySQL_PW}" >> ${file_path}

list="
uat34cs_data
uat34cs_gateway
uat34cs_master
"

for item in $(eval echo ${list}); do
	echo "${item}"
	cmd="mysqldump --defaults-extra-file=${file_path} --databases --add-drop-database --add-drop-table --skip-lock-tables ${item} > ${MySQL_EXP}/${item}.sql"
	echo ">>> ${cmd}"
	eval ${cmd}
	echo ""
done
