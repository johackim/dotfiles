#!/bin/sh

[ -f ~/.Xresources ] && xrdb -merge -I "$HOME" ~/.Xresources

eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
setxkbmap us_intl,us,fr grp:rctrl_rshift_toggle
synclient TapButton1=1 TapButton2=3

wal -R > /dev/null 2>&1

exec ${2:-i3}
