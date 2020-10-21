.ONESHELL:
.SILENT:

CURRENT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install: check-root install-yay install-dotfiles install-packages

check-root:
	@ if [ $$(whoami) != "root" ]; then
		@ echo "Permission denied! You must execute the script as the 'root' user."
		@ exit 1
	@ fi

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

install-packages:
	@ pacman -Rsn --noconfirm vim
	@ yay --noconfirm --needed -S $$(cat ${CURRENT_DIR}/packages/1.txt)
	# @ yay --noconfirm --needed -S $$(cat ${CURRENT_DIR}/packages/2.txt)
	@ echo "Packages installation. Done."
