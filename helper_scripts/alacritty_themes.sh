# this script shell-agnostic and intended to be sourced, not executed directly

# #!/usr/bin/env sh
# https://github.com/alacritty/alacritty-theme

alacritty_themes_install () {
  mkdir -p ~/.config/alacritty/themes
  git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/t
}
