#!/bin/bash

echo "Upgrade packages..."

sudo pacman -Syyu --noconfirm

echo "Install base-devel..."

sudo pacman -S --noconfirm --needed base-devel

echo "Install git..."

sudo pacman -S --noconfirm --needed git

echo "Install dotfiles..."

if [[ ! -d "$HOME/.dotfiles" ]]; then
    git clone --recursive https://github.com/johackim/dotfiles ~/.dotfiles
    cd ~/.dotfiles && make install-dotfiles
fi

echo "Install yay..."

cd ~/.dotfiles && sudo make install-yay

echo "Install xorg..."

sudo pacman -S --noconfirm --needed xorg xorg-xinit

echo "Install i3..."

sudo pacman -S --noconfirm --needed i3-gaps dmenu xcompmgr
sudo cp ~/.local/bin/dmenu_recent_aliases.sh /usr/local/bin/dmenu_recent_aliases

echo "Install urxvt..."

sudo pacman -S --noconfirm --needed rxvt-unicode

echo "Install zsh..."

sudo pacman -S --noconfirm --needed zsh
sudo chsh -s "$(which zsh)" "$(whoami)"

echo "Install dunst..."

sudo pacman -S --noconfirm --needed dunst

echo "Install pipewire..."

sudo pacman -S --noconfirm --needed pipewire pipewire-alsa pipewire-pulse pipewire-jack pipewire-audio

echo "Install touchpad..."

sudo pacman -S --noconfirm --needed xf86-input-synaptics

echo "Install bluetooth..."

sudo pacman -S --noconfirm --needed bluez blueman bluez-hid2hci
sudo systemctl enable --now bluetooth

echo "Install fonts..."

sudo pacman -S --noconfirm --needed ttf-inconsolata-nerd noto-fonts-emoji gnu-free-fonts
yay -S --sudoloop --noconfirm --needed fonts-noto-hinted ttf-ms-fonts

echo "Install nodejs..."

sudo pacman -S --noconfirm --needed nodejs yarn

echo "Install gtk..."

sudo pacman -S --noconfirm --needed gtk3 libappindicator-gtk3 lxappearance

echo "Install polybar..."

yay -S --sudoloop --noconfirm --needed polybar jq

echo "Install networkmanager-applet..."

sudo pacman -S --noconfirm --needed network-manager-applet

echo "Install wpg..."

sudo pacman -S --noconfirm --needed python python-pip python-gobject python-pillow
sudo pacman -S --noconfirm --needed wget feh
sudo pip install pywal --break-system-packages
yay -S --sudoloop --noconfirm --needed --overwrite="*" wpgtk

echo "Install tmux..."

sudo pacman -S --noconfirm --needed tmux xclip lsof htop progress neofetch
yay -S --sudoloop --noconfirm --needed tmuxinator

echo "Install chromium..."

sudo pacman -S --noconfirm --needed chromium

echo "Install neovim..."

sudo pacman -S --noconfirm --needed neovim
curl -sfLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qa!

echo "Install spotify..."

yay -S --sudoloop --noconfirm --needed spotify spotx-git ffmpeg-compat-57

echo "Install misc tools..."

sudo pacman -S --noconfirm --needed --overwrite="*" restic thunar scrot eog mplayer trash-cli inetutils gnome-keyring pkgfile fd net-tools mousepad cronie signal-desktop qbittorrent firefox docker evince calibre the_silver_searcher telegram-desktop mpv aria2 ncdu brightnessctl cronie polkit-kde-agent arandr i3status
yay -S --sudoloop --noconfirm --needed masterpassword-cli keynav
sudo systemctl enable --now cronie docker
sudo pip install yt-dlp httpie --break-system-packages

# Reload session manually
# Apply Gtk and icons theme with lxappearance manually
