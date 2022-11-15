#!/bin/sh

sh "$HOME/.local/bin/init.sh"

exec ${1:-i3}
