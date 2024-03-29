.ONESHELL:
.SILENT:

CURRENT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

upgrade:
	@ sudo pacman -Syyu --noconfirm

install-yay:
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
	@ echo "Yay installation. Done."

install-dotfiles:
	@ pacman -Qq | grep -qw python || sudo pacman -Sy --noconfirm python
	@ pacman -Qq | grep -qw cmake || sudo pacman -Sy --noconfirm cmake
	@ git submodule update --init --recursive
	@ ${CURRENT_DIR}/dotbot/bin/dotbot -d ${CURRENT_DIR} -c install.conf.yaml
	@ echo "Dotfiles installation. Done."

install-virtualbox: upgrade
	@ while true; do
		@ read -r -p "Do you want install virtualbox ? [y/N] " REPLY;
		[[ $$REPLY == '' || $$REPLY =~ ^[Nn]$$ ]] && exit 0
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then
			yay -S --sudoloop --needed --noconfirm virtualbox virtualbox-host-modules-arch virtualbox-ext-oracle linux-headers
			echo -e 'vboxdrv\nvboxnetadp\nvboxnetflt' | sudo tee /etc/modules-load.d/virtualbox.conf
			sudo /usr/bin/rcvboxdrv setup
			sudo systemctl restart systemd-modules-load.service
			exit 0
		fi
	@ done
