# this script shell-agnostic and intended to be sourced, not executed directly
# https://github.com/alacritty/alacritty-theme

alacritty_themes_install () {
  local alacritty_themes_dir="${HOME}/.config/alacritty/themes"
  local alacritty_themes_repo="https://github.com/alacritty/alacritty-theme"

  mkdir -p "${alacritty_themes_dir}"

  if [[ -d "${alacritty_themes_dir}/.git" ]]; then
    local default_branch
    default_branch=$(git -C "${alacritty_themes_dir}" remote show origin | awk '/HEAD branch/ {print $NF}')
    git -C "${alacritty_themes_dir}" checkout "${default_branch}"
    git -C "${alacritty_themes_dir}" pull --ff-only origin "${default_branch}"
  else
    git clone "${alacritty_themes_repo}" "${alacritty_themes_dir}"
  fi
}
