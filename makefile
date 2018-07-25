.ONESHELL:
.SILENT:
CURRENT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

create-new-partitions: umount-partitions
	@ while true; do
		@ read -r -p "Do you want create new partitions ? (WARNING: You need to be in live system) [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			@ echo -e
			@ echo -e "WARNING! This will removed your device irrevocably!"
			@ read -r -p "Are you sure? (Type uppercase yes) " REPLY;
			if [[ $$REPLY == "YES" ]]; then
				@ DEVICES_LIST=(`lsblk -d | awk '{print "/dev/" $$1}' | grep 'sd\|hd\|vd\|nvme\|mmcblk'`);
				@ echo -e '\nSelect device to setup lvm+luks:'
				select DEVICE in $${DEVICES_LIST[@]}; do
					break
				done
				@ parted -s $${DEVICE} mklabel gpt
				@ parted -s $${DEVICE} mkpart primary 1MiB 100MiB # EFI (100MB)
				@ parted -s $${DEVICE} mkpart primary 100MiB 350MiB # Boot (250MB)
				@ parted -s $${DEVICE} mkpart primary 350MiB 100% # Crypted (100%)
				@ mkfs.vfat -F32 $${DEVICE}1
				@ mkfs.ext2 -F $${DEVICE}2
				@ read -s -r -p "Enter new luks passphrase: " PASSPHRASE; echo
				@ echo -n $${PASSPHRASE} | cryptsetup -q luksFormat -c aes-xts-plain64 -s 512 $${DEVICE}3 -d -
				@ echo -n $${PASSPHRASE} | cryptsetup -q luksOpen $${DEVICE}3 lvm -d -
				@ pvcreate -yff /dev/mapper/lvm
				@ vgcreate arch /dev/mapper/lvm
				@ read -r -p "Enter swap size: " -e -i "3G" SWAP_SIZE;
				@ lvcreate -L $${SWAP_SIZE}G arch -n swap
				@ read -r -p "Enter root size: " -e -i "100G" ROOT_SIZE;
				@ lvcreate -L $${ROOT_SIZE} arch -n root
				@ lvcreate -l +100%FREE arch -n home
				@ mkfs.ext4 /dev/mapper/arch-root
				@ mkfs.ext4 /dev/mapper/arch-home
				@ mkswap /dev/mapper/arch-swap
			fi
			exit 0
		fi
	@ done

install-new-arch: check-root check-archlinux umount-partitions
	@ while true; do
		@ read -r -p "Do you want install new Arch Linux ? (WARNING: You need to be in live system) [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			@ echo -e
			@ echo -e "WARNING! This will overwrite root,boot,efi partitions irrevocably!"
			@ read -r -p "Are you sure? (Type uppercase yes) " REPLY;
			if [[ $$REPLY == "YES" ]]; then
				@ DEVICES_LIST=(`lsblk -d | awk '{print "/dev/" $$1}' | grep 'sd\|hd\|vd\|nvme\|mmcblk'`);
				@ echo -e '\nSelect device to setup lvm+luks:'
				select DEVICE in $${DEVICES_LIST[@]}; do
					break
				done
				@ read -s -r -p "Enter luks passphrase: " PASSPHRASE; echo
				@ echo -n $${PASSPHRASE} | cryptsetup -q luksOpen $${DEVICE}3 lvm -d -
				@ [[ $$? != 0 ]] && exit 1
				@ vgchange -ay && sleep 1
				@ mkfs.vfat -F32 $${DEVICE}1
				@ mkfs.ext2 -F $${DEVICE}2
				@ mkfs.ext4 -F /dev/mapper/arch-root
				@ mount /dev/mapper/arch-root /mnt/
				@ mkdir -p /mnt/{boot,home}
				@ mount /dev/mapper/arch-home /mnt/home/
				@ mount $${DEVICE}2 /mnt/boot/
				@ mkdir -p /mnt/boot/efi
				@ mount $${DEVICE}1 /mnt/boot/efi/
				@ swapon /dev/mapper/arch-swap
				@ pacstrap /mnt base base-devel net-tools sudo gvim git grub efibootmgr dmidecode
				@ genfstab -p /mnt >> /mnt/etc/fstab
				@ sed -i -e 's|GRUB_CMDLINE_LINUX=""|GRUB_CMDLINE_LINUX="cryptdevice='$${DEVICE}'3:lvm"|g' /mnt/etc/default/grub
				@ arch-chroot /mnt dmidecode | grep VirtualBox
				if [[ $$? == 0 ]]; then
					@ arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck --removable
				else
					@ arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck
				fi
				@ arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
				@ sed -i -e '/^HOOKS/s/filesystems/encrypt lvm2 filesystems/' /mnt/etc/mkinitcpio.conf
				@ arch-chroot /mnt mkinitcpio -p linux
				@ make chroot-configure-arch
			fi
			exit 0
		fi
	@ done

