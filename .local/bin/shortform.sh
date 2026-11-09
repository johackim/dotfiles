#!/bin/bash

[ -f ~/.private_aliases ] && source ~/.private_aliases

CACHE_FILE="$HOME/.shortform"
API_URL="https://www.shortform.com/api/books/?sort=date"
API_HEADERS=("Authorization: Basic $SHORTFORM_API_KEY" "X-Sf-Client: 11.7.0")

get_latest_summary() {
    curl -s -H "${API_HEADERS[0]}" -H "${API_HEADERS[1]}" "$API_URL" | \
    jq -r '.data | sort_by(.created) | last | .title'
}

OLD_SUMMARY=$(cat $CACHE_FILE 2>/dev/null)
NEW_SUMMARY=$(get_latest_summary)

if [[ "$OLD_SUMMARY" != "$NEW_SUMMARY" && -n "$NEW_SUMMARY" ]]; then
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus notify-send -t 0 "Shortform" "Nouveau résumés"
    echo "$NEW_SUMMARY" > "$CACHE_FILE"
fi
