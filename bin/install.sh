#!/bin/bash

echo "Install git..."

sudo pacman -S --noconfirm --needed git > /dev/null 2>&1

echo "Install dotfiles..."

if [[ ! -d "$HOME/.dotfiles" ]]; then
    git clone --recursive https://github.com/johackim/dotfiles ~/.dotfiles > /dev/null 2>&1
    cd ~/.dotfiles && make install-dotfiles > /dev/null 2>&1
fi

echo "Install yay..."

cd ~/.dotfiles && sudo make install-yay > /dev/null 2>&1

echo "Install xorg..."

sudo pacman -S --noconfirm --needed xorg xorg-xinit > /dev/null 2>&1

echo "Install i3..."

sudo pacman -S --noconfirm --needed i3 dmenu xcompmgr > /dev/null 2>&1
sudo cp ~/bin/dmenu_recent_aliases /usr/local/bin/

echo "Install urxvt..."

sudo pacman -S --noconfirm --needed rxvt-unicode > /dev/null 2>&1

echo "Install zsh..."

sudo pacman -S --noconfirm --needed zsh > /dev/null 2>&1
sudo chsh -s "$(which zsh)" "$(whoami)" > /dev/null 2>&1

echo "Install dunst..."

sudo pacman -S --noconfirm --needed dunst > /dev/null 2>&1

echo "Install alsa..."

sudo pacman -S --noconfirm --needed alsa-utils > /dev/null 2>&1

echo "Install touchpad..."

sudo pacman -S --noconfirm --needed xf86-input-synaptics > /dev/null 2>&1

echo "Install bluetooth..."

sudo pacman -S --noconfirm --needed bluez blueman bluez-hid2hci pulseaudio-bluetooth > /dev/null 2>&1
sudo systemctl enable --now bluetooth > /dev/null 2>&1

echo "Install fonts..."

yay -S --sudoloop --noconfirm --needed nerd-fonts nerd-fonts-inconsolata noto-fonts-emoji > /dev/null 2>&1

echo "Install nodejs..."

sudo pacman -S --noconfirm --needed nodejs yarn > /dev/null 2>&1

echo "Install gtk..."

sudo pacman -S --noconfirm --needed gtk3 libappindicator-gtk3 lxappearance > /dev/null 2>&1

echo "Install polybar..."

yay -S --sudoloop --noconfirm --needed polybar jq > /dev/null 2>&1

echo "Install networkmanager-applet..."

sudo pacman -S --noconfirm --needed network-manager-applet > /dev/null 2>&1

echo "Install wpg..."

sudo pacman -S --noconfirm --needed python python2 python-pip python-gobject python-pillow > /dev/null 2>&1
sudo pacman -S --noconfirm --needed wget feh thunar > /dev/null 2>&1
yay -S --sudoloop --noconfirm --needed themix-full-git > /dev/null 2>&1
sudo pip3 install pywal wpgtk > /dev/null 2>&1
wget -qO ~/Images/wallpaper-cyan.jpg https://i.imgur.com/TZJYo2k.jpeg > /dev/null 2>&1

echo "Install tmux..."

sudo pacman -S --noconfirm --needed tmux xclip lsof htop progress neofetch > /dev/null 2>&1
yay -S --sudoloop --noconfirm --needed tmuxinator > /dev/null 2>&1

echo "Install chromium..."

sudo pacman -S --noconfirm --needed chromium > /dev/null 2>&1

echo "Install neovim..."

sudo pacman -S --noconfirm --needed neovim > /dev/null 2>&1
curl -sfLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +"!yarn --cwd ~/.config/nvim/coc.nvim/" +qa! > /dev/null 2>&1

# Reload session manually
# Apply Gtk and icons theme with lxappearance manually
