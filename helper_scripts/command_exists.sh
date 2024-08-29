# this script shell-agnostic and intended to be sourced, not executed directly

# check for a command within your path
# usage example:
#   if command_exists tree ; then DO STUFF
command_exists () {
  command -v "$1" >/dev/null 2>&1;
}
