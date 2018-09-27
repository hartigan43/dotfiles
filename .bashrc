# .bashrc

# Source global definitions
#if [ -f /etc/bashrc ]; then
# . /etc/bashrc
#fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

NEOVIM_BIN="$HOME/.bin/nvim.appimage"

set -o vi
force_color_prompt=yes

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
export LS_COLORS='ln=38;5;199:fi=38;5;222:di=38;5;4'
export PS1='\h\e[38;5;200m:\e[39m\w\n\u \e[38;5;200m›\e[0m '
export VISUAL=vim
export EDITOR=vim
export TERM="screen-256color"
if [ $VIM ]; then
    export PS1='\h:\w› '
fi

alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias vi="vim"
alias vim=$NEOVIM_BIN

function getNvim() {
  # precompiled binary for neovim
  curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod u+x nvim.appimage
  mv nvim.appimage ~/.bin
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
