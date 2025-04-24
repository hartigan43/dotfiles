# this script shell-agnostic and intended to be sourced, not executed directly

# load required helper scripts
source "${HOME}"/.dotfiles/helper_scripts/command_exists.sh

# create Workspace dir and export
if [ ! -d "${HOME}"/Workspace ]; then
  mkdir "${HOME}"/Workspace
fi

# check for bash
# TODO tempalte file with dotter and split bash / zsh completely
if [ -n "${BASH}" ] ; then
  IS_BASH=true
fi

# check and set unamestr if it was somehow unset in bashrc/zshrc
unamestr="${unamestr:-$(uname)}"

# use XDG_DATA_HOME or equivalent path for macOS compatibility
export CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
# check for nvim and default to vim
nvim="$(command -v nvim)"
vim="$(command -v vim)"
zed="$(command -v zeditor)"
export EDITOR="${nvim:-$vim}"
export VISUAL="${zed}" # TODO, some kind of sane check for installed editor
export DIFFPROG="${delta:-${EDITOR} -d}" # vim and nvim use -d for diffmode
export LESSHISTFILE="${STATE_HOME}"/less/history
export TAPLO_CONFIG="${XDG_CONFIG_HOME:=$HOME/.config}"/taplo/taplo.toml # TODO template if taplo installed
export WORKSPACE="${HOME}"/Workspace
export WINEPREFIX="{$DATA_HOME}"/wine

### functions
# add to path
add_to_path () {
  if [ -d "$1" ] && [[ ":${PATH}:" != *":$1:"* ]]; then
      PATH="${PATH:+$PATH:}$1"
  fi
}

# tmux auto start/attach, only if installed and set to start by env
# variable, https://wiki.archlinux.org/index.php/Tmux
check_tmux () {
  if [ "${TMUX_AUTO_START}" = "true" ] ; then
    if which tmuxp >/dev/null 2>&1; then
      test -z "${TMUX}" && tmuxp load "$HOME"/.config/tmuxp/main.json

    elif which tmux >/dev/null 2>&1; then
        # if no session is started, start a new session
        test -z "${TMUX}" && tmux

        # when quitting tmux, try to attach
        while test -z "${TMUX}"; do
            tmux attach || break
        done
    fi
  fi
}

# determine if opentofu or terraform are in use
check_tf () {
  if command_exists tofu ; then
    tf_cmd='tofu'
  else
    tf_cmd='terraform'
  fi
}

