#!/bin/bash

PARAM=$1

[ -z "$PARAM" ] && echo "Usage: subtitles.sh <file or url>" && exit 1
[ -z "$OPENAI_API_KEY" ] && echo "OPENAI_API_KEY is not set" && exit 1

for cmd in yt-dlp ffmpeg curl; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: $cmd is required but not installed."
        exit 1
    fi
done

if [[ $PARAM =~ ^https?:// ]]; then
    echo "Getting video title..."
    FILENAME=$(yt-dlp -O title "$PARAM" 2>/dev/null | sed 's/[^a-zA-Z0-9 _-]//g')
    [ -z "$FILENAME" ] && FILENAME="audio"

    [ -f "${FILENAME}.srt" ] && echo "Subtitle file ${FILENAME}.srt already exists" && exit 1

    echo "Downloading video as mp4..."
    yt-dlp -S "ext:mp4:m4a" --remux-video mp4 -o "${FILENAME}.%(ext)s" "$PARAM" > /dev/null 2>&1

    echo "Extracting audio to mp3..."
    ffmpeg -y -i "${FILENAME}.mp4" -vn -c:a libmp3lame -q:a 4 "${FILENAME}.mp3" > /dev/null 2>&1
else
    [ ! -f "$PARAM" ] && echo "File not found: $PARAM" && exit 1
    FILENAME=$(basename "${PARAM%.*}" | sed 's/[^a-zA-Z0-9 _-]//g')

    [ -f "${FILENAME}.srt" ] && echo "Subtitle file ${FILENAME}.srt already exists" && exit 1

    echo "Converting to mp3..."
    ffmpeg -y -i "$PARAM" -vn -c:a libmp3lame -q:a 4 "${FILENAME}.mp3" > /dev/null 2>&1
fi

SIZE=$(stat -c%s "${FILENAME}.mp3")

if [ "$SIZE" -gt 26214400 ]; then
    echo "File too large ($(du -h "${FILENAME}.mp3" | cut -f1)). Compressing..."
    ffmpeg -y -i "${FILENAME}.mp3" -map 0:a -ar 16000 -ac 1 -b:a 32k "${FILENAME}_compressed.mp3" > /dev/null 2>&1
    mv "${FILENAME}_compressed.mp3" "${FILENAME}.mp3"
fi

echo "Transcribing with OpenAI Whisper..."
curl -s --request POST \
  --url https://api.openai.com/v1/audio/transcriptions \
  --header "Authorization: Bearer $OPENAI_API_KEY" \
  --header "Content-Type: multipart/form-data" \
  --form file=@"${FILENAME}.mp3" \
  --form model="whisper-1" \
  --form response_format="srt" > "${FILENAME}.srt"

if grep -q '"error":' "${FILENAME}.srt"; then
    echo "Error during transcription:"
    cat "${FILENAME}.srt"
    rm -f "${FILENAME}.srt"
    exit 1
fi

rm -f "${FILENAME}.mp3"
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "${FILENAME}.srt"
echo "Done! Subtitles saved to ${FILENAME}.srt"
