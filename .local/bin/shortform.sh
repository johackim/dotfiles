#!/bin/bash

[ -f ~/.private_aliases ] && source ~/.private_aliases

CACHE_FILE="$HOME/.shortform"
OLD_SUMMARY=$(cat $CACHE_FILE 2>/dev/null)
NEW_SUMMARY=$(curl -s -H "Authorization: Basic $SHORTFORM_API_KEY" -H "X-Sf-Client: 11.7.0" "https://www.shortform.com/api/books/?sort=date" | jq -r '.data | sort_by(.created) | last | .title')

if [[ "$OLD_SUMMARY" != "$NEW_SUMMARY" && -n "$NEW_SUMMARY" ]]; then
    ~/.local/bin/alert.sh "Shortform" "Nouveau résumés"
    echo "$NEW_SUMMARY" > $CACHE_FILE
fi
