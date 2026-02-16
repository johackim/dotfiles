#!/bin/bash
#
# Support the following URL formats:
# https://www.youtube.com/watch?v=abc123xyz&feature=shared&si=abc123xyz&t=10s
# https://www.youtube.com/watch?v=abc123xyz&feature=shared
# https://www.youtube.com/watch?v=abc123xyz&t=423s
# https://youtu.be/abc123xyz?si=abc123xyz#fragment
# https://youtu.be/abc123xyz?si=abc123xyz&t=423
# https://youtu.be/abc123xyz?si=abc123xyz

PATH=$HOME/.local/bin:$PATH

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
short_url="https://youtu.be/$id$(echo "$url" | grep -o '[?&]t=[^&#]*' | head -n1 | sed 's/^&/?/')"

if [[ "$url" =~ ^.*youtu.be.*$ ]]; then
    short_url="$url"
fi

printf "%s" "[$uploader - $title]($short_url)" | xclip -selection clipboard

notify-send -t 3000 "Video copied" "$(xclip -o)";
