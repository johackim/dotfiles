#!/bin/bash

shopt -s nocasematch
cd ~/Downloads || exit

for f in *; do
    [ -f "$f" ] || continue
    case "$f" in
        *.png|*.svg|*.jpg|*.jpeg|*.gif|*.psd|*.webp) d=images ;;
        *.sql|*.rtf|*.odt|*.json|*.yml|*.yaml|*.xml|*.xls|*.txt|*.opml|*.po|*.pdf|*.epub|*.mobi|*.crt|*.doc|*.docx|*.xlsx|*.html|*.csv|*.md|*.torrent|*.aria2|*.key|*.sh|*.py|*.ovpn|*.log|*.conf|*.ods|*.xmind|*.gpx|*.db|*.drawio|*.azw|*.azw3|*.encrypted|*.appimage|*.bin|*.m3u) d=textes ;;
        *.avi|*.mkv|*.m4v|*.webm|*.mp4|*.srt|*.ogv) d=videos ;;
        *.zip|*.tgz|*.gz|*.bundle|*.apk|*.rar|*.7z|*.iso|*.exe|*.bz2|*.tar|*.img|*.xz|*.ab) d=archives ;;
        *.wav|*.mp3) d=audio ;;
        *) continue ;;
    esac
    mkdir -p "$d" && mv -n -- "$f" "$d"
done

mkdir -p dossiers

find . -maxdepth 1 -type d ! -name images ! -name archives ! -name textes ! -name audio ! -name videos ! -name torrents -exec mv {} dossiers \; &>/dev/null
find . -maxdepth 1 -type d -empty -delete
find . -name "*.part" -delete
