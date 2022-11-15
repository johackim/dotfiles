#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=/home/johackim/.Xauthority
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

/usr/bin/notify-send -t 0 "$1" "$2"
