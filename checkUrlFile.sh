#!/bin/bash

# 检查是否传入 URL 参数
if [ $# -ne 1 ]; then
    echo "使用方法：$0 <URL>"
    exit 1
fi

url=$1

# 使用 curl 发送 HEAD 请求，跟随重定向，获取 HTTP 状态码
http_code=$(curl -s -o /dev/null -w "%{http_code}" -I -L "$url")

# 检查 curl 是否执行成功
curl_exit_code=$?
if [ $curl_exit_code -ne 0 ]; then
    echo "curl 执行失败"
    exit 3
fi

# 判断 HTTP 状态码
if (( http_code >= 200 && http_code < 300 )); then
    echo "$url, $http_code, 文件存在"
    exit 0
elif (( http_code >= 400 )); then
    echo "$url, $http_code, 文件不存在"
    exit 1
else
    echo "$url, $http_code, 不确定"
    exit 2
fi
