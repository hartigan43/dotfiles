#!/usr/bin/env zsh

# todo shell [ vs [[ cleanup
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
#zplug "plugins/pyenv", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
#zplug "plugins/rbenv", from:oh-my-zsh
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
# TODO move platform and defaults to separate include for bash/zsh
unamestr=$(uname)

if [[ $unamestr == 'Linux' ]]; then

  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_CACHE_HOME="$HOME/.cache"
  export XDG_DATA_HOME="$HOME/.local/share"
  export XDG_DATA_DIRS="/usr/share:/usr/local/share"
  if [[ -d /usr/local/bin ]]; then
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:/usr/local/bin"
  fi

elif [[ $unamestr == 'Darwin' ]]; then
  #homebrew/nix here if I'm ever back on the mac train
fi

# user and default editor and history
# override locally with .zsh.local
DEFAULT_USER="hartigan"
export EDITOR=$(command -v vim)
export VISUAL=$(command -v vim)
export HISTFILE="$HOME/.zsh_history"
if [[ -f $HISTFILE ]]; then
  touch $HISTFILE
fi
export HISTSIZE=10000
export SAVEHIST=10000
#stopped working for some reason
#export HISTORY_CONTROL="HIST_IGNORE_DUPS:HIST_EXPIRE_DUPS_FIRST:INC_APPEND_HISTORY:EXTENDED_HISTORY:SHARE_HISTORY"
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
##setopt SHARE_HISTORY

#TERM value and tmux auto start/attach, only if installed, https://wiki.archlinux.org/index.php/Tmux
export TERM="screen-256color" #now uses true color, use tmux-256color if issues
if which smug >/dev/null 2>&1; then
  test -z ${TMUX} && smug start main

elif which tmux >/dev/null 2>&1; then
    # if no session is started, start a new session
    test -z ${TMUX} && tmux

    # when quitting tmux, try to attach
    while test -z ${TMUX}; do
        tmux attach || break
    done
fi

# vi mode with backspace
bindkey -v
bindkey "^?" backward-delete-char #allow backspace to delete behind cursor
bindkey "^A" vi-beginning-of-line #restore ctrl-a to go to beginning while using vim mode in zsh

# ssh-agent
# TODO figure out why its borked
# [ -f ~/.ssh-agent.sh ] && source ~/.ssh-agent.sh
#eval $(keychain --eval --quiet id_rsa ~/.ssh/id_rsa)
#eval $(keychain --eval --quiet id_rsa ~/.ssh/hartigan)

# load fzf if it exists
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# source common
[ -f ~/.common.sh ] && source ~/.common.sh

# allow local machine overrides
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
