.PHONY: install
.ONESHELL:

hostname := "arch"
username := "jcherqui"
current_dir:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install: install-essentials install-nvidia-driver install-pacman-packages install-yaourt-packages install-dotbot install-virtualbox install-wine install-pip-packages install-npm-packages enable-services

install-base:
	echo ${hostname} > /etc/hostname
	echo 'LANG=en_US.UTF-8' > /etc/locale.conf
	ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
	hwclock --systohc --utc
	cp vconsole.conf /etc/
	useradd -m -g users -G wheel -s /bin/zsh ${username}

install-dotbot:
	@ read -r -p "You want install dotbot ? [y/N] " REPLY;
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then
		pacman -Qq | grep -qw python || sudo pacman -Sy python
		pacman -Qq | grep -qw cmake || sudo pacman -Sy cmake
		git submodule update --init --recursive dotbot
		${current_dir}/dotbot/bin/dotbot -d ${current_dir} -c install.conf.yaml
		git submodule update --init --recursive
		@ read -r -p "You want compile YouCompleteMe ? [y/N] " REPLY;
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			sh ~/.vim/bundle/YouCompleteMe/install.sh
		fi
	fi

install-essentials:
	@ read -r -p "You want install essentials packages ? [y/N] " REPLY;
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then
		sudo cp pacman.conf /etc/pacman.conf
		sudo pacman --needed -Syu \
		xf86-input-libinput xf86-input-synaptics \
		networkmanager network-manager-applet networkmanager-openvpn openvpn gnome-keyring \
		xorg-server xorg-xinit xorg-server-utils xorg-xrandr xorg-xkill arandr \
		alsa-utils alsa-lib lib32-alsa-lib \
		rxvt-unicode xterm \
		acpi acpid \
		net-tools
		sudo systemctl enable NetworkManager
	fi

# Nvidia driver for The New Razer Blade (2016)
install-nvidia-driver:
	@ read -r -p "You want install nvidia driver ? (WARNING: configuration's Razer Blade) [y/N] " REPLY;
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then
		sudo pacman -S intel-dri xf86-video-intel bumblebee lib32-nvidia-utils lib32-intel-dri primus lib32-primus nvidia nvidia-utils lib32-nvidia-utils
		echo 'blacklist nouveau' | sudo tee /etc/modprobe.d/nvidia.conf
		echo 'options nouveau modeset=0' | sudo tee -a /etc/modprobe.d/nvidia.conf
		sudo cp nvidia.conf /etc/X11/xorg.conf.d/20-nvidia.conf
	fi

install-pacman-packages:
	@ read -r -p "You want install pacman packages ? [y/N] " REPLY;
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then
		sudo pacman --needed -Syu \
		yaourt \
		wget \
		curl \
		zsh \
		mlocate \
		cmake \
		openssh \
		unzip unrar p7zip \
		pkgfile \
		ctags \
		lsof \
		htop \
		ttf-dejavu terminus-font \
		ncftp filezilla \
		udisks \
		ntfs-3g exfat-utils cifs-utils fuse-exfat \
		dosfstools \
		firefox chromium \
		vlc mplayer mpv \
		fdupes \
		fail2ban \
		ntp \
		gnome-calculator \
		dunst \
		libnotify \
		faenza-icon-theme \
		flashplugin \
		speedtest-cli \
		gtk3 \
		gtk-engines \
		gtk-engine-murrine \
		lxappearance \
		i3 \
		dmenu \
		progress \
		numlockx \
		tig \
		newsbeuter \
		tmux \
		nmap \
		the_silver_searcher \
		python-pip python-virtualenv \
		ncmpcpp \
		screenfetch \
		scummvm dosemu dosbox \
		ncdu \
		thefuck cmatrix cowsay \
		clamav rkhunter \
		xclip \
		aria2 plowshare \
		offlineimap \
		w3m \
		scrot xfce4-screenshooter \
		ristretto tumbler feh eog \
		rlwrap \
		weechat aspell tcl \
		evince zathura-pdf-mupdf \
		proxychains-ng \
		rsync duplicity \
		thunar thunar-volman thunar-media-tags-plugin gvfs-afc thunar-archive-plugin \
		libimobiledevice \
		httpie \
		tigervnc \
		zip \
		ccze \
		gcolor2 \
		aspell-fr \
		tcpdump \
		guvcview \
		mousepad leafpad \
		kaffeine \
		rfkill \
		vim sublime-text codeblocks monodevelop \
		lshw \
		mysql-workbench \
		orage \
		xfce4-notes-plugin \
		mariadb-clients \
		bind-tools \
		whois \
		recordmydesktop gtk-recordmydesktop \
		libmtp mtpfs \
		cups gutenprint system-config-printer \
		jdk7-openjdk jdk8-openjdk \
		gksu \
		docker docker-compose \
		jq \
		perl-image-exiftool \
		qemu \
		espeak \
		mkvtoolnix-cli \
		docx2txt \
		tree \
		phantomjs \
		gimp \
		perl-file-mimeinfo \
		syncthing \
		asciinema \
		borg \
		srm \
		hardinfo \
		apg \
		cool-retro-term \
		picard \
		veracrypt \
		downgrade \
		obfsproxy \
		netdata \
		python2-powerline \
		mednafen \
		bchunk \
		simple-scan
	fi

