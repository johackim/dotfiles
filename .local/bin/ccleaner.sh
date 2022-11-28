#!/bin/bash

yes | sudo pacman -Scc > /dev/null
docker system prune -af > /dev/null
sudo rm -rf ~/.cache
trash-empty -f
