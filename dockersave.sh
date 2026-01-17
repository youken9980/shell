#!/bin/bash

args=""
if [ $# -gt 0 ]
then
    args="| $1"
fi
images="docker images -f dangling=false | grep -v 'REPOSITORY' | grep -v '<none>' $args"
echo "docker save begin..."
eval "${images}" | while read line; do
    image_name="$(echo ${line} | awk '{print $1":"$2}')"
    size="$(echo ${line} | awk '{print $7}')"
    # 1. 将斜杠/替换为两个减号--
    filename="${image_name//\//--}"
    # 2. 将冒号:替换为下划线_
    filename="${filename//:/_}"
    # 3. 获取平台标识
    platform=$(docker inspect "$image_name" | jq -r '.[0].Architecture' 2>/dev/null)
    # 检查docker inspect是否成功执行
    if [ $? -ne 0 ] || [ -z "$platform" ] || [ "$platform" = "null" ]; then
        echo "错误: 无法获取镜像 $image_name 的平台信息"
        exit 1
    fi
    # 4. 追加平台标识并使用img作为后缀
    final_filename="${filename}.${platform}.img"
    # 执行docker save命令
    echo "$image_name ${size} >>> $final_filename ..."
    docker save -o "$final_filename" "$image_name"
    # 检查保存是否成功
    if [ $? -eq 0 ]; then
        echo "Save done: $final_filename"
    else
        echo "Save error: ${image_name}"
    exit 1
    fi
done
echo "docker save end."
ls -ltr "${dir}"
