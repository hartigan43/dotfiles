#!/usr/bin/env bash

# Source global definitions
[ -f /etc/bashrc ] && . /etc/bashrc

# append to history file
shopt  -s histappend

# bash completion
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# Helper functions
# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# User specific aliases, exports, and functions
NEOVIM_BIN="$HOME/.bin/nvim.appimage"

set -o vi
force_color_prompt=yes

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
export LS_COLORS='ln=38;5;199:fi=38;5;222:di=38;5;4'
export PS1="\u:\[\e[34m\]\W\[\e[m\]\[\e[34m\]/\[\e[m\] \[\e[33m\]\`parse_git_branch\`\[\e[m\] \\$ "
export VISUAL=vim
export EDITOR=vim
export TERM="xterm-256color"
if [ $VIM ]; then
    export PS1='\h:\w› '
fi

# use local neovim on servers
if [ ! -f /usr/bin/nvim ] ; then
  alias vim=$NEOVIM_BIN
fi

function getNvim() {
  # precompiled binary for neovim
  curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod u+x nvim.appimage
  mv nvim.appimage ~/.bin
}

# allow local machine overrides
[ -f $HOME/.bash.local ] && source $HOME/.bash.local

# ssh-agent
# TODO figure out why its borked
[ -f ~/.ssh-agent.sh ] && source ~/.ssh-agent.sh

# load fzf if it exists
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# load z
[ -f ~/.dotfiles/z/z.sh ]  && source ~/.dotfiles/z/z.sh

# source aliases
[ -f $HOME/.aliases.sh ] && source $HOME/.aliases.sh
