#!/bin/bash

source "$HOME/.cache/wal/colors.sh"

# Update Polybar theme
PFILE="$HOME/.config/polybar/config.ini"
sed -i -e "s/background = #.*/background = #000000/" "$PFILE"
sed -i -e "s/background-alt = #.*/background-alt = $color1/" "$PFILE"
sed -i -e "s/foreground = #.*/foreground = $foreground/" "$PFILE"
sed -i -e "s/foreground-alt = #.*/foreground-alt = $color8/" "$PFILE"
sed -i -e "s/primary = #.*/primary = $color1/" "$PFILE"
sed -i -e "s/secondary = #.*/secondary = $color2/" "$PFILE"
sed -i -e "s/alternate = #.*/alternate = $color3/" "$PFILE"

# Update Dunst theme
DFILE="$HOME/.config/dunst/dunstrc"
sed -i -e "s/background = \"#.*\"/background = \"$background\"/g" "$DFILE"
sed -i -e "s/frame_color = \"#.*\"/frame_color = \"$foreground\"/" "$DFILE"
sed -i -e "s/foreground = \"#.*\"/foreground = \"$foreground\"/g" "$DFILE"
pkill dunst

# Create GTK theme
no_jokes=true /opt/oomox/plugins/theme_oomox/change_color.sh -o Pywal /opt/oomox/scripted_colors/xresources/xresources-reverse

# Create Archdroid icons
oomox-archdroid-icons-cli -o Pywal ~/.cache/wal/colors-oomox

# Reload thunar
thunar -q
