#!/bin/bash

yes | sudo pacman -Scc > /dev/null
docker system prune -af > /dev/null
trash ~/.cache
trash-empty -f
