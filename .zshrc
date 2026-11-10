source ~/.config/zsh/oh-my.zsh
source ~/.config/zsh/ls-colors.zsh

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.private_aliases ] && source ~/.private_aliases
[ -f ~/.cache/wal/colors-tty.sh ] && source ~/.cache/wal/colors-tty.sh

typeset -U path PATH

export GOPATH=$HOME/.golang
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.local/bin

export ASDF_DATA_DIR=$HOME/.asdf
export PATH=$PATH:$ASDF_DATA_DIR/shims

export GPG_TTY=$(tty)
export EDITOR=nvim
