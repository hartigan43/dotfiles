# Setup fzf
# ---------
# first check for mise install, then manually/system
if [[ ! "$PATH" == *"${HOME}"/.local/share/mise/installs/fzf/*/bin* ]]; then
  PATH="${PATH:+${PATH}:}${HOME}/.local/share/mise/installs/fzf/latest/bin"
elif [[ ! "$PATH" == *"${HOME}"/.local/share/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}${HOME}/.local/share/fzf/bin"
fi

source <(fzf --zsh)
