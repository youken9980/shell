#!/bin/bash

images="docker images -f dangling=false | grep -v 'REPOSITORY' | grep -v '<none>'"
images="${images} | grep -v 'local/'"
images="${images} | grep -v 'youken9980/'"
images="${images} | grep -v 'reg.enncloud.cn/'"
images="${images} | grep -v 'smartcloud/'"
images="${images} | grep -v 'chaoscloud/'"
images="${images} | grep -v 'springcloud/'"
images="${images} | grep -v 'code/'"
images="${images} | grep -v 'code_xj2/'"
eval "${images}" | while read img; do
	repo="$(echo ${img} | awk '{print $1":"$2}')"
	size="$(echo ${img} | awk '{print $7}')"
	echo "${repo} ${size}"
	cmd="docker pull ${repo}"
	eval "${cmd}"
	echo ""
done
echo ""
docker images
