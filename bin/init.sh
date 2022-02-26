#!/bin/sh

[ -f ~/.Xresources ] && xrdb -merge -I "$HOME" ~/.Xresources

dbus-update-activation-environment --systemd DISPLAY
eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
export SSH_AUTH_SOCK

wpg -a ~/Images/wallpaper-cyan.jpg > /dev/null 2>&1
wpg -s wallpaper-cyan.jpg > /dev/null 2>&1
wal -R > /dev/null 2>&1

sleep 5
