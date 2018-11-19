#!/bin/bash

file_path="/etc/mysql/mysql.cnf"
echo "[client]" >> ${file_path}
echo "host=${MySQL_DB}" >> ${file_path}
echo "user=${MySQL_US}" >> ${file_path}
echo "password=${MySQL_PW}" >> ${file_path}

list="
ndp_cooperative
ndp_demand
ndp_evaluate
ndp_forum
ndp_knowledge
ndp_message
ndp_order
ndp_signatures
ndp_system
ndp_system_log
ndp_unpack
ndp_user
"

for item in $(eval echo ${list}); do
	echo "${item}"
	cmd="mysqldump --defaults-extra-file=${file_path} --databases --add-drop-database --add-drop-table --skip-lock-tables --set-gtid-purged=OFF ${item} > ${MySQL_EXP}/${item}.sql"
	echo ">>> ${cmd}"
	eval ${cmd}
	echo ""
done
