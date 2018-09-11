#!/bin/bash

filename="mvn.log"

if [ ! -d "NDPBaseApi" ]; then
	echo "NDPBaseApi"
	exit 1
fi
cd NDPBaseApi
~/mvn.sh "deploy" | tee -a "../${filename}"
cd ..
echo ""

~/batch.sh "~/mvn.sh deploy" | tee -a "${filename}"

grep "\\[INFO] B" -C0 "${filename}"
rm "${filename}"
