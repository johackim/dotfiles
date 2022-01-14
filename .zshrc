export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="cyan"
plugins=(zsh-syntax-highlighting)

[ -f ~/.private_aliases ] && source ~/.private_aliases
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
source $HOME/.cache/wal/colors-tty.sh

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

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
