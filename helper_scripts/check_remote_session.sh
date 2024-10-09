# this script shell-agnostic and intended to be sourced, not executed directly

# we don't want to define REMOTE_SESSION by default as its used in psvar alongside V option
# V will check the element of the psvar array to see it exists and non-empty
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Conditional-Substrings-in-Prompts
check_remote_session () {
  if [[ -n "${SSH_CLIENT}" ]] || [[ -n "${SSH_TTY}" ]]; then
    REMOTE_SESSION=true
  else
    # Checking the parent process to detect remote sessions via other tools
    # TODO: Investigate why */sshd might be relevant for inclusion
    case $(ps -o comm= -p "${PPID}") in
      sshd|mosh-server|mosh)
        REMOTE_SESSION=true
        ;;
    esac
  fi
  echo "${REMOTE_SESSION}"
}
