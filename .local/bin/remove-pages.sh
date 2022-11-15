#!/bin/bash

if [[ -z "$1" || -z "$2" || ! -f "$1" ]]; then
    echo "usage: remove-pages [file] [page number]"
    exit 1
fi

FILE=$1
PAGES=$2
OUTPUT_PATH="fixed.pdf"

\rm -f fixed.pdf
pdftk "$FILE" cat "$PAGES"-end output "$OUTPUT_PATH"
cp -f "$OUTPUT_PATH" "$FILE"
\rm -f fixed.pdf
