#!/bin/bash

filename="mvn.log"

~/batch.sh service "~/mvn.sh compile" | tee -a "${filename}"
~/batch.sh gateway "~/mvn.sh compile" | tee -a "${filename}"

grep "\\[INFO] B" -C0 "${filename}"
rm "${filename}"
