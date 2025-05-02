#!/bin/bash

MODEL_NAME=$1

while true; do
    MODEL_EXISTS=$(ollama list | awk '{ print $1 }' | grep "^${MODEL_NAME}$")
    if [ -n "$MODEL_EXISTS" ]; then
        echo "The model $MODEL_NAME is downloaded."
        exit 0
    fi

    ollama pull "$MODEL_NAME" &
    PID=$!
    sleep $2

    kill $PID

    sleep 3
done
