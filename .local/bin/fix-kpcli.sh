#!/bin/bash

sudo pacman -S --noconfirm --needed cpanminus
sudo cpanm PhonyClipboard
sudo cpanm Crypt::Rijndael
sudo cpanm Capture::Tiny
