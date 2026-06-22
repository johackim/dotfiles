#!/bin/bash

sudo pacman -S --noconfirm --needed cpanminus
sudo /usr/bin/vendor_perl/cpanm PhonyClipboard
sudo /usr/bin/vendor_perl/cpanm Crypt::Rijndael
sudo /usr/bin/vendor_perl/cpanm Capture::Tiny
