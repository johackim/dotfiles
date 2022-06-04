#!/bin/sh

sh "$HOME/.dotfiles/bin/init.sh"

exec ${1:-i3}
