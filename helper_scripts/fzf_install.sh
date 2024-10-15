# this script shell-agnostic and intended to be sourced, not executed directly

# set XDG_DATA_HOME if it isn't set already
: "${XDG_DATA_HOME:=$HOME/.local/share}"

fzf_install() {
  if [ ! -d "${XDG_DATA_HOME}/fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${XDG_DATA_HOME}/fzf"
    cd "${XDG_DATA_HOME}/fzf" && ./install --xdg
  fi
}
