#!/bin/bash

source "$HOME/.cache/wal/colors.sh"

# Update Dunst theme
DFILE="$HOME/.config/dunst/dunstrc"
sed -i "s/^background = .*/background = \"$background\"/" "$DFILE"
sed -i "s/^\(foreground\|frame_color\) = .*/\1 = \"$foreground\"/" "$DFILE"
pkill dunst

# Reload i3bar colors from xrdb
i3-msg reload

# Create lock screen image (i3lock only reads PNG at screen size)
ffmpeg -v error -y -i "$wallpaper" -vf scale=1920:1080 ~/.cache/wal/lock.png

# Create GTK theme and icons
no_jokes=true /opt/oomox/plugins/theme_oomox/change_color.sh -o Pywal ~/.cache/wal/colors-oomox
ICONS_ARCHDROID=${color3:1} oomox-archdroid-icons-cli -o Pywal ~/.cache/wal/colors-oomox

# Reload thunar
thunar -q
