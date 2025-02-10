# this script shell-agnostic and intended to be sourced, not executed directly

# TODO run a check for arch and use extra repo for fonts - https://archlinux.org/groups/any/nerd-fonts/:
# ttf-iosevka-nerd
# ttf-iosevkaterm-nerd
# itf-incosolata-go-nerd
# ttf-inconsolata-nerd
# otf-droid-nerd

# TODO same for brew + macos: brew install font-hack-nerd-font

# TODO use clone as last resort method
# clone and install patched nerdfonts to work with airline and powerline symbols
nerd_fonts_install() {
  echo "Installing Nerd Fonts..."
  mkdir -p "${HOME}/.local/share/fonts"

  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git "${HOME}/Workspace/misc/nerd-fonts"
  cd "${HOME}/Workspace/misc/nerd-fonts" || return
  ./install.sh Inconsolata
  ./install.sh InconsolataGo
  ./install.sh Iosevka
  ./install.sh DroidSansMono
}
