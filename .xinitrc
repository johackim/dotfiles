#!/bin/sh

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

if [ `xrandr | grep -c ' connected '` -ge 2 ]; then
    if [ `xrandr | grep VGA-1 | grep -c ' connected '` -eq 1 -a `xrandr | grep HDMI-1 | grep -c ' connected '` -eq 1 ]; then
        echo "HDMI & VGA"
        xrandr --output eDP-1 --off
        xrandr --output VGA-1 --auto --primary --output HDMI-1 --auto --right-of VGA-1
    elif [ `xrandr | grep VGA-1 | grep -c ' connected '` -eq 1 ]; then
        echo "VGA"
        xrandr --output HDMI-1 --off
        xrandr --output eDP-1 --auto --primary --output VGA-1 --auto --right-of eDP-1
    elif [ `xrandr | grep HDMI-1 | grep -c ' connected '` -eq 1 ]; then
        echo "HDMI"
        xrandr --output VGA-1 --off
        xrandr --output eDP-1 --auto --primary --output HDMI-1 --auto --right-of eDP-1 --output VGA-1 --off
    fi
else
    xrandr --output eDP-1 --auto --primary --output VGA-1 --off --output HDMI-1 --off
fi

feh --bg-center Images/wallpaper.png
