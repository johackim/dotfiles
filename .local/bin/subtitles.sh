#!/bin/bash

set -e

[ -n "$1" ] || { echo "Usage: subtitles.sh <file or url>"; exit 1; }
[ -n "$OPENAI_API_KEY" ] || { echo "OPENAI_API_KEY is not set"; exit 1; }

if [[ $1 =~ ^https?:// ]]; then
    echo "Getting video title..."
    name=$(yt-dlp --no-warnings --print filename -o "%(title)s" "$1")
else
    [ -f "$1" ] || { echo "File not found: $1"; exit 1; }
    name=$(basename "$1")
    name=${name%.*}
fi

[ ! -f "$name.srt" ] || { echo "Subtitle file $name.srt already exists"; exit 1; }

src=$1
if [[ $1 =~ ^https?:// ]]; then
    echo "Downloading video as mp4..."
    yt-dlp -q --no-warnings -S "ext:mp4:m4a" --remux-video mp4 -o "%(title)s.%(ext)s" "$1"
    src=$name.mp4
fi

# A temp file never overwrites an input .mp3. Whisper resamples to 16kHz mono anyway,
# and 32kbps stays under the API's 25MB limit up to ~1h45.
audio=$(mktemp --suffix .mp3)
trap 'rm -f "$audio"' EXIT
echo "Extracting audio..."
ffmpeg -v error -y -i "$src" -vn -ac 1 -ar 16000 -b:a 32k "$audio"

echo "Transcribing with OpenAI Whisper..."
if ! curl -sS --fail-with-body https://api.openai.com/v1/audio/transcriptions \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -F file=@"$audio" -F model=whisper-1 -F response_format=srt > "$name.srt"; then
    echo "Error during transcription:"
    cat "$name.srt"
    rm "$name.srt"
    exit 1
fi

sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$name.srt"
echo "Done! Subtitles saved to $name.srt"
