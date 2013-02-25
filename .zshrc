#oh-my-zsh
ZSH=$HOME/.oh-my-zsh
DEFAULT_USER="jake"
ZSH_THEME="clean"
# (random) clean miloshadzic takashiyoshida sporty_256 sorin robbyrussell nicoulaj
source $ZSH/oh-my-zsh.sh

#Aliases
alias caffeine="echo 'No Sleep For an HOUR!'; caffeinate -u -t 3600"
alias andsdk="~/Code/SDKs\ -\ Libraries/android-sdk/tools/android sdk"
alias deploy="~/Code/Web/Scripts/main_deploy.sh"
alias gob="go build"
alias bupdate='brew update && brew upgrade && brew cleanup'

# Suffix Aliases - open filetypes with program of choice
alias -s html=mvim
alias -s css=mvim
alias -s js=mvim
alias -s php=mvim
alias -s erb=mvim
alias -s c=mvim
alias -s cpp=mvim
alias -s go=mvim

# Plugins to load, loc in  ~/.oh-my-zsh/custom/plugins/ Ex: plugins=(rails git textmate ruby lighthouse)
plugins=(git vundle rbenv ruby rails rails3 brew encode64 osx)

# Miscellaneous functions
source $HOME/.zsh/.zsh_aliases

# if GVM installed
source $HOME/.gvm/scripts/gvm
# RBENV
eval "$(rbenv init -)"

#HOMEBREW and DRUSH
#DEF PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
export PATH=/usr/local/bin:$PATH:/usr/local/sbin
export PATH=$PATH:/Applications/MAMP/bin/php/php5.4.10/bin
