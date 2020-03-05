#!/bin/env zsh

# zgen
# no longer used in favor of zplug
source "${HOME}/.zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/colored-man-pages
    zgen oh-my-zsh plugins/docker
    zgen oh-my-zsh plugins/docker-compose
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/pyenv
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/rbenv
    zgen oh-my-zsh plugins/safe-paste
    zgen oh-my-zsh plugins/systemd
    zgen oh-my-zsh plugins/z
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-history-substring-search

    # bulk load
    zgen loadall <<EOPLUGINS
EOPLUGINS
    # ^ can't indent this EOPLUGINS ?

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen oh-my-zsh themes/clean

    # save all to init script
    zgen save
fi
