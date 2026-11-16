#!/bin/bash

CACHE_FILE="$HOME/.shortform"

LATEST_SUMMARY=$(curl -s "https://www.shortform.com/api/books/?sort=date" \
    -H "Authorization: Basic ${SHORTFORM_API_KEY:?}" \
    -H "X-Sf-Client: 11.7.0" \
    | jq -r '.data | sort_by(.created) | last | .title')

if [[ -n "$LATEST_SUMMARY" && "$LATEST_SUMMARY" != "$(cat "$CACHE_FILE" 2>/dev/null)" ]]; then
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus notify-send -t 0 "Shortform" "Nouveau résumés"
    echo "$LATEST_SUMMARY" > "$CACHE_FILE"
fi
