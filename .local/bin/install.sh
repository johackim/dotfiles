#!/bin/bash

echo "Upgrade packages..."

sudo pacman -Syyu --noconfirm > /dev/null 2>&1

echo "Install base-devel..."

sudo pacman -S --noconfirm --needed base-devel > /dev/null 2>&1

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

sudo pacman -S --noconfirm --needed i3-gaps dmenu xcompmgr > /dev/null 2>&1
sudo cp ~/.local/bin/dmenu_recent_aliases.sh /usr/local/bin/dmenu_recent_aliases

echo "Install urxvt..."

sudo pacman -S --noconfirm --needed rxvt-unicode > /dev/null 2>&1

echo "Install zsh..."

sudo pacman -S --noconfirm --needed zsh > /dev/null 2>&1
sudo chsh -s "$(which zsh)" "$(whoami)" > /dev/null 2>&1

echo "Install dunst..."

sudo pacman -S --noconfirm --needed dunst > /dev/null 2>&1

echo "Install pipewire..."

sudo pacman -S --noconfirm --needed pipewire pipewire-alsa pipewire-pulse pipewire-jack pipewire-audio > /dev/null 2>&1

echo "Install touchpad..."

sudo pacman -S --noconfirm --needed xf86-input-synaptics > /dev/null 2>&1

echo "Install bluetooth..."

sudo pacman -S --noconfirm --needed bluez blueman bluez-hid2hci > /dev/null 2>&1
sudo systemctl enable --now bluetooth > /dev/null 2>&1

echo "Install fonts..."

sudo pacman -S --noconfirm --needed nerd-fonts ttf-inconsolata-nerd noto-fonts-emoji gnu-free-fonts > /dev/null 2>&1
yay -S --sudoloop --noconfirm --needed fonts-noto-hinted ttf-ms-fonts > /dev/null 2>&1

echo "Install nodejs..."

sudo pacman -S --noconfirm --needed nodejs yarn > /dev/null 2>&1

echo "Install gtk..."

sudo pacman -S --noconfirm --needed gtk3 libappindicator-gtk3 lxappearance > /dev/null 2>&1

echo "Install polybar..."

yay -S --sudoloop --noconfirm --needed polybar jq > /dev/null 2>&1

echo "Install networkmanager-applet..."

sudo pacman -S --noconfirm --needed network-manager-applet > /dev/null 2>&1

echo "Install wpg..."

sudo pacman -S --noconfirm --needed python python-pip python-gobject python-pillow > /dev/null 2>&1
sudo pacman -S --noconfirm --needed wget feh > /dev/null 2>&1
sudo pip install pywal --break-system-packages > /dev/null 2>&1
yay -S --sudoloop --noconfirm --needed --overwrite="*" themix-full-git wpgtk > /dev/null 2>&1

echo "Install tmux..."

sudo pacman -S --noconfirm --needed tmux xclip lsof htop progress neofetch > /dev/null 2>&1
yay -S --sudoloop --noconfirm --needed tmuxinator > /dev/null 2>&1

echo "Install chromium..."

sudo pacman -S --noconfirm --needed chromium > /dev/null 2>&1

echo "Install neovim..."

sudo pacman -S --noconfirm --needed neovim > /dev/null 2>&1
curl -sfLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2>&1
nvim +PlugInstall +qa! > /dev/null 2>&1

echo "Install spotify..."

yay -S --sudoloop --noconfirm --needed spotify ffmpeg-compat-57 > /dev/null 2>&1
sudo pip install -U spotify-cli-linux dbus-python --break-system-packages > /dev/null 2>&1

echo "Install misc tools..."

sudo pacman -S --noconfirm --needed --overwrite="*" restic thunar scrot eog mplayer trash-cli inetutils gnome-keyring pkgfile fd net-tools mousepad cronie signal-desktop qbittorrent firefox docker evince calibre the_silver_searcher telegram-desktop mpv aria2 ncdu brightnessctl cronie polkit-kde-agent arandr i3status > /dev/null 2>&1
yay -S --sudoloop --noconfirm --needed masterpassword-cli keynav > /dev/null 2>&1
sudo systemctl enable --now cronie docker > /dev/null 2>&1
sudo pip install yt-dlp httpie --break-system-packages > /dev/null 2>&1

# Reload session manually
# Apply Gtk and icons theme with lxappearance manually
