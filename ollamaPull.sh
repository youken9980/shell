#!/bin/bash

# 检查参数数量是否正确
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <interval_seconds> <name>"
    exit 1
fi

# 获取参数
interval=$1
name=$2

# 检查间隔时间是否为整数
if ! [[ "$interval" =~ ^[0-9]+$ ]]; then
    echo "Error: Interval must be an integer."
    exit 1
fi

# 无限循环执行命令，并在每次执行后等待指定的时间间隔
while true; do
    # 执行命令
    ollama pull $name &
    CMD_PID=$!
    echo "PID: $CMD_PID"

    # 等待指定的间隔时间
    sleep $interval

    # 检查进程是否存活
    if ps -p $CMD_PID > /dev/null; then
        echo "Kill PID: $CMD_PID"
        kill -9 $CMD_PID
        wait $CMD_PID 2>/dev/null
    else
        echo "Process with PID $CMD_PID is no longer running."
    fi
done

exit 0

