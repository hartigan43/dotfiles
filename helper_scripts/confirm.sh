# this script shell-agnostic and intended to be sourced, not executed directly

# confirmation prompt wrapper for read use in zsh and bash
# usage example:
#   confirm "install THINGS"
# Set NON_INTERACTIVE=true as an env var to auto-confirm all prompts, e.g:
#   NON_INTERACTIVE=true ./install.sh
confirm() {
  if [[ "${NON_INTERACTIVE:-false}" == "true" ]]; then
    printf 'Auto-confirming: %s\n' "$1"
    return 0
  fi

  printf 'Do you want to %s? [y/N] ' "$1"
  read -r response
  response="$(printf '%s' "$response" | tr '[:upper:]' '[:lower:]')"

  if [[ "$response" =~ ^(yes|y)$ ]]; then
    return 0
  else
    return 1
  fi
}
