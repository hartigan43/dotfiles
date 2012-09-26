# Big thanks to ohmyzsh https://github.com/robbyrussell/oh-my-zsh
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="nicoulaj"
# Solid themes
# (random) miloshadzic takashiyoshida sporty_256 sorin robbyrussell nicoulaj

# Aliases
alias caffeine="echo 'No Sleep For an HOUR!'; caffeinate -u -t 3600"
alias ll="ls -l"
alias la="ls -a"

# Suffix Aliases - open filetypes with program of choice
alias -s html=mvim
alias -s css=mvim
alias -s js=mvim
alias -s php=mvim
alias -s erb=mvim
alias -s c=mvim
alias -s cpp=mvim

# ZSH TRICKS
# CASE_SENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_LS_COLORS="true"
# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"
# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Plugins to load, loc in  ~/.oh-my-zsh/custom/plugins/ Ex: plugins=(rails git textmate ruby lighthouse)
plugins=(git vundle rbenv ruby rails brew encode64 osx)

source $ZSH/oh-my-zsh.sh

# Default PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
# HOMEBREW
export PATH=/usr/local/bin:$PATH:/usr/local/sbin
