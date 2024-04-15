#!/bin/bash

sudo pacman --noconfirm -R $(pacman -Qtdq) > /dev/null 2>&1
yes | sudo pacman -Scc > /dev/null 2>&1
yay -Yc --noconfirm > /dev/null 2>&1
sudo docker system prune -af --volumes > /dev/null 2>&1
journalctl --vacuum-size=500M > /dev/null 2>&1
trash-empty -f > /dev/null 2>&1
