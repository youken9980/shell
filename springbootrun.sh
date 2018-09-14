#!/bin/bash

file_name="$(pwd)"
file_name="${file_name##*/}.log"

nohup mvn clean spring-boot:run -Dmaven.test.skip=true -U >> "${file_name}" 2>&1 &
tail -f "${file_name}"
