#!/bin/bash

set -e

SRC=$1
DEST=$2
WEBHOOK_URL=$3

BUCKETS=$(timeout 30s rclone lsf --dir-slash=false "$SRC":)

for b in $BUCKETS; do
    echo "Syncing bucket: $b";
    rclone sync --fast-list --transfers 32 --checkers 32 "$SRC:$b" "$DEST:$b";
done

curl -s "$WEBHOOK_URL"
