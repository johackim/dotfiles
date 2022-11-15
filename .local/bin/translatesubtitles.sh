#!/bin/bash

OUTPUT_FILE="${1%%.*}.fr.srt"

while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ $line =~ [a-z] ]] ; then
        echo "$line" | trans :fr -brief >> "$OUTPUT_FILE"
    else
        echo "$line" >> "$OUTPUT_FILE"
    fi
done < "$1"

sed -i 's/[[:space:]]*$//' "$OUTPUT_FILE";