configure-arch: check-root check-archlinux \
	configure-keymap \
	configure-hostname \
	configure-timezone \
	configure-hardware-clock \
	configure-locale \
	configure-sudo \
	enable-multilib-repositorie \
	install-aur-helper \
	install-xorg \
	install-gpu-drivers \
	install-audio-drivers \
	install-network-manager \
	install-window-manager \
	configure-high-dpi \
	configure-touchpad \
	configure-dns \
	configure-root-password

chroot-configure-arch:
	@ arch-chroot /mnt git clone https://github.com/ston3o/dotfiles ~/.dotfiles
	@ arch-chroot /mnt make configure-arch -C ~/.dotfiles

configure-user: check-non-root \
	install-packages \
	enable-zsh \
	install-dotfiles \
	enable-services \

backup:
	${CURRENT_DIR}/bin/backup

check-root:
	@ if [ $$(whoami) != "root" ]; then
		@ echo "Permission denied! You must execute the script as the 'root' user."
		@ exit 1
	@ fi

check-non-root:
	@ if [ $$(whoami) == "root" ]; then
		@ echo "Error! You must execute the script as non-root user."
		@ exit 1
	@ fi

check-archlinux:
	@ if [[ ! -e /etc/arch-release ]]; then
		@ echo "Error! You must execute the script on Arch Linux."
		@ exit 1
	@ fi

install-base-system:
	@ pacstrap /mnt base base-devel net-tools sudo gvim git

configure-fstab:
	@ genfstab -p /mnt >> /mnt/etc/fstab

mount-partitions: umount-partitions
	@ DEVICES_LIST=(`lsblk -d | awk '{print "/dev/" $$1}' | grep 'sd\|hd\|vd\|nvme\|mmcblk'`);
	@ echo -e 'Select device:'
	select DEVICE in $${DEVICES_LIST[@]}; do
		break
	done
	@ read -s -r -p "Enter luks passphrase: " PASSPHRASE; echo
	@ echo -n $${PASSPHRASE} | cryptsetup -q luksOpen $${DEVICE}3 lvm -d -
	@ vgchange -ay && sleep 1
	@ mount /dev/mapper/arch-root /mnt/
	@ mkdir -p /mnt/{boot,home}
	@ mount /dev/mapper/arch-home /mnt/home/
	@ mount $${DEVICE}2 /mnt/boot/
	@ mkdir -p /mnt/boot/efi
	@ mount $${DEVICE}1 /mnt/boot/efi/
	@ swapon /dev/mapper/arch-swap

umount-partitions:
	@- umount -R /mnt/boot/efi > /dev/null 2>&1
	@- umount -R /mnt/boot/ > /dev/null 2>&1
	@- umount -R /mnt/home > /dev/null 2>&1
	@- umount -R /mnt/ > /dev/null 2>&1
	@- swapoff -a > /dev/null 2>&1
	@- dmsetup remove_all --force > /dev/null 2>&1

chroot:
	@ arch-chroot /mnt

configure-keymap:
	@ echo "KEYMAP=us" > /etc/vconsole.conf
	@ echo "Keymap configuration. Done."

configure-hostname:
	@ echo "archlinux" > /etc/hostname
	@ echo "Hostname configuration. Done."

configure-timezone:
	@ ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
	@ echo "Timezone configuration. Done."

configure-hardware-clock:
	@ hwclock --systohc --localtime
	@ echo "Hardware clock configuration. Done."

configure-locale:
	@ echo 'LANG="en_US.UTF-8"' > /etc/locale.conf
	@ sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
	@ locale-gen
	@ echo "Locale configuration. Done."

configure-mkinitcpio:
	@ sed -i -e '/^HOOKS/s/block filesystems/block encrypt lvm2 filesystems/' /etc/mkinitcpio.conf
	@ mkinitcpio -p linux

