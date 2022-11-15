ZSH_THEME="cyan"
plugins=(zsh-syntax-highlighting)

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.private_aliases ] && source ~/.private_aliases
[ -f ~/.cache/wal/colors-tty.sh ] && source ~/.cache/wal/colors-tty.sh
[ -f ~/.oh-my-zsh/oh-my-zsh.sh ] && source ~/.oh-my-zsh/oh-my-zsh.sh
[ -f /opt/asdf-vm/asdf.sh ] && source /opt/asdf-vm/asdf.sh

export GOPATH="$HOME/.go"
export PATH=$PATH:$HOME/.local/bin:/usr/local/bin:$GOPATH/bin:$HOME/.local/share/gem/ruby/3.0.0/bin

export EDITOR=nvim
export WINEARCH=win32
export WINEPREFIX=~/.wine32
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

export ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=cyan'
export ZSH_HIGHLIGHT_STYLES[path]='none'
export ZSH_HIGHLIGHT_STYLES[arg0]='none'
export ZSH_HIGHLIGHT_STYLES[precommand]='none'

eval `dircolors ~/.dir_colors`
