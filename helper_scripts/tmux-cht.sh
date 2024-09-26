# this script shell-agnostic and via run via a tmux binding
# modified from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-cht.sh

cat=$(which cat)
source "${HOME}/.dotfiles/helper_scripts/command_exists.sh"

if ! command_exists fzf; then
  echo "fzf not installed. exiting..."
  exit 0
fi

if command_exists bat; then
  cat="$(which bat)"
  export BAT_THEME="gruvbox-light"
fi

selected=$(cat ~/.tmux/tmux-cht-languages ~/.tmux/tmux-cht-command | fzf --height ~100%)
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter cht.sh query: " query

if grep -qs "$selected" ~/.tmux/tmux-cht-languages; then
  query=$(echo "$query" | tr ' ' '+')
    #tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
  echo "curl cht.sh/$selected/$query/"
  "$cat" <(curl -s "cht.sh/$selected/$query" 2>&1)
else
    #tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
    #echo "curl cht.sh/$selected/$query/"
   "$cat" <(curl -s "cht.sh/$selected~$query" 2>&1)
fi
