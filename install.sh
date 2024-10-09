#!/usr/bin/env bash
set -ex
# TODO figure out what the hell happened with sudo and "${PACKAGER}" expansion

# do not allow run as root - thanks @freekingdean
if [ "${EUID}" -eq 0 ]; then
  echo "This script should not be run as root!"
  exit 1
fi

HELPER_DIR="${HOME}/.dotfiles/helper_scripts"

# make workspace and misc
mkdir -p "${HOME}/Workspace/misc"

#### PLATFORM AND PACKAGES ####

PLATFORM="$(uname)"
if [ "${PLATFORM}" = "linux" ] || [ "${PLATFORM}" = "Linux" ]; then
  PLATFORM="$(cat /etc/*-release | grep ^ID= | sed 's/^ID=\(.*\)$/\1/')"
  if [ "${PLATFORM}" = "" ]; then
    if [ -x "$(command -v pacman)" ]; then
      PLATFORM="arch"
    fi
  fi
fi

PACKAGES="zsh ruby git curl wget neovim tmux openssh go podman tree"
EDITOR="${EDITOR:-$(command -v vim)}"

echo "$PLATFORM detected.  Proceeding in 5, hit CTRC-C to cancel"
sleep 5

if [ "${PLATFORM}" = "centos" ]; then
  PACKAGER="yum -y"
  PACKAGER_INSTALL="install"
  PACKAGER_UPDATE="update"
  PACKAGER_UPGRADE="upgrade"
  PACKAGES="${PACKAGES} python3 python3-pip openssl-devel readline-devel zlib-devel"
elif [ "${PLATFORM}" = "debian" ]; then
  PACKAGER="apt-get -y"
  PACKAGER_INSTALL="install"
  PACKAGER_UPDATE="update"
  PACKAGER_UPGRADE="upgrade"
  PACKAGES="${PACKAGES} python3 python3-pip libssl-dev libreadline-dev zlib1g-dev"
  sudo cp /usr/bin/pip3 /usr/bin/pip
elif [ "${PLATFORM}" = "fedora" ]; then
  PACKAGER="dnf -y"
  PACKAGER_INSTALL="install"
  PACKAGER_UPDATE="update"
  PACKAGER_UPGRADE="upgrade"
  PACKAGES="${PACKAGES} python3 python3-pip openssl-devel readline-devel zlib-devel"
elif [[ "${PLATFORM}" = "arch" || "${PLATFORM}" = "archarm" ]]; then
  PACKAGER="pacman --noconfirm"
  PACKAGER_INSTALL="-S"
  PACKAGER_UPDATE="-Syu"
  PACKAGER_UPGRADE="-Syu"
  PACKAGES="${PACKAGES} base-devel bat fd python python-pip cmake vim neovim python-pynvim"
elif [ "${PLATFORM}" = "Darwin" ]; then
  # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  PACKAGER="brew"
  PACKAGER_INSTALL="install"
  PACKAGER_UPDATE="update"
  PACKAGER_UPGRADE="upgrade"
  PACKAGES="${PACKAGES} python telnet watch htop glances kubectx infracost pygments ccat"
else
  echo "platform '${PLATFORM}' is not supported"
  exit 1
fi

# Set real username
set_real_name () {
  echo -e "Please enter you real name, for your user account. ex: John Doe:\n"; read real_name
  sudo usermod -c "'${real_name}' $(whoami)"
}

install_basics () {
  mkdir -p "${HOME}/.local/bin"

  # first update and install of packages
  echo "Running ${PACKAGER} ${PACKAGER_UPDATE}..."
  sudo ${PACKAGER} ${PACKAGER_UPDATE}
  echo "Running ${PACKAGER} ${PACKAGER_UPGRADE}..."
  sudo ${PACKAGER} ${PACKAGER_UPGRADE}
  echo "Running ${PACKAGER} ${PACKAGER_INSTALL} ${PACKAGES}..."
  sudo ${PACKAGER} ${PACKAGER_INSTALL} ${PACKAGES}

  source "${HELPER_DIR}/zcomet_install.sh" && zcomet_install
  source "${HELPER_DIR}/mise_install.sh" && mise_install

  # Symlink vimrc, zshrc and aliases/functions
  echo -e "Backing up existing config files...\n"
  #backup any original config files
  mv "${HOME}/.zshrc" "${HOME}/.zshrc.bak"
  mv "${HOME}/.bashrc" "${HOME}/.bashrc.bak"
  mv "${HOME}/.bash_profile" "${HOME}/.bash_profile.bak"

  # vim/nvim, config directories
  mkdir -p "${HOME}/.config/vim"
  mkdir -p "${HOME}/.vim/colors"
  mkdir -p "${HOME}/.config/alacritty/themes"
  mkdir -p "${HOME}/.config/mise"
  mkdir -p "${HOME}/.config/nvim/colors"

  source "${HELPER_DIR}/alacritty_themes_install.sh" && alacritty_themes_install

  # we need to link mise manually so we can then install tools and dependencies in mise and use dotter after.
  ln -s "${HOME}/.dotfiles/config/mise/config.toml" "${HOME}/.config/mise/config.toml"
}

#### Run it ####
install_basics
if confirm "install rust via rustup"; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
fi
if [[ "${PLATFORM}" != "Darwin" ]] ; then
  if confirm "set current user's real name"; then
    set_real_name
  fi
fi
if confirm "install NERDFonts"; then
  source "${HELPER_DIR}/nerdfonts_install.sh" && nerd_fonts_install
fi

echo -e "Wrapping up.  Starting a new shell and running mise i && cd ~/.dotfiles && dotter"
exec $SHELL -c "mise i && cd ~/.dotfiles && dotter"
