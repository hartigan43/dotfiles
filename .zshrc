# Big thanks to ohmyzsh https://github.com/robbyrussell/oh-my-zsh
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="nicoulaj"
# Solid themes
# (random) miloshadzic takashiyoshida sporty_256 sorin robbyrussell nicoulaj

# Aliases
alias ll="ls -l"
alias la="ls -a"
alias gob="go build"

# Suffix Aliases - open filetypes with program of choice
alias -s html=gvim
alias -s css=gvim
alias -s js=gvim
alias -s php=gvim
alias -s erb=gvim
alias -s c=gvim
alias -s cpp=gvim
alias -s go=gvim
# ZSH TRICKS
# CASE_SENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# COMPLETION_WAITING_DOTS="true"

# Plugins to load, loc in  ~/.oh-my-zsh/custom/plugins/ Ex: plugins=(rails git textmate ruby lighthouse)
plugins=(git vundle rbenv ruby rails brew encode64 osx)

source $ZSH/oh-my-zsh.sh

export PATH=$PATH:/usr/local/go/bin
