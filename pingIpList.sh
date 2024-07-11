#!/bin/bash

ipList="
huecker.io
cr.yandex
dockerhub1.beget.com
mirror.gcr.io
dockerhub.timeweb.cloud
public.ecr.aws
ghcr.io
daocloud.io
sf.163.com
" && \
for ip in $(echo ${ipList}); do echo ${ip}; ping -c 10 -q ${ip}; echo ""; done
