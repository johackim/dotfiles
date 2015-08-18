#!/bin/sh

i3status --config ~/.i3/i3status.conf | while :
do
    read line
    mpd=$(ncmpcpp --now-playing "{{%a - }%t}|{%f}")
    echo "$mpd | $line" || exit 1
done
