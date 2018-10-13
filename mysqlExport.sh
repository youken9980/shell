#!/bin/bash

file_path="/etc/mysql/mysql.cnf"

# rm ${file_path}
echo "[client]" >> ${file_path}
echo "host=10.39.0.248" >> ${file_path}
echo "user=mysqltest1" >> ${file_path}
echo "password=IdesignDBT1" >> ${file_path}

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
	cmd="mysqldump --defaults-extra-file=${file_path} --databases --skip-lock-tables --set-gtid-purged=OFF ${item} > /10.39.0.248/${item}.sql"
	echo ">>> ${cmd}"
	eval ${cmd}
	echo ""
done
