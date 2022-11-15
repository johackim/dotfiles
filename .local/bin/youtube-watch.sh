#!/bin/bash

notify-send -t 3000 "Playing Video" "$(xclip -o)";
mpv "$(xclip -o)"