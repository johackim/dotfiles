HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history share_history hist_ignore_dups hist_ignore_space hist_verify
setopt auto_cd interactive_comments no_flow_control

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''

bindkey -e
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1~' beginning-of-line
bindkey '^[[7~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[8~' end-of-line
bindkey '^[[3~' delete-char

setopt prompt_subst
git_prompt_info() {
  local ref=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  [[ -n $ref ]] || return
  [[ -n $(git status --porcelain --ignore-submodules=dirty 2>/dev/null) ]] && ref+=" %F{yellow}✗"
  print -rn -- "(%B%F{green}$ref%f%b)"
}
PROMPT='[%F{cyan}%D{%H:%M:%S}%f] [%B%F{black}%n%f%b@%B%F{white}%m%f%b %F{cyan}%c%f $(git_prompt_info)]$ '

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[arg0]='none'
ZSH_HIGHLIGHT_STYLES[precommand]='none'
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
