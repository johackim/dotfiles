#!/bin/sh

[ -f ~/.Xresources ] && xrdb -merge -I "$HOME" ~/.Xresources

dbus-update-activation-environment --systemd DISPLAY
eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
export SSH_AUTH_SOCK
setxkbmap us_intl,us,fr grp:rctrl_rshift_toggle
synclient TapButton1=1 TapButton2=3

wpg -a ~/.dotfiles/wallpaper.jpg > /dev/null 2>&1
wpg -s wallpaper.jpg > /dev/null 2>&1
wal -R > /dev/null 2>&1

sleep 5
