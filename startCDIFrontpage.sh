#!/bin/bash

file_name_frontpage="cdiFrontpage.log"

# CDTPWebFrontPage
cd CDTPWebFrontPage
nohup live-server --port=7001 >> "../${file_name_frontpage}" 2>&1 &
cd ..

# CDWPWebFrontPage
cd CDWPWebFrontPage
nohup live-server --port=7002 >> "../${file_name_frontpage}" 2>&1 &
cd ..

# CDMPWebFrontPage
cd CDMPWebFrontPage
nohup live-server --port=7003 >> "../${file_name_frontpage}" 2>&1 &
cd ..

tail -f "${file_name_frontpage}"
rm "${file_name_frontpage}"
