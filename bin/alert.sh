#!/bin/bash

# * 13,20 * * * sudo -u ston3o /home/ston3o/bin/alert.sh "Title" "Description"

export DISPLAY=:0
export XAUTHORITY=/home/ston3o/.Xauthority
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

/usr/bin/notify-send -t 0 "$1" "$2"