install-yaourt-packages:
	@ read -r -p "You want install yaourt packages ? [y/N] " REPLY;
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then
		yaourt --noconfirm -Sy \
		kpcli \
		mcrypt \
		tmuxinator \
		light \
		ttf-ms-fonts \
		zeal-git \
		simple-mtpfs \
		utox \
		atom-editor \
		etcher \
		vlsub-git \
		thunar-thumbnailers \
		nvm \
		nodejs-tldr

		yaourt --noconfirm -Sy \
		tor-browser-en \
		wego-git \
		namebench \
		popcorntime-community pirate-get megatools pirateflix \
		jp2a \
		chkrootkit \
		wiki-git \
		powermonius-git \
		g4l \
		sopcast-player \
		fritzing \
		minecraft \
		toxic-git \
		android-studio \
		s \
		bleachbit-cli \
		np1-mps \
		packettracer \
		zeronet \
		git-extras \
		balsamiqmockups \
		wpscan \
		theharvester-git \
		securefs \
		aur/slack-desktop \
		snapcraft \
		screenkey \
		devd \
		bitchx-git \
		molotov \
		ruby-travis
	fi

install-pip-packages:
	@ read -r -p "You want install pip packages ? [y/N] " REPLY;
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then
		sudo pip install --upgrade instantmusic mycli subliminal whatportis youtube-dl maybe fig awscli gitsome socli
	fi

install-pgcli:
	sudo pacman -S postgresql-libs
	sudo pip install --upgrade pgcli

install-npm-packages:
	@ read -r -p "You want install npm packages ? [y/N] " REPLY;
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then
		[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh
		nvm install --lts
		nvm use --lts
		sudo npm -g install instant-markdown-d peerflix cloudconvert-cli rdcli psi grunt-cli gulp browser-sync diff-so-fancy learnyounode bitly-cli etcher-cli git-open wappalyzer-cli speed-test subsync npm-check-updates json dispatch-proxy npms-cli jsonlint
		sudo npm install -g fast-cli torrentflix bower
	fi

install-virtualbox:
	@ set -e
	@ read -r -p "You want install virtualbox ? [y/N] " REPLY;
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then
		yaourt --noconfirm -Sy virtualbox virtualbox-ext-oracle virtualbox-host-dkms vagrant
		echo -e 'vboxdrv\nvboxnetadp\nvboxnetflt\nvboxpci' | sudo tee /etc/modules-load.d/virtualbox.conf
		sudo /usr/bin/rcvboxdrv setup
	fi

install-wine:
	@ read -r -p "You want install wine ? [y/N] " REPLY;
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then
		sudo pacman -S wine winetricks wine-mono wine_gecko lib32-libxslt lib32-libxml2 playonlinux samba zenity
		winetricks d3dx9
	fi

install-firewall:
	sudo pacman -S --needed iptables
	sudo sed -i -e 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
	sudo bash ~/bin/firewall && sudo iptables-save | sudo tee /etc/iptables/iptables.rules
	sudo systemctl enable iptables 

install-mutt:
	# [Passwords management]([https://wiki.archlinux.org/index.php/mutt#Passwords_management)
	yaourt --noconfirm -Sy mutt-patched
	systemctl --user enable offlineimap

install-mpd:
	sudo pacman -S mpd mpc
	mkdir -p ~/.mpd/playlists && touch ~/.mpd/{mpd.log,mpd.db,mpd.error,state}
	systemctl --user enable mpd

install-razer-packages:
	yaourt -S --noconfirm openrazer-drivers-dkms razer_blade_14_2016_acpi_dsdt-git

enable-services:
	@ read -r -p "You want enable services ? [y/N] " REPLY;
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then
		sudo systemctl enable acpid ntpd docker
		systemctl --user enable syncthing
	fi

enable-ftp:
	echo 'ip_conntrack_ftp' | sudo tee /etc/modules-load.d/ftp.conf

enable-magic-keys:
	echo "kernel.sysrq = 1" | sudo tee /etc/sysctl.d/99-sysctl.conf

enable-zsh:
	@ [[ ! $SHELL = "/bin/zsh" ]] && chsh -s /bin/zsh