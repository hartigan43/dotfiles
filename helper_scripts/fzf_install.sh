# this script shell-agnostic and intended to be sourced, not executed directly

fzfInstall() {
  if [ ! -d "${HOME}/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
    cd "${HOME}/.fzf" && ./install
  fi
}
