.ONESHELL:
.SILENT:
CURRENT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install: install-dotfiles install-packages

install-dotfiles:
	@ pacman -Qq | grep -qw python || sudo pacman -Sy --noconfirm python
	@ pacman -Qq | grep -qw cmake || sudo pacman -Sy --noconfirm cmake
	@ git submodule update --init --recursive
	@ ${CURRENT_DIR}/dotbot/bin/dotbot -d ${CURRENT_DIR} -c install.conf.yaml
	@ echo "Dotfiles installation. Done."

install-packages:
	@ yay --noconfirm --needed -S $$(cat ${CURRENT_DIR}/packages.txt)
