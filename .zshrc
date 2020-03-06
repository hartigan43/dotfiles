#!/usr/bin/env zsh

# zplug - https://github.com/zplug/zplug
export ZPLUG_HOME="$HOME/.zplug"

if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

source ~/.zplug/init.zsh

zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/pyenv", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/rbenv", from:oh-my-zsh
zplug "plugins/safe-paste", from:oh-my-zsh
zplug "plugins/systemd", from:oh-my-zsh
zplug "plugins/themes", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug 'zplug/zplug', hook-build:'zplug --self-manage' #self managed zplug sometimes slow/hangs?

zplug "themes/clean", from:oh-my-zsh, as:theme

if ! zplug check; then
  zplug install
fi

zplug load --verbose #end zplug

# platform detection
unamestr=$(uname)

if [[ $unamestr == 'Linux' ]]; then

  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_CACHE_HOME="$HOME/.cache"
  export XDG_DATA_HOME="$HOME/.local/share"
  if [[ -d /usr/local/bin ]]; then
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:/usr/local/bin"
  fi

elif [[ $unamestr == 'Darwin' ]]; then
  #homebrew/nix here if I'm ever back on the mac train
fi

# user and default editor
# override locally with .zsh.lcal
DEFAULT_USER="hartigan"
export EDITOR=$(command -v vim)
export VISUAL=$(command -v vim)
export HISTORY_CONTROL="HIST_IGNORE_DUPES:HIST_EXPIRE_DUPES_FIRST"

# TERM value and tmux auto start
export TERM="tmux-256color" #now uses true color
if [ "$TMUX" = "" ]; then tmux; fi

# vi mode with backspace
bindkey -v
bindkey "^?" backward-delete-char #allow backspace to delete behind cursor
bindkey "^A" vi-beginning-of-line #restore ctrl-a to go to beginning while using vim mode in zsh

# allow local machine overrides
[ -f ~/.zsh.local ] && source ~/.zsh.local

# load fzf if it exists
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# source aliases
[ -f ~/.aliases.sh ] && source ~/.aliases.sh
