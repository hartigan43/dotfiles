# this script shell-agnostic and intended to be sourced, not executed directly
# https://github.com/alacritty/alacritty-theme

alacritty_themes_install () {
  alacritty_themes_dir="${HOME}/.config/alacritty/themes"
  alacritty_themes_repo="https://github.com/alacritty/alacritty-theme"
  mkdir -p "${alacritty_themes_dir}"
  if [ -d .git ]; then
    default_branch=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
    git checkout "${default_branch}"
    git pull --ff-only origin "${default_branch}"
  else
    git clone <repo-url> .
  fi
  # git clone https://github.com/alacritty/alacritty-theme "${HOME}/.config/alacritty/themes"
}
