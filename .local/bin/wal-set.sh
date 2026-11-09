#!/bin/bash

source "$HOME/.cache/wal/colors.sh"

# Update Dunst theme
DFILE="$HOME/.config/dunst/dunstrc"
sed -i -e "s/background = \"#.*\"/background = \"$background\"/g" "$DFILE"
sed -i -e "s/frame_color = \"#.*\"/frame_color = \"$foreground\"/" "$DFILE"
sed -i -e "s/foreground = \"#.*\"/foreground = \"$foreground\"/g" "$DFILE"
pkill dunst

# Reload polybar colors from xrdb
polybar-msg cmd restart

# Create GTK theme
no_jokes=true /opt/oomox/plugins/theme_oomox/change_color.sh -o Pywal /opt/oomox/scripted_colors/xresources/xresources-reverse

# Create Archdroid icons
oomox-archdroid-icons-cli -o Pywal ~/.cache/wal/colors-oomox

# Reload thunar
thunar -q
