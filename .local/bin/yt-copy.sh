#!/bin/bash

url=$(xclip -o)

url=$(printf '%s' "$url" | sed -E 's/([?&])feature=shared([&#]|$)/\1\2/g; s/([?&])si=[^&#]*([&#]|$)/\1\2/g; s/([?&])&/\1/g; s/[?&]([#]|$)/\1/g')

notify-send -t 3000 "Copy video" "$(xclip -o)";

if [[ ! "$url" =~ ^.*youtu[be.com|.be].*$ ]]; then
    exit 1;
fi

yt-dlp -f mp4 -o '%(id)s.%(ext)s' --skip-download --print-json --no-warnings "$url" > /tmp/.metadata
title=$(jq -r '.title' /tmp/.metadata 2>/dev/null)
uploader=$(jq -r '.uploader' /tmp/.metadata 2>/dev/null)
id=$(jq -r '.display_id' /tmp/.metadata 2> /dev/null)
short_url="https://youtu.be/$(echo "$url" | awk -F '=' '{print $NF}')"

if [[ "$url" =~ ^.*youtu.be.*$ ]]; then
    short_url="$url"
fi

printf "%s" "[$uploader - $title]($short_url)" | xclip -selection clipboard

notify-send -t 3000 "Video copied" "$(xclip -o)";
