#!/bin/bash
# password: dmanywhere

default="9090"
if [ $# == 1 ]; then
    default="$1"
fi

nohup dmanywhere -p ${default} > /dev/null 2>&1 &
sleep 1s
open -a Google\ Chrome http://localhost:${default}
