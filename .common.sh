#!/usr/bin/env bash

# create Workspace dir
if [ ! -d "$HOME/Workspace" ]; then
  mkdir "$HOME/Workspace"
fi

export WORKSPACE="$HOME/Workspace"

### helper funcs
# check for a command within your path
function command_exists() {
  command -v "$1" >/dev/null 2>&1;
}

# prepend to path
function prepend_to_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
      PATH="$1:${PATH:+"$PATH:"}"
  fi
}

# add to path
function add_to_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
      PATH="${PATH:+"$PATH:"}$1"
  fi
}

# somewhat janky mosh + ssh failover, requires two connections
#function ssh() {
#    if ! [ -x "$(command -v mosh)" ]; then
#        echo "mosh client not found, using ssh."
#        command ssh "$@"
#    else
#        echo "Trying mosh login."
#        command mosh "$@"
#        [[ $? -ne 0 ]] && (echo "mosh server not found" ; command ssh "$@")
#    fi
#}
###

### path updates for specific tools

add_to_path "$GOPATH/bin"
add_to_path "$HOME/.cargo/bin"

prepend_to_path "$HOME/.yarn/bin"
prepend_to_path "$HOME/.local/bin"

export PATH

if command_exists fuck ; then
  eval "$(thefuck --alias)"
fi

# asdf-vm
if [ -d "$HOME/.asdf" ] ; then
  . "$HOME/.asdf/asdf.sh"

  if [ -n "$BASH" ] ; then
    . "$HOME/.asdf/completions/asdf.bash"
  else
    # zsh -- append completions to fpath
    fpath=("${ASDF_DIR}"/completions $fpath)
    # initialise completions with ZSH's compinit
    autoload -Uz compinit && compinit
  fi
fi
###

# grab smug for tmux
if ! command_exists smug  ; then
  mkdir -p "$WORKSPACE/misc"
  cd "$WORKSPACE/misc" || exit
  git clone https://github.com/ivaaaan/smug.git
  cd smug || exit
  go install
fi

if command_exists nvim ; then
  alias vim='nvim'
fi

# use bat, or pygmentize for easier cat viewing
BAT=false
if command_exists bat ; then
  alias cat='bat'
  BAT=true
elif command_exists pygmentize ; then
  alias cat='pygmentize -g'
fi

if command_exists fzf ; then
  alias fvim='vim $(fzf --height 40%)'
  alias fzf="fzf --preview 'head -100 {}'"

  if [ "$BAT" = true ] ; then
    export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
    alias fzf="fzf --height 40% --border --preview 'bat --style=numbers --color=always {} | head -500'"
  fi

  if command_exists tree ; then
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
	fi
fi

if command_exists markdown-pdf ; then
  alias markdown-pdf='markdown-pdf -s $HOME/.dotfiles/modified-gfm.css'
fi

# have some fun
if command_exists cmatrix; then
  alias clear='[ $[$RANDOM % 10] = 0 ] && timeout 3 cmatrix; clear || clear'
fi

# aliases, functions
alias ls="ls --color=auto"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias l.="ls -d .*"
alias mxlookup="nslookup -q=mx"
alias tmux="tmux -2" # assume 256 color
alias weather="curl wttr.in"
alias dcb="sudo -- sh -c 'docker-compose pull && docker-compose stop && docker-compose build --no-cache && docker-compose up -d'"

#From alias.sh
alias gitog="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# SO 5828324 - git submodule recursive updates
alias gitsup="git submodule foreach git pull origin master"

#SO 113529 - emulate pbcopy
# cat filename.ext | alias to copy files, etc
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# cleanup multipart rars
alias rarcleanup='find ./ -regextype posix-egrep -iregex ".*\.r(ar|[0-9]*)$" -exec rm {} \;'
# unzip rars into their respective directories ignoring overwrites
alias batchunrar='find ./ -name "*.rar" -execdir unrar e -o- {} \;'

function randocommissian() {
  git commit -m"$(curl -s http://whatthecommit.com/index.txt)"
}

function mcd() {
  mkdir -p "$1" && cd "$1" || exit;
}

#alias.sh
function extract () {
    if [ -f "$1" ] ; then
      case $1 in
        *.tar.bz2)   tar xjf "$1"     ;;
        *.tar.gz)    tar xzf "$1"     ;;
        *.bz2)       bunzip2 "$1"     ;;
        *.rar)       unrar e "$1"     ;;
        *.gz)        gunzip "$1"      ;;
        *.tar)       tar xf "$1"      ;;
        *.tbz2)      tar xjf "$1"     ;;
        *.tgz)       tar xzf "$1"     ;;
        *.zip)       unzip "$1"       ;;
        *.Z)         uncompress "$1"  ;;
        *.7z)        7z x "$1"        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

function undozip(){
  unzip -l "$1" |  awk 'BEGIN { OFS="" ; ORS="" } ; { for ( i=4; i<NF; i++ ) print $i " "; print $NF "\n" }' | xargs -I{} rm -r {}
}

function rainymood() {
  FILE=$((RANDOM%4))
  URL="https://rainymood.com/audio1110/${FILE}.ogg"
  mpv ${URL} && rainymood
}