configure-bootloader:
	@ pacman -Sy --noconfirm --needed grub
	@ pacman -S --noconfirm --needed efibootmgr # Only with EFI

	# Only with LUKS
	@ DEVICES_LIST=(`lsblk -d | awk '{print "/dev/" $$1}' | grep 'sd\|hd\|vd\|nvme\|mmcblk'`);
	@ echo -e 'Select partition to configure bootloader:'
	select DEVICE in $${DEVICES_LIST[@]}; do
		break
	done
	@ sed -i -e 's|GRUB_CMDLINE_LINUX=""|GRUB_CMDLINE_LINUX="cryptdevice='$${DEVICE}'3:lvm"|g' /etc/default/grub

	@ grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck # Only with EFI
	@ grub-mkconfig -o /boot/grub/grub.cfg

configure-root-password:
	@ while true; do
		@ read -r -p "Do you want configure root password ? [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			@ passwd
			exit 0
		fi
	@ done

configure-sudo:
	@ sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
	@ echo "Sudo configuration. Done."

enable-multilib-repositorie:
	@ cp /etc/pacman.conf /etc/pacman.conf.bak
	@ sed -i ':a;N;$$!ba;s/#Include/Include/4' /etc/pacman.conf
	@ sed -i 's/#\[multilib]/[multilib]/g' /etc/pacman.conf
	@ sed -i 's/#Color/Color/g' /etc/pacman.conf
	@ pacman -Syy
	@ echo "Multilib configuration. Done."

install-aur-helper:
	@ test -x /usr/bin/yay
	@ if [[ $$? != 0 ]]; then
		@ pacman -S --noconfirm --needed go
		@ cp /usr/bin/makepkg /usr/bin/makepkg.bak
		@ sed -i "s/'version'/'version' 'asroot'/g" /usr/bin/makepkg
		@ sed -i "s/exit \$$E_ROOT/#exit \$$E_ROOT/g" /usr/bin/makepkg
		@ git clone https://aur.archlinux.org/yay.git /tmp/yay
		@ cd /tmp/yay && makepkg --noconfirm -i && cd -
		@ mv /usr/bin/makepkg.bak /usr/bin/makepkg
	@ fi
	@ echo "AUR Helper installation. Done."

install-xorg:
	@ pacman -S --noconfirm --needed xorg-server xorg-xinit xorg-xrandr xorg-xkill arandr
	@ echo "Xorg installation. Done."

install-gpu-drivers:
	@ sed -i 's/MODULES=()/MODULES=(nvidia)/g' /etc/mkinitcpio.conf
	@ pacman -S --noconfirm --needed nvidia nvidia-utils libglvnd lib32-nvidia-utils
	@ echo "GPU Drivers installation. Done."

install-audio-drivers:
	@ pacman -S --noconfirm --needed alsa-utils alsa-plugins alsa-lib lib32-alsa-lib pulseaudio-alsa
	@ echo "Audio Drivers installation. Done."

install-network-manager:
	@ pacman -S --noconfirm --needed networkmanager network-manager-applet networkmanager-openvpn openvpn gnome-keyring
	@ systemctl enable NetworkManager
	@ echo "Network Manager installation. Done."

install-window-manager:
	@ pacman -S --noconfirm i3
	@ echo "Window Manager installation. Done."

enable-firewall:
	@ pacman -S --noconfirm --needed iptables
	@ sed -i -e 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
	@ bash ${CURRENT_DIR}/bin/firewall && iptables-save > /etc/iptables/iptables.rules
	@ systemctl enable iptables
	@ echo "Firewall enabled. Done."

disable-firewall:
	@ iptables -F
	@ iptables -F -t mangle
	@ iptables -F -t nat
	@ iptables -X
	@ iptables -X -t mangle
	@ iptables -X -t nat
	@ iptables -P INPUT ACCEPT
	@ iptables -P FORWARD ACCEPT
	@ echo "Firewall disabled. Done."

enable-magic-keys:
	@ echo "kernel.sysrq = 1" > /etc/sysctl.d/99-sysctl.conf
	@ echo "Magic Keys enabled. Done."

disable-magic-keys:
	@ rm -f /etc/sysctl.d/99-sysctl.conf
	@ echo "Magic Keys disabled. Done."

configure-high-dpi:
	@ echo 'export QT_AUTO_SCREEN_SCALE_FACTOR=0' > /etc/profile.d/qt-hidpi.sh
	@ echo 'export QT_SCALE_FACTOR=2' >> /etc/profile.d/qt-hidpi.sh
	@ echo "HIGH DPI configuration. Done."

configure-touchpad:
	@ pacman -S --noconfirm --needed xf86-input-synaptics xf86-input-libinput libinput
	@ cp /usr/share/X11/xorg.conf.d/70-synaptics.conf /etc/X11/xorg.conf.d/70-synaptics.conf
	# Option "TapButton1" "1"
	# Option "TapButton2" "3"

