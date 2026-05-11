# this script shell-agnostic and intended to be sourced, not executed directly

# TODO run a check for arch and use extra repo for fonts - https://archlinux.org/groups/any/nerd-fonts/:
# ttf-iosevka-nerd
# ttf-iosevkaterm-nerd
# itf-incosolata-go-nerd
# ttf-inconsolata-nerd
# otf-droid-nerd
# TODO same for brew + macos: brew install font-hack-nerd-font
# TODO use clone as last resort method?

# clone and install patched nerdfonts to work with airline and powerline symbols
nerd_fonts_install() {
  local fonts_repo="${HOME}/Workspace/misc/nerd-fonts"

  echo "Installing Nerd Fonts..."
  mkdir -p "${HOME}/.local/share/fonts"

  if [[ -d "${fonts_repo}/.git" ]]; then
    printf 'Nerd Fonts repo already cloned, pulling latest...\n'
    git -C "${fonts_repo}" pull --ff-only
  else
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git "${fonts_repo}"
  fi

  cd "${fonts_repo}" || return
  ./install.sh Inconsolata
  ./install.sh InconsolataGo
  ./install.sh Iosevka
  ./install.sh DroidSansMono
}
