# this script shell-agnostic and intended to be sourced, not executed directly

source "${HOME}/.dotfiles/helper_scripts/command_exists.sh"

# get current shell and set completion directory, defaults to linux XDG_CONFIG_HOME
shell=$(basename "$SHELL")
completion_dir="${HOME}/.config/${shell}/completions"

install_completions() {
  #create an array of tools installed via mise
  local tools=()
  while IFS="" read -r line ; do tools+=("$line") ; done < <(mise list | awk 'NR>0 {print $1}' | cut -d: -f1)
  # sc doesn't like the line below - https://www.shellcheck.net/wiki/SC2207
  # local tools=($(mise list | awk 'NR>1 {print $1}' | cut -d: -f1))

  # check for completion directory and create if not
  [[ -d "${completion_dir}" ]] || mkdir -p "${completion_dir}"

  for tool in "${tools[@]}"; do
    if command_exists "${tool}" ; then
      if "${tool}" completion &> /dev/null; then
        echo "Installing ${tool} completions..."
        "${tool}" completion "${shell}" > "${completion_dir}/_${tool}"
      fi
    fi
  done

  echo "completions installed.  Make sure to add them to your fpath.  ex: fpath=(~/.config/zsh/completions \$fpath)"
}
# vim: set ft=sh et:
