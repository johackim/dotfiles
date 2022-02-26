#!/bin/sh

[ -f ~/.Xresources ] && xrdb -merge -I "$HOME" ~/.Xresources

dbus-update-activation-environment --systemd DISPLAY
eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
export SSH_AUTH_SOCK

wpg -a ~/Images/wallpaper-cyan.jpg
wpg -s wallpaper-cyan.jpg
wal -R
sleep 5

exec i3
