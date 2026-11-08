#!/bin/sh

[ -f ~/.Xresources ] && xrdb -merge -I "$HOME" ~/.Xresources

eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

dbus-update-activation-environment --systemd --all

setxkbmap us_intl,us,fr grp:rctrl_rshift_toggle

xinput set-prop "MSFT0001:01 0488:1014 Touchpad" "libinput Tapping Enabled" 1

wal -R > /dev/null 2>&1

exec ${2:-i3}
