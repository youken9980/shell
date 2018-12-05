#!/bin/bash

ip_range="10.1.103"
pi_name="raspberrypi"
# ip_range="10.2.114"
# pi_name="ykmbp"

for address in {1..255}; do {
	ip="${ip_range}.${address}"
	if ping -c 1 -W 1 "${ip}" &>/dev/null; then
		hostname=$(nslookup ${ip} | grep name | awk '{ print $4 }')
        # echo "${ip}, ${hostname}"
        if [[ "${hostname}" =~ "${pi_name}" ]]; then
            echo -e "${ip}\t${hostname}"
        fi
	fi
}& # 放入系统后台运行
done
# wait # 无需wait系统返回