add-new-user:
	@ while true; do
		@ read -r -p "Do you want add new user ? [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			@ read -r -p "Enter username: " USERNAME;
			@ useradd -m -g users -G wheel -s /bin/bash $${USERNAME}
			@ passwd $${USERNAME}
			@ sudo -u $${USERNAME} git clone https://github.com/ston3o/dotfiles /home/$${USERNAME}/.dotfiles
			exit 0
		fi
	@ done

install-dotfiles:
	@ while true; do
		@ read -r -p "Do you want install dotfiles ? [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			@ pacman -Qq | grep -qw python || sudo pacman -Sy --noconfirm python
			@ pacman -Qq | grep -qw cmake || sudo pacman -Sy --noconfirm cmake
			@ git submodule update --init --recursive
			@ ${CURRENT_DIR}/dotbot/bin/dotbot -d ${CURRENT_DIR} -c install.conf.yaml
			@ echo "Dotfiles installation. Done."
			exit 0
		fi
	@ done

install-other-packages:
	@ while true; do
		@ read -r -p "Do you want install packages ? [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			@ make install-arch-packages install-pip-packages install-gem-packages install-npm-packages install-go-packages
			exit 0
		fi
	@ done

install-packages:
	@ sudo pacman -S --noconfirm --needed rxvt-unicode firefox acpi tmux mpd mpc offlineimap htop zsh lsof progress newsboat ncmpcpp mutt weechat dmenu neofetch feh thunar
	@ yay -S --noconfirm --needed tmuxinator
	@ echo "User packages installation. Done."

install-arch-packages:
	@ while true; do
		@ read -r -p "Do you want install arch packages ? [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			yay --noconfirm -S $$(cat ${CURRENT_DIR}/packages.txt)
			exit 0
		fi
	@ done

install-pip-packages:
	@ while true; do
		@ read -r -p "Do you want install pip packages ? [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			@ pip install --upgrade instantmusic mycli subliminal whatportis youtube-dl maybe fig awscli gitsome socli cheat greg httpstat http-prompt magic-wormhole seashells
			exit 0
		fi
	@ done

install-gem-packages:
	@ while true; do
		@ read -r -p "Do you want install gem packages ? [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			@ gem install wayback_machine_downloader
			exit 0
		fi
	@ done

install-npm-packages:
	@ while true; do
		@ read -r -p "Do you want install npm packages ? [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			@ npm install -g instant-markdown-d cloudconvert-cli psi grunt-cli diff-so-fancy learnyounode bitly-cli etcher-cli git-open wappalyzer-cli speed-test subsync npm-check-updates json dispatch-proxy npms-cli jsonlint sitemap-generator yarn tget lighthouse npm-check git-standup imgclip mapscii ngrock stacks-cli conduct fast-cli
			exit 0
		fi
	@ done


install-go-packages:
	@ while true; do
		@ read -r -p "Do you want install go packages ? [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			@ go get github.com/tj/node-prune/cmd/node-prune
			@ go get github.com/apex/gh-polls/cmd/polls
			exit 0
		fi
	@ done

configure-dns: check-root
	@ cp ${CURRENT_DIR}/resolv.conf /etc/resolv.conf
	# @ chattr +i /etc/resolv.conf
	@ echo "DNS configuration. Done."

enable-services:
	@ systemctl --user enable syncthing
	@ systemctl --user enable mpd
	@ systemctl --user enable offlineimap

enable-webcam: check-root
	@ modprobe uvcvideo
	@ rm -f /etc/modprobe.d/webcam.conf

disable-webcam: check-root
	@ modprobe -r uvcvideo
	@ echo 'blacklist uvcvideo' > /etc/modprobe.d/webcam.conf

clean-orphan-packages: check-root
	@ pacman -Rsc --noconfirm $$(pacman -Qqdt)

install-virtualbox: check-root
	@ while true; do
		@ read -r -p "Do you want clean orphan packages ? [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			yay -S --needed --noconfirm virtualbox virtualbox-host-modules-arch virtualbox-ext-oracle
			echo -e 'vboxdrv\nvboxnetadp\nvboxnetflt\nvboxpci' > /etc/modules-load.d/virtualbox.conf
			/usr/bin/rcvboxdrv setup
			exit 0
		fi
	@ done

enable-zsh:
	@ if [[ $$SHELL != "/bin/zsh" ]]; then
		@ chsh -s /bin/zsh
	@ fi
