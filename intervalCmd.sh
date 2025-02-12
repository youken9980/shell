#!/bin/bash

# 检查参数数量是否正确
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <interval> <command>"
    exit 1
fi

# 获取参数
INTERVAL=$1
COMMAND=$2

# 检查第一个参数是否为正整数
if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]] || [ "$INTERVAL" -le 0 ]; then
    echo "The first argument must be a positive integer."
    exit 1
fi

# 定义一个函数来处理 SIGINT 信号（Ctrl+C）
trap 'handle_sigint' SIGINT

function handle_sigint() {
    echo "Caught Ctrl+C. Terminating the running command and exiting..."
    if [ -n "$COMMAND_PID" ] && kill -0 "$COMMAND_PID" 2>/dev/null; then
        kill -9 "$COMMAND_PID"
    fi
    exit 1
}

# 无限循环执行命令和等待间隔时间
while true; do
    # 执行命令并在后台运行
    $COMMAND &
    COMMAND_PID=$!
    echo "Command PID: $COMMAND_PID"

    # 等待子进程完成
    wait "$COMMAND_PID"

    # 检查子进程的退出状态
    EXIT_STATUS=$?
    echo "Exit status: $EXIT_STATUS"

    if [ "$EXIT_STATUS" -eq 0 ]; then
        echo "Command completed successfully. Exiting script."
        exit 0
    else
        echo "Command failed with exit status $EXIT_STATUS. Retrying in $INTERVAL seconds..."
        sleep "$INTERVAL"
    fi
done

