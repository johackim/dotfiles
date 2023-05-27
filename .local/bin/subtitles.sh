#!/bin/bash

if [ -f "$1.srt" ]; then
    exit 1
fi

FILENAME=$(basename "$1")

if [[ $1 =~ ^https?:// ]]; then
    FILENAME=$(yt-dlp --get-title $1)
    yt-dlp $1 -f mp4 -o "${FILENAME}.%(ext)s" > /dev/null 2>&1
    yt-dlp $1 -f mp4 --extract-audio --audio-format mp3 -k -o "${FILENAME}.mp3" > /dev/null 2>&1
else
    ffmpeg -i "$1" -fs 25M -vn -acodec libmp3lame -ac 2 -qscale:a 4 -ar 48000 "${FILENAME}.mp3" > /dev/null 2>&1
fi

openai api audio.transcribe -f "${FILENAME}.mp3" --response-format srt > "${FILENAME}.srt" 2>&1
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "${FILENAME}.srt"
sed -i '/Upload progress/d' "${FILENAME}.srt"
trash "${FILENAME}.mp3"
