#!/bin/bash

source "$HOME/.cache/wal/colors.sh"

# Update Dunst theme
DFILE="$HOME/.config/dunst/dunstrc"
sed -i "s/^background = .*/background = \"$background\"/" "$DFILE"
sed -i "s/^\(foreground\|frame_color\) = .*/\1 = \"$foreground\"/" "$DFILE"
pkill dunst

# Reload polybar colors from xrdb
polybar-msg cmd restart

# Create GTK theme
no_jokes=true /opt/oomox/plugins/theme_oomox/change_color.sh -o Pywal /opt/oomox/scripted_colors/xresources/xresources-reverse

# Create Archdroid icons
oomox-archdroid-icons-cli -o Pywal ~/.cache/wal/colors-oomox

# Reload thunar
thunar -q
