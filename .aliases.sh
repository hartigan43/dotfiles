#!/usr/bin/env bash

# aliases, functions, and path modifications
alias ls="ls --color=auto"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias l.="ls -d .*"
alias mxlookup="nslookup -q=mx"
alias sudo="nocorrect sudo"
alias tmux="tmux -2" # assume 256 color
alias psmem="ps auxf | sort -nr -k 4 | head -10" #top 10 process eating memory
alias pscpu="ps auxf | sort -nr -k 3 | head -10" #top 10 processes eating cpu
alias weather="curl wttr.in"

#From alias.sh
alias gitog="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias memhog="ps -o time,ppid,pid,nice,pcpu,pmem,user,comm -A | sort -n -k 6 | tail -15"
alias aperr="sudo tail -f /var/log/apache2/error.log"
alias apacc="sudo tail -f /var/log/apache2/access.log"

# SO 5828324 - git submodule recursive updates
alias gitsup="git submodule foreach git pull origin master"

#SO 113529 - emulate pbcopy
# cat filename.ext | alias to copy files, etc
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# check for a command within your path
function command_exists() {
  command -v $1 >/dev/null 2>&1;
}

# Go
if command_exists go ; then
  mkdir -p $HOME/Workspace/go
  export GOPATH="$HOME/Workspace/go"
  export PATH="$GOPATH/bin:$PATH"
fi
# yarn binaries
if command_exists yarn ; then
  mkdir -p $HOME/.yarn/bin
  export PATH="$PATH:$HOME/.yarn/bin"
fi

#pip binaries
if command_exists pip ; then
  export PATH="$PATH:$HOME/.local/bin"
fi

if command_exists cargo ; then
 export PATH="$PATH:$HOME/.cargo/bin"
fi

if command_exists fuck ; then
  eval $(thefuck --alias)
fi

if command_exists pyenv ; then
  if [ ! -z "$BASH" ] ; then #zsh configures pyenv via plugin
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
  fi

  export PYTHON_CONFIGURE_OPTS="--enable-shared"
  if [ -d "$HOME/.pyenv/plugins/pyenv-virtualenv" ]; then
    eval "$(pyenv virtualenv-init -)"
  else
    eval "$(pyenv init -)"
  fi
fi

if command_exists rbenv ; then
  if [ ! -z "$BASH" ] ; then #zsh configures rbenv via plugin
    export PATH="$HOME/.rbenv/bin:$PATH"
  fi

  eval "$(rbenv init -)"
fi

if command_exists nvim ; then
  alias vim='nvim'
fi

if command_exists fzf ; then
  alias fvim='vim $(fzf --height 40%)'
  alias fzf="fzf --preview 'head -100 {}"

  if command_exists bat ; then
    export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
    alias fzf="fzf --height 40% --border --preview 'bat --style=numbers --color=always {} | head -500'"
  fi

  if command_exists tree ; then
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
	fi
fi

# use bat, or pygmentize for easier cat viewing
if command_exists bat ; then
  alias cat='bat'
elif command_exists pygmentize ; then
  alias cat='pygmentize -g'
fi

if command_exists markdown-pdf ; then
  alias markdown-pdf='markdown-pdf -s $HOME/.dotfiles/modified-gfm.css'
fi

# have some fun
if command_exists cmatrix; then
  alias clear='[ $[$RANDOM % 10] = 0 ] && timeout 3 cmatrix; clear || clear'
fi

function randocommissian() {
    git commit -m"`curl -s http://whatthecommit.com/index.txt`"
}

function mcd() {
  mkdir -p "$1" && cd "$1";
}

#set the tmux window title to the hostname
function settmuxtitle() {
  printf "\033k`hostname -s`\033\\"
}

#alias.sh
function extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
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
