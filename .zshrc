#!/usr/bin/env zsh
# todo shell [ vs [[ cleanup

# clone zcomet if doesnt exist
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh
echo "done zcomet"
zcomet load agkozak/zsh-z
zcomet load ohmyzsh themes/clean

zcomet load ohmyzsh plugins/command-not-found
zcomet load ohmyzsh plugins/docker
zcomet load ohmyzsh plugins/docker-compose
zcomet load ohmyzsh plugins/gitfast
zcomet load ohmyzsh plugins safe-paste
zcomet load ohmyzsh plugins/systemd

# lazy load the archive from prezto without full library
zcomet trigger --no-submodules archive unarchive lsarchive \
    sorin-ionescu/prezto modules/archive

# It is good to load these popular plugins last, and in this order:
zcomet load zsh-users/zsh-completions
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions

zcomet load zsh-users/zsh-history-substring-search
zcomet compinit

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
# letting smug start it for now
#if which smug >/dev/null 2>&1; then
#  test -z ${TMUX} && smug start ru-main
#
#elif which tmux >/dev/null 2>&1; then
#    # if no session is started, start a new session
#    test -z ${TMUX} && tmux
#
#    # when quitting tmux, try to attach
#    while test -z ${TMUX}; do
#        tmux attach || break
#    done
#fi

# vi mode with backspace
bindkey -v
bindkey "^?" backward-delete-char #allow backspace to delete behind cursor
bindkey "^A" vi-beginning-of-line #restore ctrl-a to go to beginning while using vim mode in zsh

# ssh-agent
# TODO figure out why its borked
# [ -f ~/.ssh-agent.sh ] && source ~/.ssh-agent.sh
#eval $(keychain --eval --quiet id_rsa ~/.ssh/id_rsa)
#eval $(keychain --eval --quiet id_rsa ~/.ssh/hartigan)

alias sudo="nocorrect sudo"

# load fzf if it exists
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# source common
[ -f ~/.common.sh ] && source ~/.common.sh

# allow local machine overrides
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
