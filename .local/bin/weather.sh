#!/bin/bash

API_KEY="58fb0dcd408b8dc0d6cb3653b49342f0"
CITY_ID="6454307"

WEATHER_URL="http://api.openweathermap.org/data/2.5/weather?id=${CITY_ID}&appid=${API_KEY}&units=metric"
WEATHER_INFO=$(wget -qO- "${WEATHER_URL}")
WEATHER_TEMP=$(echo "${WEATHER_INFO}" | jq '.main.temp' 2>/dev/null | awk '{print int($1+0.5)}')

[[ ! $WEATHER_TEMP ]] && exit 1

echo "${WEATHER_TEMP}°C"
