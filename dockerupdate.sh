#!/bin/bash

images="docker images -f dangling=false | grep -v 'REPOSITORY' | grep -v '<none>'"
images="${images} | grep -v 'localhost:'"
images="${images} | grep -v 'local/'"
images="${images} | grep -v 'youken9980/'"
images="${images} | grep -v 'reg.enncloud.cn/'"
images="${images} | grep -v 'smartcloud/'"
images="${images} | grep -v 'chaoscloud/'"
images="${images} | grep -v 'springcloud/'"
images="${images} | grep -v 'eo/code'"
images="${images} | grep -v 'sc/code'"
images="${images} | grep -v 'firecrawl-'"
eval "${images}" | while read img; do
	repo="$(echo ${img} | awk '{print $1":"$2}')"
	size="$(echo ${img} | awk '{print $7}')"
	cmd="docker pull --platform $(eval echo $(docker inspect ${repo} | jq .[0].'Architecture')) ${repo}"
	echo -e "${size}\t${cmd}"
	eval "${cmd}"
	echo ""
done
echo ""
docker images
