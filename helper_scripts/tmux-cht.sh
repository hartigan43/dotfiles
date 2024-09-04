# this script shell-agnostic and via run via a tmux binding
# modified from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-cht.sh

source "${HOME}/.dotfiles/helper_scripts/command_exists.sh"

if ! command_exists fzf; then
  echo "fzf not installed. exiting..."
  exit 0
fi

selected=`cat ~/.tmux/tmux-cht-languages ~/.tmux/tmux-cht-command | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.tmux/tmux-cht-languages; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
fi

