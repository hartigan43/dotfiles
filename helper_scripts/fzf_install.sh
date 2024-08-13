#!/usr/bin/env bash

fzfInstall() {
  if [ ! -d "${HOME}/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
    cd "${HOME}/.fzf" && ./install
  fi
}
