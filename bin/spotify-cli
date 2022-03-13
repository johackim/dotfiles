#!/bin/bash

[ -f ~/.private_aliases ] && source ~/.private_aliases

CLIENT_ID="${SPOTIFY_CLIENT_ID}"
CLIENT_SECRET="${SPOTIFY_CLIENT_SECRET}"
REFRESH_TOKEN="${SPOTIFY_REFRESH_TOKEN}"

CREDENTIALS=$(echo -n "$CLIENT_ID:$CLIENT_SECRET" | base64 -w 0)

ACCESS_TOKEN=$(curl -sX "POST" -H "Authorization: Basic $CREDENTIALS" -d "grant_type=refresh_token&refresh_token=$REFRESH_TOKEN" https://accounts.spotify.com/api/token | jq -r '.access_token')

CURRENT_SONG=$(curl -sX "GET" "https://api.spotify.com/v1/me/player/currently-playing" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $ACCESS_TOKEN" | jq -r '.item.artists[0].name + " - " + .item.name')

IS_PLAYING=$(curl -sX "GET" "https://api.spotify.com/v1/me/player/currently-playing" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $ACCESS_TOKEN" | jq -r '.is_playing')

[[ "$IS_PLAYING" != true ]] && exit 1

echo "$CURRENT_SONG"
