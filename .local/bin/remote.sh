#!/bin/sh

REMOTE_LINK=$1
NAME=$2

SERVER=$(curl -s https://vikingfile.com/api/get-server | jq -r '.server')

if [ -n "$NAME" ]; then
    curl -s -N -X POST "$SERVER" -d "link=$REMOTE_LINK" -d "user=" -d "name=$NAME"
else
    curl -s -N -X POST "$SERVER" -d "link=$REMOTE_LINK" -d "user="
fi | jq -j --unbuffered 'if .progress then "\rUploading... \(.progress)" elif .url then "\rDownload URL: \(.url)\n" else empty end'
