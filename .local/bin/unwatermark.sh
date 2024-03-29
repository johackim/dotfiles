#!/bin/bash

if [[ -z "$1" || -z "$2" || ! -f "$1" ]]; then
    echo "usage: unwatermark [file] [text to remove]"
    exit 1
fi

FILE=$1
TEXT_TO_REMOVE=$2
OUTPUT_PATH="fixed.pdf"

\rm -f unwatermarked.pdf uncompressed.pdf fixed.pdf
# pdftk "$FILE" output uncompressed.pdf uncompress
qpdf --stream-data=uncompress "$FILE" uncompressed.pdf
sed -e "s/$TEXT_TO_REMOVE/ /" uncompressed.pdf > unwatermarked.pdf
pdftk unwatermarked.pdf output "$OUTPUT_PATH" compress
cp -f "$OUTPUT_PATH" "$FILE"
\rm -f unwatermarked.pdf uncompressed.pdf fixed.pdf
