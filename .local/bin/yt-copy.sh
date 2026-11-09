#!/bin/bash
#
# Support the following URL formats:
# https://www.youtube.com/watch?v=abc123xyz&feature=shared&si=abc123xyz&t=10s
# https://www.youtube.com/watch?v=abc123xyz&feature=shared
# https://www.youtube.com/watch?v=abc123xyz&t=423s
# https://youtu.be/abc123xyz?si=abc123xyz#fragment
# https://youtu.be/abc123xyz?si=abc123xyz&t=423
# https://youtu.be/abc123xyz?si=abc123xyz

url=$(xclip -o | sed -E 's/([?&])feature=shared([&#]|$)/\1\2/g; s/([?&])si=[^&#]*([&#]|$)/\1\2/g; s/([?&])&/\1/g; s/[?&]([#]|$)/\1/g')

notify-send -t 3000 "Copy video" "$url"

[[ $url =~ youtu(be\.com|\.be) ]] || exit 1

read -r id title < <(yt-dlp --no-warnings --print "%(id)s %(uploader)s - %(title)s" "$url") || exit 1
t=$(grep -o '[?&]t=[^&#]*' <<< "$url" | head -1)
short_url=https://youtu.be/$id${t/#&/?}
[[ $url =~ youtu\.be ]] && short_url=$url
link="[$title]($short_url)"

printf '%s' "$link" | xclip -selection clipboard

notify-send -t 3000 "Video copied" "$link"
