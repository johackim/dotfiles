#!/bin/sh

sh "$HOME/.local/bin/init.sh"

exec ${2:-i3}
