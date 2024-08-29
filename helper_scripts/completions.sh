# this script shell-agnostic and intended to be sourced, not executed directly

source "${HOME}/.dotfiles/helper_scripts/command_exists.sh"

# get current shell and set completion directory, defaults to linux XDG_CONFIG_HOME
shell=$(basename "$SHELL")
completion_dir="${HOME}/.config/${shell}/completions"

install_completions() {
  local tools=(
    "kubectl"
    "mise"
    "spacectl"
  )

  # check for completion directory and create if not
  [[ -d "${completion_dir}" ]] || mkdir -p "${completion_dir}"

  for tool in "${tools[@]}"; do
    if command_exists "${tool}" ; then
      "${tool}" completion "${shell}" > "${completion_dir}/_${tool}"
    fi
  done

  echo "completions installed.  Make sure to add them to your fpath.  ex: fpath=(~/.config/zsh/completions \$fpath)"
}

