#!/bin/bash

args=""
if [ $# -gt 0 ]
then
	args="| $1"
fi
images="docker images -f dangling=false | grep -v 'REPOSITORY' | grep -v '<none>' $args"
prefix="docker save -o"
dir="$SHARE_HOME/docker/tar"
suffix="-save.tar"
echo "docker save begin..."
eval "${images}" | while read img; do
	repo="$(echo ${img} | awk '{print $1":"$2}')"
	size="$(echo ${img} | awk '{print $7}')"
	echo "${repo} ${size}"
	fileformat="$(echo ${repo} | sed 's#/#_#g' | sed 's#-#_#g' | sed 's#:#_#g')"
	cmd="${prefix} ${dir}/${fileformat}${suffix} ${repo}"
	eval "${cmd}"
done
echo "docker save end."
ls -ltr "${dir}"
