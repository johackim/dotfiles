#!/bin/bash

s='  |  '

while :; do
    (( i++ % 3600 )) || weather=$(curl -sfm 10 "wttr.in/${WEATHER_CITY:-Paris}?format=%t" | tr -d +)
    battery=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    vpn=$([[ -e /sys/class/net/tun0 || -e /sys/class/net/proton0 ]] && echo VPN)
    echo "${battery:+$battery%$s}${vpn:+$vpn$s}${weather:+$weather$s}$(df --output=avail -BG / | tail -1 | tr -dc 0-9) GB$s$(date "+%d-%m-%Y$s%H:%M:%S")  "
    sleep 1
done
