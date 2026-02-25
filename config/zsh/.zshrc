# Editor
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"

# History
export HISTFILE="$XDG_DATA_HOME/zsh/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
alias d="dirs -v | head -n 10"

# Completion
mkdir -p "$XDG_CACHE_HOME/zsh"
autoload -U compinit; compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"
_comp_options+=(globdots)

# Vim mode
bindkey -v
export KEYTIMEOUT=1
bindkey '^R' history-incremental-search-backward

# Aliases — navigation
alias ..="cd .."
alias ...="cd ../.."
alias l="ls"
alias la="ls -ltra"

# Aliases — editor
alias vi="nvim"
alias vim="nvim"
alias vizshrc="nvim $ZDOTDIR/.zshrc"
alias rlzshrc="source $ZDOTDIR/.zshrc"

# Aliases — git
alias gs="git status"
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gco="git checkout"
alias gl="git log"
alias glo="git log --pretty=oneline"
alias glol="git log --graph --oneline --decorate"

# PATH additions (add your own below)
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# zoxide (smarter cd)
eval "$(zoxide init zsh)"

# fnm (node version manager)
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

# opam (OCaml)
[[ -r "$HOME/.opam/opam-init/init.zsh" ]] && source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2>&1
