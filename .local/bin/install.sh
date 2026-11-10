#!/bin/bash

set -e

sudo pacman -Syu --noconfirm --needed --overwrite="*" \
    base-devel git zsh zsh-syntax-highlighting \
    xorg xorg-xinit xf86-input-libinput i3-wm i3lock dmenu rxvt-unicode dunst jq network-manager-applet feh \
    pipewire pipewire-alsa pipewire-pulse pipewire-jack pipewire-audio pavucontrol wireplumber sof-firmware \
    bluez blueman bluez-hid2hci bluez-utils \
    ttf-inconsolata-nerd noto-fonts-emoji gnu-free-fonts gtk3 libappindicator \
    tmux xclip lsof htop progress fastfetch chromium neovim tree-sitter-cli yt-dlp \
    restic thunar thunar-volman gvfs-mtp scrot eog trash-cli inetutils gnome-keyring pkgfile fd mousepad cronie signal-desktop qbittorrent firefox docker evince ripgrep telegram-desktop mpv aria2 ncdu brightnessctl polkit-gnome arandr gnome-calculator gcolor3 file-roller 7zip playerctl rclone calibre ncspot

sudo chsh -s "$(which zsh)" "$(whoami)"
sudo systemctl enable bluetooth cronie docker

[ -d "$HOME/.dotfiles" ] || git clone https://github.com/johackim/dotfiles ~/.dotfiles

~/.dotfiles/.local/bin/dotfiles.sh

if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay-bin.git ~/.cache/yay-bin
    (cd ~/.cache/yay-bin && makepkg -si --noconfirm)
    rm -rf ~/.cache/yay-bin
fi

yay -S --sudoloop --noconfirm --needed --overwrite="*" fonts-noto-hinted ttf-ms-fonts wpgtk masterpassword-cli keynav spotify spotx-git themix-theme-oomox-git themix-icons-archdroid-git

export PATH="$PATH:$HOME/.local/bin"
wpg -a ~/.dotfiles/wallpaper.jpg
wpg -s wallpaper.jpg

nvim --headless +qa
