export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="cyan"
plugins=(zsh-syntax-highlighting)

[ -f ~/.private_aliases ] && source ~/.private_aliases
[ -f ~/.cache/wal/colors-tty.sh ] && source $HOME/.cache/wal/colors-tty.sh
[ -f /opt/asdf-vm/asdf.sh ] && source /opt/asdf-vm/asdf.sh
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases

export GOPATH="$HOME/dev/gocode/"
export PATH=$PATH:$HOME/bin:/usr/local/bin:$GOPATH/bin:$HOME/.local/share/gem/ruby/3.0.0/bin:$HOME/.local/bin

export EDITOR=nvim
export WINEARCH=win32
export WINEPREFIX=~/.wine32
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

export ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=cyan'
export ZSH_HIGHLIGHT_STYLES[path]='none'
export ZSH_HIGHLIGHT_STYLES[arg0]='none'
export ZSH_HIGHLIGHT_STYLES[precommand]='none'

eval `dircolors ~/.dir_colors`
