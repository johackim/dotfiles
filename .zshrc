export ZSH_THEME="cyan"
export DISABLE_AUTO_UPDATE=true
export plugins=(zsh-syntax-highlighting)

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.private_aliases ] && source ~/.private_aliases
[ -f ~/.oh-my-zsh/oh-my-zsh.sh ] && source ~/.oh-my-zsh/oh-my-zsh.sh
[ -f ~/.cache/wal/colors-tty.sh ] && source ~/.cache/wal/colors-tty.sh

export GOPATH=$HOME/.golang
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/var/lib/snapd/snap/bin/
export PATH=$PATH:$HOME/.local/bin:/usr/local/bin
export PATH=$PATH:$HOME/.local/share/gem/ruby/3.4.0/bin

export ASDF_DATA_DIR=$HOME/.asdf
export PATH=$PATH:$ASDF_DATA_DIR/shims

export GPG_TTY=tty
export EDITOR=nvim
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

export ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=cyan'
export ZSH_HIGHLIGHT_STYLES[path]='none'
export ZSH_HIGHLIGHT_STYLES[arg0]='none'
export ZSH_HIGHLIGHT_STYLES[precommand]='none'

eval `dircolors ~/.dir_colors`
