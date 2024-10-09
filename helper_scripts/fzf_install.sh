# this script shell-agnostic and intended to be sourced, not executed directly

fzf_install() {
  if [ ! -d "${XDG_DATA_HOME}/fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${XDG_DATA_HOME}/fzf"
    cd "${XDG_DATA_HOME}/fzf" && ./install --xdg
  fi
}
