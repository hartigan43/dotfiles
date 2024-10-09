# this script shell-agnostic and intended to be sourced, not executed directly

zcomet_install () {
  if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
    command git clone https://github.com/agkozak/zcomet.git "${ZDOTDIR:-${HOME}}"/.zcomet/bin
  fi
}