# alias.sh
extract () {
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

# git commit -am "commit message"
gcam () {
  git commit -am "$1"
}

# git clone && cd ${cloned-dir}
gcd () {
  git clone "$1" && cd "$(basename "$1" .git)" || return 1
}

# git pull --rebase for current branch
gpur () {
  echo "Pulling and rebasing the current branch..."
  git pull --rebase origin "$(git branch --show-current)"
}

# git pull origin --rebase on top of main/master
gpurm() {
  echo "Pulling and rebasing on top of the main branch..."
  # Check if 'main' branch exists, otherwise use 'master'
  if git show-ref --verify --quiet refs/heads/main; then
    git pull --rebase origin main
  else
    git pull --rebase origin master
  fi
}

# push to the current branch if no branch specified
# git push $1/origin $2/current branch
gpush () {
  REMOTE="${1:-origin}"
  BRANCH="${2:-$(git branch --show-current)}"
  echo "Pushing to ${REMOTE} ${BRANCH}..."
  git push "${REMOTE}" "${BRANCH}"
}

# flatten multiple kube configs into one yaml file, useful for go version of kubectx
#   kube_dir - path to config directory
#   prefix   - filename prefix for combining kubeconfigs
#   ignored  - any files to ignore that match the prefix
kflatten() {
  local kube_dir="${1:-$HOME/.kube}"
  local prefix="${2:-kube-}"
  local ignored="${3:-}"

  # Use find to get the list of files matching the pattern
  local files
  files=$(find "${kube_dir}" -maxdepth 1 -type f -name "${prefix}*" ! -name "${ignored}")

  if [ -n "${files}" ]; then
    # Use tr to replace spaces with colons
    local kubeconfig
    kubeconfig="$(echo "$files" | tr '\n' ':')"
    KUBECONFIG="${kubeconfig}" kubectl config view --merge --flatten > "${kube_dir}"/all.yaml
  else
    echo "No matching files found in ${kube_dir} with prefix '${prefix}' (ignored: '${ignored}')"
  fi
}

# mkdir with path and cd to it
mcd () {
  mkdir -p "$1" && cd "$1" || exit;
}

# prepend to path, thanks tommyvyo
prepend_to_path () {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
      PATH="$1${PATH:+":$PATH"}"
  fi
}

# jam out
rainymood () {
  if command_exists mpv ; then
    FILE="$((RANDOM%4))"
    URL="https://rainymood.com/audio1110/${FILE}.ogg"
    mpv "${URL}" && rainymood
  else
    echo "Please install mpv to use rainymood function"
  fi
}

randocommissian () {
  git commit -m "$(curl -s http://whatthecommit.com/index.txt)"
}

sanitize_path () {
  PATH=$(echo "${PATH}" | tr -s ':' | sed 's/:$//')
}

# https://github.com/mrusme/dotfiles/blob/dbb63bc1401f9752209296b019f8b362b42c1012/.zshrc#L358
ssh () {
  if [ "$2" = "" ]; then
    conn="$1"
    sshhost=$(printf "%s" "${conn}" | cut -d '@' -f2)
    if rg -U -i "^#.*Features:.*mosh.*\nHost ${sshhost}" "${HOME}/.ssh/config" > /dev/null; then
      if command_exists mosh ; then
        printf "connecting with mosh ...\n"
        command mosh "${conn}"
      fi
    else
      printf "connecting with ssh ...\n"
      command ssh "${conn}"
    fi
  else
    printf "connecting with ssh ...\n"
    command ssh "$@"
  fi
}

# displays terraform workspace information
tf_prompt_info () {
  psvar+=([2]="")
  [[ "$PWD" == ~ ]] && return
  if [ -d .terraform ]; then
    workspace=$("${tf_cmd}" workspace show 2> /dev/null) || return
    psvar=([2]=${workspace})
  fi
}

# update tooling - vim plugins, zcomet, fzf, and asdf. etc. bbq
tup () {
  CURRDIR=$(pwd)
  mise self-update -y && mise upgrade
  vim +PlugUpdate +qall +PlugUpgrade -c "call denops#cache#update(#{reload: v:true})" +qall && \
    deno cache --reload "/home/hartigan/.vim/plugged/ddc-around/denops/@ddc-sources/around.ts"
  zcomet update && zcomet self-update
  # TODO see about passing flag to asdf-fzf for mise to support install --xdg
  cd "${DATA_HOME}"/fzf && git pull &&
  {
    echo y # enable completion
    echo y # enable keybindings
    echo n #update config files
  } | ./install --xdg
  rustup update
  cd "${CURRDIR}" || return
  echo "Refreshing the shell with exec ${SHELL}"
  exec "${SHELL}"
}

undozip (){
  unzip -l "$1" |  awk 'BEGIN { OFS="" ; ORS="" } ; { for ( i=4; i<NF; i++ ) print $i " "; print $NF "\n" }' | xargs -I{} rm -r {}
}

#yay() {
#  echo "Checking for news with yay -Pw..."
#  command yay -Pw | grep -q . && exit
#  PATH=$(getconf PATH) mullvad-exclude yay "$@"
#}

### end functions

### path updates and tooling
# use bat, or pygmentize for easier cat viewing
BAT="false"
if command_exists bat ; then
  alias cat='bat'
  BAT="true"
  export BAT_THEME=ansi
elif command_exists pygmentize ; then
  alias cat='pygmentize -g'
fi

# fzf
if command_exists fzf ; then
  alias fvim='vim $(fzf --height 40%)'

  export FZF_CTRL_R_OPTS="
    --preview 'echo {}' --preview-window up:3:hidden:wrap
    --bind 'ctrl-/:toggle-preview'
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --color header:italic
    --header 'Press CTRL-Y to copy command into clipboard'
  "

  if [ "$BAT" = "true" ] ; then
    export FZF_CTRL_T_OPTS="
      --preview 'bat -n --color=always {}'
      --bind 'ctrl-/:change-preview-window(down|hidden|)'
    "
  fi

  if command_exists tree ; then
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
	fi

  # TODO SET AND SOURCE DEFAULTS WITHOUT ANY COMMANDS
  # https://github.com/junegunn/fzf?tab=readme-ov-file#environment-variables for more info
  if command_exists fd ; then
    export FZF_DEFAULT_COMMAND="fd --type f"
    export FZF_ALT_C_COMMAND="fd --type d --follow"
  fi

  # fkill - kill processes - list only the ones you can kill
  # TODO replace with kill -9 ** ?
  fkill() {
      local pid
      if [ "${UID}" != "0" ]; then
          pid=$(ps -f -u "${UID}" | sed 1d | fzf -m | awk '{print $2}')
      else
          pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
      fi

      if [ "x${pid}" != "x" ]
      then
          echo "${pid}" | xargs kill -"${1:-9}"
      fi
  }
fi

# go
if command_exists go ; then
  export GOPATH="${DATA_HOME}/go"
  add_to_path "${GOPATH}/bin"
fi

prepend_to_path "${HOME}"/.yarn/bin
prepend_to_path "${HOME}"/.local/bin

# mise
if [ ! -f "${HOME}"/.local/bin/mise ] ; then
  source "${HOME}"/.dotfiles/helper_scripts/mise_install.sh && mise_install
else
  if [ "$IS_BASH" = true ] ; then
    eval "$(~/.local/bin/mise activate bash)"
    eval "$(mise hook-env -s bash)"
  else
    # zsh
    eval "$(~/.local/bin/mise activate zsh)"
    eval "$(mise hook-env -s zsh)"
  fi
  # mise shims, can also use `mise activate --shims` to enable on demand
  # prepend_to_path "$HOME/.local/share/mise/shims:$PATH"
fi

# rust - rustup / cargo
# TODO add installer in helpder?
export RUSTUP_HOME="${DATA_HOME}"/rust/rustup
export CARGO_HOME="${DATA_HOME}"/rust/cargo

if [ -f "${CARGO_HOME}"/env ]; then
  source "${CARGO_HOME}"/env
else
  prepend_to_path "${CARGO_HOME}"/bin
fi

if command_exists nvim ; then
  alias vim='nvim'
fi

# ripgrep
if command_exists rg ; then
  export RIPGREP_CONFIG_PATH="${HOME}"/.config/ripgrep/ripgreprc
fi

# zoxide
if [ "$IS_BASH" = true ] ; then
  eval "$(zoxide init bash)"
else
  eval "$(zoxide init zsh)"
fi
### end tooling

### aliases
# https://www.shellcheck.net/wiki/SC2139 - aliases should use single quotes to prevent confusion
alias d='docker'
alias dcb='sudo -- sh -c "docker-compose pull && docker-compose down && docker-compose build --no-cache && docker-compose up -d"'
alias dcu='sudo -- sh -c "docker-compose pull && docker-compose down && docker-compose up -d"'
alias docker='podman'
alias gitog='git log --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gitroot='cd $(git rev-parse --show-toplevel)'
alias gitstat='git status -s -b --show-stash'
alias gitsup='git submodule foreach git pull origin master' # SO 5828324 - git submodule recursive updates
alias k='kubectl'
alias kcurr='kubectl config current-context'
alias kctx='kubectx'
alias kdesc='kubectl describe'
alias kedit='kubectl edit'
alias kexec='kubectl exec'
alias klogs='kubectl logs'
alias kns='kubens'
alias knodes='kubectl get nodes'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -lah'
alias ls='ls --color=auto'
alias lsn='ls --color=never'
alias me='mullvad-exclude'
alias mxlookup='nslookup -q=mx'
alias sudo='nocorrect sudo ' # A trailing space in VALUE causes the next word to be checked for alias substitution when the alias is expanded.
alias sdiff='sudo vimdiff'
alias tf='$tf_cmd'
alias tfplan='$tf_cmd plan -lock=false'
alias tfclean='rm -rf .terraform && $tf_cmd init'
alias tf-update-lockfile='$tf_cmd providers lock -platform=darwin_amd64 -platform=linux_amd64 -platform=darwin_arm64'
alias tmux='tmux -2' # assume 256 color
alias weather='curl wttr.in'
# alias yay='PATH=$(getconf PATH) yay -Pw && mullvad-exclude yay' # have yay build aur apps with system libraries
alias v='vim'

#SO 113529 - emulate pbcopy x11 only
if [[ "${unamestr}" != 'Darwin' && "${XDG_SESSION_TYPE}" != 'wayland' ]]; then
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
fi

if command_exists markdown-pdf ; then
  alias markdown-pdf='markdown-pdf -s "${HOME}"/.dotfiles/misc/modified-gfm.css'
fi

# have some fun
if command_exists cmatrix; then
  alias clear='[ $[$RANDOM % 10] = 0 ] && timeout 3 cmatrix; clear || clear'
fi

### end aliases

# check tf command and add tf workspace info to prompt
if [[ -z "${tf_cmd}" ]]; then
  check_tf
fi
# TODO bash uses PROMPT_COMMAND
precmd_functions+=(tf_prompt_info)
PROMPT="${PROMPT:0:${#PROMPT}-5}%2(V.%F{13}[tf:%2v].)%f $ "
