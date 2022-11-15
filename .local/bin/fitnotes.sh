#!/bin/bash

INPUT="FitNotes_Export.csv"
OUTPUT="FitNotes.sql"
AFTER_DATE=$(date --date 2020-01-01 -u +%s)

rm "$OUTPUT"

sed -i '1d' $INPUT | while IFS= read -r LINE
do
    DATE=$(echo "$LINE" | awk -F ',' '{print $1}')
    TIMESTAMP=$(date --date "$DATE" -u +%s)

    if [[ $TIMESTAMP > $AFTER_DATE ]]; then
        echo 'INSERT INTO "main"."Repetitions" ("habit", "timestamp", "value") VALUES (4, '"$TIMESTAMP"000', 2);' >> FitNotes.sql
    fi

done < "$INPUT"

sort -u -o "$OUTPUT" $OUTPUT
