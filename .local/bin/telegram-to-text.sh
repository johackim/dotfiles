#!/bin/bash

if [[ ! -f "$1" || ! -d "$2" ]]; then
    echo "usage: telegram-to-text.sh [result.json] [destination folder]"
    exit 1
fi

MESSAGES=$(jq -r '.messages[] |
    select(.text != "") |
    {
        date: .date[0:10],
        text: (if .text|type == "array" then (.text[] | select(. != "") | if .|type == "object" then .text else . end) else .text end),
    } | @base64' < "$1")

for MESSAGE in $MESSAGES; do
     DATE=$(echo "$MESSAGE" | base64 --decode | jq -r '.date' )
     TEXT=$(echo "$MESSAGE" | base64 --decode | jq -r '.text' )

     echo "$TEXT" >> "${2}/${DATE}.md"
done
