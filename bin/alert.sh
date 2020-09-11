#!/bin/bash

# * 13,20 * * * sudo -u johackim /home/johackim/bin/alert.sh "Title" "Description"

export DISPLAY=:0
export XAUTHORITY=/home/johackim/.Xauthority
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

/usr/bin/notify-send -t 0 "$1" "$2"
