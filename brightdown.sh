interval=5
min=0
max=255

bright=$(cat /sys/class/backlight/rpi_backlight/brightness)
bright=$((bright-interval))
if [[ ${bright} -lt ${min} ]]; then
    bright=${min}
fi
sudo su << EOF
echo "${bright}" > /sys/class/backlight/rpi_backlight/brightness
EOF
