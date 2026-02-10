#!/bin/bash

set -e

SRC=$1
DEST=$2
WEBHOOK_URL=$3

DATE=$(date +%Y-%m-%d)
BUCKETS=$(timeout 30s rclone lsf --dir-slash=false "$SRC":)

for b in $BUCKETS; do
    echo "Syncing bucket: $b";

    rclone sync --fast-list --size-only --transfers 32 --checkers 32 \
        --exclude ".archives/**" \
        --backup-dir "$DEST:$b/.archives/$DATE" \
        "$SRC:$b" "$DEST:$b";

    rclone delete "$DEST:$b/.archives/" --min-age 30d --rmdirs;
done

curl -s "$WEBHOOK_URL"
