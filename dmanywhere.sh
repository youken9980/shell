#!/bin/bash
# password: dmanywhere

default="9090"
if [ $# == 1 ]; then
    default="$1"
fi
log_file_path="/tmp/dmanywhere.log"

nohup dmanywhere -p ${default} > ${log_file_path} 2>&1 &
sleep 1s
open -a "Google Chrome" http://localhost:${default}
tail -f ${log_file_path}
