#!/bin/bash

if [ -f "$1.srt" ]; then
    exit 1
fi

if [[ $1 =~ ^https?:// ]]; then
    yt-dlp $1 --extract-audio --audio-format mp3 -o file.mp3
    yt-dlp $1 -o 'file.%(ext)s'
else
    ffmpeg -i "$1" -fs 25M -vn -acodec libmp3lame -ac 2 -qscale:a 4 -ar 48000 "$1.mp3" > /dev/null 2>&1
fi

openai api audio.transcribe -f "file.mp3" --response-format srt > file.srt 2>&1
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' file.srt
sed -i '/Upload progress/d' file.srt
trash file.mp3
