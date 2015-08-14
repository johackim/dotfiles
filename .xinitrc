#!/bin/sh

if [ `xrandr | grep -c ' connected '` -ge 2 ]; then
    if [ `xrandr | grep VGA-0 | grep -c ' connected '` -eq 1 -a `xrandr | grep HDMI-0 | grep -c ' connected '` -eq 1 ]; then
        echo "HDMI & VGA"
        xrandr --output DP-0 --off
        xrandr --output VGA-0 --auto --primary --output HDMI-0 --auto --right-of VGA-0
    elif [ `xrandr | grep VGA-0 | grep -c ' connected '` -eq 1 ]; then
        echo "VGA"
        xrandr --output HDMI-0 --off
        xrandr --output DP-0 --auto --primary --output VGA-0 --auto --right-of DP-0
    elif [ `xrandr | grep HDMI-0 | grep -c ' connected '` -eq 1 ]; then
        echo "HDMI"
        xrandr --output VGA-0 --off
        xrandr --output DP-0 --auto --primary --output HDMI-0 --auto --right-of DP-0 --output VGA-0 --off
    fi
else
    echo "VAIO"
    xrandr --output DP-0 --auto --primary --output VGA-0 --off --output HDMI-0 --off
fi

feh --bg-center Images/europe-gray.png
