# this script shell-agnostic and intended to be sourced, not executed directly

# confirmation prompt wrapper for read use in zsh and bash
# usage example:
#   confirm "install THINGS"
confirm() {
  echo "Do you want to $1? [y/N] "
  read response
  response="$(echo "$response"  | tr '[:upper:]' '[:lower:]')"

  if [[ "$response" =~ ^(yes|y)$ ]]; then
    return 0
  else
    return 1
  fi
}
