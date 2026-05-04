# this script shell-agnostic and intended to be sourced, not executed directly

# load required helper scripts
source "${HOME}/.dotfiles/helper_scripts/command_exists.sh"

# TODO
# use builtin dotter.VAR https://github.com/SuperCuber/dotter/wiki/5.-Built%E2%80%90ins,-Helpers,-and-Settings#variables
# use include_template https://github.com/SuperCuber/dotter/wiki/5.-Built%E2%80%90ins,-Helpers,-and-Settings
# better define os check

# check and set unamestr if it was somehow unset in bashrc/zshrc
unamestr="${unamestr:-$(uname)}"
# TODO replace after nvim/vim split
# check for nvim and default to vim
nvim="$(command -v nvim)"
vim="$(command -v vim)"
zed="$(command -v zeditor)"

# use XDG_DATA_HOME or equivalent path for macOS compatibility
export CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
{{#if (is_executable "atac")}}
export ATAC_KEY_BINDINGS="${HOME}/.config/atac/vim_key_bindings.toml"
{{/if}}
export EDITOR="${nvim:-$vim}"
export DIFFPROG="${delta:-${EDITOR} -d}" #vim and nvim use -d for diffmode
{{#if (is_executable "less")}}
export LESS="Ms" # s - squash duplicate blank lines; M Long-prompt: show line number and percentage
export LESSHISTFILE="$STATE_HOME"/less/history
{{/if}}
{{#if (is_executable "taplo")}}
export TAPLO_CONFIG="${XDG_CONFIG_HOME:=$HOME/.config}/taplo/taplo.toml" # TODO template if taplo installed
{{/if}}
export VISUAL=zeditor #TODO
{{#if (is_executable "wine")}}
export WINEPREFIX="{$DATA_HOME}"/wine
{{/if}}
export WORKSPACE="$HOME/Workspace"

# create Workspace dir and export
if [ ! -d "$WORKSPACE" ]; then
  mkdir "$WORKSPACE"
fi

### functions
# add to path
add_to_path () {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
      PATH="${PATH:+$PATH:}$1"
  fi
}

# tmux auto start/attach, only if installed and set to start by env
# variable, https://wiki.archlinux.org/index.php/Tmux
check_tmux () {
  if [ "$TMUX_AUTO_START" = "true" ] ; then
    if which tmuxp >/dev/null 2>&1; then
      test -z "${TMUX}" && tmuxp load "$HOME/.config/tmuxp/main.json"

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
gpush () {
  REMOTE="${1:-origin}"
  BRANCH="${2:-$(git branch --show-current)}"
  echo "Pushing to ${REMOTE} ${BRANCH}..."
  git push "$REMOTE" "$BRANCH"
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
  files=$(find "$kube_dir" -maxdepth 1 -type f -name "${prefix}*" ! -name "$ignored")

  if [ -n "$files" ]; then
    # Use tr to replace spaces with colons
    local kubeconfig
    kubeconfig=$(echo "$files" | tr '\n' ':')
    KUBECONFIG="$kubeconfig" kubectl config view --merge --flatten > "$kube_dir/all.yaml"
  else
    echo "No matching files found in $kube_dir with prefix '$prefix' (ignored: '$ignored')"
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
# TODO refactor into one function
# TODO backup mpv scripts
# NOTE: $(()) is bash arithmetic expansion

# coffeetivity
# https://audios.coffitivity.com/morning-murmur.mp3
# university-undertones.mp3

rainymood () {
  if command_exists mpv ; then
    FILE="$((RANDOM % 4))"
    URL="https://rainymood.com/audio1110/${FILE}.ogg"
    mpv "${URL}" && rainymood
  else
    echo "Please install mpv to use rainymood function."
  fi
}

rainwave () {
  if command_exists mpv ; then
    # Station 1 - game, 2 - ocremix, 3 - covers, 4 - chiptune, 5 - all, 6 - chill
    STATION="${1:-$(((RANDOM % 6) + 1))}"
    FORMAT="${2:-ogg}"
    URL="https://rainwave.cc/tune_in/${FILE}.${FORMAT}.m3u"
    mpv "${URL}"
  else
    echo "Please install mpv to use rainwave function."
  fi
}

soma () {
  if command_exists mpv ; then
    STATIONS=(
      "deepspaceone"
      "defcon"
      "fluid"
      "groovesalad"
      "indiepop"
      "lush"
      "secretagent"
      "specials"
      "sonicuniverse"
      "vaporwaves"
    )
    STATION="${1:-${STATIONS[ RANDOM % ${#STATIONS[@]}]}}"
    FORMAT="${2:-130}" # aac 128k
    URL="https://somafm.com/${STATION}${FORMAT}.pls"
    mpv "${URL}"
  else
    echo "Please install mpv to use rainwave function."
  fi
}

randocommissian () {
  git commit -m "$(curl -s http://whatthecommit.com/index.txt)"
}

sanitize_path () {
  PATH=$(echo "$PATH" | tr -s ':' | sed 's/:$//')
}

# https://github.com/mrusme/dotfiles/blob/dbb63bc1401f9752209296b019f8b362b42c1012/.zshrc#L358
ssh () {
  if [ "$2" = "" ]; then
    conn="$1"
    sshhost=$(printf "%s" "$conn" | cut -d '@' -f2)
    if rg -U -i "^#.*Features:.*mosh.*\nHost $sshhost" "$HOME/.ssh/config" > /dev/null; then
      if command_exists mosh ; then
        printf "connecting with mosh ...\n"
        command mosh "$conn"
      fi
    else
      printf "connecting with ssh ...\n"
      command ssh "$conn"
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
    workspace=$("$tf_cmd" workspace show 2> /dev/null) || return
    psvar=([2]=$workspace)
  fi
}

# update tooling - vim plugins, zcomet, fzf, and asdf. etc. bbq
tup () {
  CURRDIR=$(pwd)
  mise self-update -y && mise upgrade
  vim +PlugUpdate +qall +PlugUpgrade -c "call denops#cache#update(#{reload: v:true})" +qall
  # && \ deno cache --reload "/home/hartigan/.vim/plugged/ddc-around/denops/@ddc-sources/around.ts"
  zcomet update && zcomet self-update
  # TODO see about passing flag to asdf-fzf for mise to support install --xdg
  # TODO evaluate the use of fzf@latest with mise
  # cd "${DATA_HOME}/fzf" && git pull &&
  # {
  #   echo y # enable completion
  #   echo y # enable keybindings
  #   echo n #update config files
  # } | ./install --xdg
  cd "$CURRDIR" || return
  echo "Refreshing the shell with exec $SHELL"
  exec "$SHELL"
}

undozip (){
  unzip -l "$1" |  awk 'BEGIN { OFS="" ; ORS="" } ; { for ( i=4; i<NF; i++ ) print $i " "; print $NF "\n" }' | xargs -I{} rm -r {}
}

### end functions

### path updates and tooling
{{#if (is_executable "bat")}}
# use bat, or pygmentize for easier cat viewing
  alias cat='bat'
  export BAT_THEME=ansi
{{else}}
  {{#if (is_executable "pygmentize")}}
    alias cat='pygmentize -g'
  {{/if}}
{{/if}}

{{#if (is_executable "fzf")}}
# fzf
alias fvim='vim $(fzf --height 40%)'

{{{{raw}}}}
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'
"
{{{{/raw}}}}

{{#if (is_executable "bat")}}
{{{{raw}}}}
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"
{{{{/raw}}}}
{{/if}}

{{#if (is_executable "tree")}}
{{{{raw}}}}
if command_exists tree ; then
  export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi
{{{{/raw}}}}
{{/if}}


{{#if (is_executable "fd")}}
# TODO SET AND SOURCE FROM FILE - FZF_DEFAULT_OPTS_FILE
# https://github.com/junegunn/fzf?tab=readme-ov-file#environment-variables for more info
  export FZF_DEFAULT_COMMAND="fd --type f"
  export FZF_ALT_C_COMMAND="fd --type d --follow"
{{/if}}

# fkill - kill processes - list only the ones you can kill
# TODO replace with kill -9 ** ?
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo "$pid" | xargs kill -"${1:-9}"
    fi
}

_fzf_complete_git() {
  ARGS="$@"
  local branches
  branches=$(git branch -vv --all)
  if [[ $ARGS == 'git co'* ]] || [[ $ARGS == 'git checkout'* ]]; then
      _fzf_complete --reverse --multi -- "$@" < <(
          echo "${branches}"
      )
  else
      eval "zle ${fzf_default_completion:-expand-or-complete}"
  fi
}

_fzf_complete_git_post() {
  awk '{print $1}'
}

# https://medium.com/@dvieitest/enhance-your-terminal-workflow-with-fzf-custom-completions-cc0e462cc483
{{{{raw}}}}
_fzf_complete_podman() {
    ARGS="$@"
    if [[ "$ARGS" == "podman exec"* ]]; then
      _fzf_complete --preview 'podman container logs {1} | tail' -- "$@" < <(
        podman container ls --format "table {{ .ID }}\t{{ .Image }}\t{{ .Names }}" | awk 'NR>1 {print $0}'
      )
    fi
}
{{{{/raw}}}}

_fzf_complete_podman_post() {
  awk '{print $1}'
}
{{/if}}

{{#if (is_executable "go")}}
# go
export GOPATH="$DATA_HOME/go"
add_to_path "$GOPATH/bin"
{{/if}}
prepend_to_path "$HOME/.local/bin"
{{#if (is_executable "yarn")}}
prepend_to_path "$HOME/.yarn/bin"
{{/if}}

# mise - configured before other tooling as the hook-env is needed for other tools to function properly
if [ ! -f "$HOME/.local/bin/mise" ] ; then
  source "$HOME/.dotfiles/helper_scripts/mise_install.sh" && mise_install
else
  {{#if (eq login_shell "zsh") }}
  eval "$(~/.local/bin/mise activate zsh)"
  eval "$(mise hook-env -s zsh)"
  {{/if}}
  {{#if (eq login_shell "bash") }}
  eval "$(~/.local/bin/mise activate bash)"
  eval "$(mise hook-env -s bash)"
  {{/if}}
  # mise shims, can also use 'mise activate --shims' to enable on demand
  # prepend_to_path "$HOME/.local/share/mise/shims:$PATH"
fi

# atuin
{{#if (is_executable "atuin")}}
{{#if (eq login_shell "zsh") }}
  # https://github.com/atuinsh/atuin/issues/68#issuecomment-1585444955
  eval "$(atuin init zsh --disable-ctrl-r)" # disable ctrl-r to use fzf for now, up still shows atuin
{{/if}}
{{#if (eq login_shell "bash") }}
  true # no-op for shellcheck
  # TODO install ble.sh for atuin bash -- https://github.com/akinomyoga/ble.sh
  # eval "$(atuin init bash)"
{{/if}}
{{/if}}

# rust - rustup / cargo
# TODO add installer in helper?
export RUSTUP_HOME="$DATA_HOME/rust/rustup"
export CARGO_HOME="$DATA_HOME/rust/cargo"

if [ -f "$CARGO_HOME/env" ]; then
  source "$CARGO_HOME/env"
else
  prepend_to_path "$CARGO_HOME/bin"
fi

{{#if (is_executable "nvim")}}
alias vim='nvim'
{{/if}}

# ripgrep
{{#if (is_executable "rg")}}
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/ripgreprc
{{/if}}

# zoxide
{{#if (eq login_shell "bash") }}
eval "$(zoxide init bash)"
{{/if}}
{{#if (eq login_shell "zsh") }}
eval "$(zoxide init zsh)"
{{/if}}
### end tooling

### aliases
# https://www.shellcheck.net/wiki/SC2139 - aliases should use single quotes to prevent confusion
{{#if (is_executable "cmatrix")}}
alias clear='[ $[$RANDOM % 10] = 0 ] && timeout 3 cmatrix; clear || clear'  # have some fun
{{/if}}
alias d='docker'
alias dcb='sudo -- sh -c "docker-compose pull && docker-compose down && docker-compose build --no-cache && docker-compose up -d"'
alias dcu='sudo -- sh -c "docker-compose pull && docker-compose down && docker-compose up -d"'
alias denops-reset='find ~/.vim/plugged -type f -regex ".*/denops/.*\.ts" -exec deno cache --reload {} +'
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
{{#if (is_executable "markdown-pdf")}}
alias markdown-pdf='markdown-pdf -s $HOME/.dotfiles/misc/modified-gfm.css'
{{/if}}
{{#if (is_executable "mullvad-exclude")}}
alias me='mullvad-exclude'
{{/if}}
alias mxlookup='nslookup -q=mx'
alias p='podman'
alias sudo='nocorrect sudo ' # A trailing space in VALUE causes the next word to be checked for alias substitution when the alias is expanded.
alias sdiff='sudo vimdiff'
alias tf='$tf_cmd'
alias tfplan='$tf_cmd plan -lock=false'
alias tfclean='rm -rf .terraform && $tf_cmd init'
alias tf-update-lockfile='$tf_cmd providers lock -platform=darwin_amd64 -platform=linux_amd64 -platform=darwin_arm64'
alias tmux='tmux -2' # assume 256 color
alias weather='curl wttr.in'
{{#if (is_executable "yay")}}
  {{#if (is_executable "mullvad-exclude")}}
# alias yay='PATH=$(getconf PATH) mullvad-exclude yay' # have yay build aur apps with system libraries
yay() {
  PATH=$(getconf PATH) mullvad-exclude yay "$@" # have yay build aur apps with system libraries
}
  {{else}}
# alias yay='PATH=$(getconf PATH) yay'
yay() {
    PATH=$(getconf PATH) command yay "$@" # have yay build aur apps with system libraries
}

  {{/if}}
{{/if}}
alias v='vim'

### end aliases

# check tf command and add tf workspace info to prompt
if [[ -z "$tf_cmd" ]]; then
  check_tf
fi
{{#if (eq login_shell "bash")}}
# to add more PROMPT_COMMAND="${PROMPT_COMMAND}; another_precmd"
PROMPT_COMMAND="tf_prompt_info"
# maybe an accurate zsh-clean prompt clone
PS1="${PS1:0:${#PS1}-5}\[\033[38;5;13m\](tf:$?)\[\033[0m\] $ "
{{/if}}
{{#if (eq login_shell "zsh")}}
precmd_functions+=(tf_prompt_info)
PROMPT="${PROMPT:0:${#PROMPT}-5}%2(V.%F{13}[tf:%2v].)%f $ "
{{/if}}
