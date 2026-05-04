# Setup fzf
# ---------
# first check for mise install, then manually/system
if [[ ! "$PATH" == *"${HOME}"/.local/share/mise/installs/fzf/latest/bin* ]]; then
  PATH="${PATH:+${PATH}:}${HOME}/.local/share/mise/installs/fzf/latest/bin"
elif [[ ! "$PATH" == */home/hartigan/.local/share/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/hartigan/.local/share/fzf/bin"
fi

eval "$(fzf --bash)"
