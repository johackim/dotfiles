#!/bin/bash

sudo pacman --noconfirm -R $(pacman -Qtdq) > /dev/null 2>&1
sudo pacman -Scc --noconfirm > /dev/null 2>&1
yay -Yc --noconfirm > /dev/null 2>&1
docker system prune -af > /dev/null 2>&1
sudo rm -rf ~/.cache
trash-empty -f
