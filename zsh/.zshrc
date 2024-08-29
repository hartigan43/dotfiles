#!/usr/bin/env zsh
# TODO move .bashrc.local and .zshrc.local into sh.local

#################
# zcomet config #
#################
# clone zcomet if doesnt exist
if [[ ! -f "${ZDOTDIR:-${HOME}}"/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git "${ZDOTDIR:-${HOME}}"/.zcomet/bin
fi

source "${ZDOTDIR:-${HOME}}"/.zcomet/bin/zcomet.zsh

zcomet load ohmyzsh plugins/gitfast
zcomet load ohmyzsh plugins/safe-paste

# lazy load the archive from prezto without full library
zcomet trigger --no-submodules archive unarchive lsarchive \
    sorin-ionescu/prezto modules/archive

# It is good to load these popular plugins last, and in this order:
zcomet load zsh-users/zsh-completions
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions
zcomet load zsh-users/zsh-history-substring-search
#################

#################
# check session #
#################

if [[ -n "${SSH_CLIENT}" ]] || [[ -n "${SSH_TTY}" ]]; then
  REMOTE_SESSION=true
else
  # TODO why was */sshd included
  case $(ps -o comm= -p "${PPID}") in
    sshd|mosh-server|mosh)
      REMOTE_SESSION=true
      ;;
  esac
fi

#################
# prompt config #
#################
if [[ $UID == 0 ]]; then NCOLOR="red"; else NCOLOR="white"; fi

autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
# Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr   ' +'
# Set the format of the Git information for vcs_info
zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# use psvar for dynamic prompt generation
# V will check the element of the psvar array to see it exists and non-empty
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Conditional-Substrings-in-Prompts
# psvar[1]=REMOTE_SESSION, [2]=tf_prompt_info
psvar+=([1]="${REMOTE_SESSION}")
PROMPT='%1(V.%n%F{5}@%m:%B%F{4}%1~/%f%b.%n:%B%F{4}%1~/%f%b) %F{11}${vcs_info_msg_0_}%f\$ '
RPROMPT='[%*]'

# LS colors, made with https://geoff.greer.fm/lscolors/
# taken from old ohmyzsh theme clean
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'
#################

######################
# platform detection #
######################
unamestr=$(uname)

if [[ "${unamestr}" == 'Linux' ]]; then
  export XDG_CONFIG_HOME="${HOME}/.config"
  export XDG_CACHE_HOME="${HOME}/.cache"
  export XDG_DATA_HOME="${HOME}/.local/share"
  export XDG_DATA_DIRS="/usr/share:/usr/local/share"
  if [[ -d /usr/local/bin ]]; then
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:/usr/local/bin"
  fi
elif [[ "${unamestr}" == 'Darwin' ]]; then
  if [[ $(uname -m) == 'arm64' ]]; then
    # Apple Silicon Brew settings
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
  fi

  # homebrew completions
  if type brew &>/dev/null
    then
      FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    fi
fi

######################

# user and default editor and history
# override locally with .zsh.local
DEFAULT_USER="hartigan"
# check for nvim and default to vim
export EDITOR="${$(command -v nvim):-$(command -v vim)}" # TODO move to common?
export VISUAL=code
export DIFFPROG="${EDITOR} -d" #vim and nvim use -d for diffmode
export HISTFILE="${HOME}/.config/zsh/.zsh_history"
if [[ -f "${HISTFILE}" ]]; then
  touch "$HISTFILE"
fi
export HISTSIZE=10000
export SAVEHIST=10000
# TODO investigate why below stopped working
#export HISTORY_CONTROL="HIST_IGNORE_DUPS:HIST_EXPIRE_DUPS_FIRST:INC_APPEND_HISTORY:EXTENDED_HISTORY:SHARE_HISTORY"
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
##setopt SHARE_HISTORY

export TERM="xterm-256color"

# vi mode with backspace
bindkey -v
bindkey "^?" backward-delete-char #allow backspace to delete behind cursor
bindkey "^A" vi-beginning-of-line #restore ctrl-a to go to beginning while using vim mode in zsh
bindkey '^R' history-incremental-search-backward # reverse histroy search

# ssh-agent
# TODO figure out why its borked
# [ -f ~/.ssh-agent.sh ] && source ~/.ssh-agent.sh
#eval $(keychain --eval --quiet id_rsa ~/.ssh/id_rsa)
#eval $(keychain --eval --quiet id_rsa ~/.ssh/hartigan)

# load fzf if it exists
# install and ran with mise - 20240819 currently broken asdf-fzf installer
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh && export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# source common
[[ -f ~/.common.sh ]] && source ~/.common.sh

# allow local machine overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

#################
#  completions  #
#################
[[ -d ~/.config/zsh/completions ]] && fpath=(~/.config/zsh/completions $fpath)

zcomet compinit
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C $(which "$tf_cmd") terraform
