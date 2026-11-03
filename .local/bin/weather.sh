#!/bin/bash

[ -f ~/.private_aliases ] && source ~/.private_aliases

CITY_ID="6454307"

WEATHER_URL="https://api.openweathermap.org/data/2.5/weather?id=${CITY_ID}&appid=${OPENWEATHER_API_KEY}&units=metric"
WEATHER_INFO=$(curl -sL "${WEATHER_URL}")
WEATHER_TEMP=$(echo "${WEATHER_INFO}" | jq '.main.temp' 2>/dev/null | awk '{print int($1+0.5)}')

[[ ! $WEATHER_TEMP ]] && exit 1

echo "${WEATHER_TEMP}°C"
