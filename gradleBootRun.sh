#!/bin/bash

# file_name="$(pwd)"
# file_name="${file_name##*/}.log"
# nohup gradle clean bootRun -x test > "${file_name}" 2>&1 &
# tail -f "${file_name}"

gradle clean bootRun -x test
