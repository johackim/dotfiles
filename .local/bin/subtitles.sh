#!/bin/bash

PARAM=$1
FILENAME=$(basename "${1%.*}")

command_exists() {
    command -v "$1" &> /dev/null
}

error_exit() {
    echo "$1"
    exit 1
}

[ -z "$PARAM" ] && error_exit "Usage: subtitles.sh <file or url>"

for cmd in yt-dlp ffmpeg jq mc convert_output.py; do
    command_exists "$cmd" || error_exit "$cmd could not be found"
done

mc ls minio/replicate > /dev/null 2>&1 || error_exit "Minio bucket does not exist"

[ -z "$REPLICATE_API_TOKEN" ] && error_exit "REPLICATE_API_TOKEN is not set"

[ -f "${FILENAME}.srt" ] && error_exit "Subtitle file already exists"

if [[ $PARAM =~ ^https?:// ]]; then
    echo "Getting video title..."
    FILENAME=$(yt-dlp --get-title $PARAM 2>/dev/null | sed 's/\//-/g')
    [ -f "${FILENAME}.srt" ] && error_exit "Subtitle file already exists"
    echo "Downloading video..."
    yt-dlp $PARAM -f mp4 -o "${FILENAME}.%(ext)s" > /dev/null 2>&1
    echo "Extracting audio..."
    yt-dlp $PARAM -f mp4 --extract-audio --audio-format mp3 -k -o "${FILENAME}.mp3" > /dev/null 2>&1
else
    [ ! -f "$PARAM" ] && error_exit "File not found: $PARAM"
    echo "Converting to mp3..."
    [ -f "${FILENAME}.mp3" ] || ffmpeg -i "$PARAM" -fs 25M -vn -acodec libmp3lame -ac 2 -qscale:a 4 -ar 48000 "${FILENAME}.mp3" > /dev/null 2>&1
fi

echo "Uploading mp3..."
mc cp "${FILENAME}.mp3" minio/replicate > /dev/null 2>&1

URL=$(mc share download -q --json minio/replicate/"${FILENAME}.mp3" | jq -r '.share')

echo "Transcribing audio..."
PREDICTION_ID=$(curl -s -X POST \
  -H "Authorization: Bearer $REPLICATE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d $'{
    "version": "3ab86df6c8f54c11309d4d1f930ac292bad43ace52d10c80d87eb258b3c9f79c",
    "input": {
      "task": "transcribe",
      "audio": "'"$URL"'",
      "language": "None",
      "timestamp": "chunk",
      "batch_size": 64,
      "diarise_audio": false
    }
  }' https://api.replicate.com/v1/predictions | jq -r '.id')

sleep 2

get_prediction_status() {
  curl -s -H "Authorization: Bearer $REPLICATE_API_TOKEN" "https://api.replicate.com/v1/predictions/$PREDICTION_ID" | jq -r '.status'
}

STATUS=$(get_prediction_status)

while [[ "$STATUS" == "starting" || "$STATUS" == "processing" ]]; do
  echo "Current status: $STATUS"
  sleep 5
  STATUS=$(get_prediction_status)
done

[ "$STATUS" == "failed" ] && error_exit "Prediction failed"

echo "Downloading subtitle..."
OUTPUT=$(curl -s -H "Authorization: Bearer $REPLICATE_API_TOKEN" "https://api.replicate.com/v1/predictions/$PREDICTION_ID")
echo "$OUTPUT" > output.json
convert_output.py -f srt output.json

mv output.srt "${FILENAME}.srt"

\rm -f output.json
\rm -f "${FILENAME}.json"
\rm -f "${FILENAME}.mp3"
