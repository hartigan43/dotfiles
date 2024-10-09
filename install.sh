#!/usr/bin/env bash
# TODO figure out what the hell happened with sudo and "${PACKAGER}" expansion
# TODO deprecate all of this except for installs of base packages, dotter, and mise

# do not allow run as root - thanks @freekingdean
if [ "${EUID}" -eq 0 ]; then
  echo "This script should not be run as root!"
  exit 1
fi

# source installation helper scripts. each script here is just an individual function
# TODO all are not needed and should be cleaned up
for script in "$HOME"/.dotfiles/helper_scripts/*.sh ; do
  if [ -f "$script" ]; then
    source "$script"
  fi
done

# make workspace and misc
mkdir -p "${HOME}/Workspace/misc"

#### PLATFORM AND PACKAGES ####

PLATFORM="$(uname)"
# TODO - no longer necessary?
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

###
# most functions have been moved to individual scripts within `helper_scripts/$NAME.sh` for portability
###

# Set real username
setRealName() {
  echo -e "Please enter you real name, for your user account. ex: John Doe:\n"; read realName
  sudo usermod -c "'${realName}' $(whoami)"
}

installBasics() {
  mkdir -p "${HOME}/.local/bin"

  # first update and install of packages
  echo "Running ${PACKAGER} ${PACKAGER_UPDATE}..."
  sudo ${PACKAGER} ${PACKAGER_UPDATE}
  echo "Running ${PACKAGER} ${PACKAGER_UPGRADE}..."
  sudo ${PACKAGER} ${PACKAGER_UPGRADE}
  echo "Running ${PACKAGER} ${PACKAGER_INSTALL} ${PACKAGES}..."
  sudo ${PACKAGER} ${PACKAGER_INSTALL} ${PACKAGES}

  # install zcomet
  # TODO break out into helper function
  echo -e "Cloning zcomet into ~/.zcomet ...\n"
  git clone https://github.com/agkozak/zcomet.git "${HOME}/.zcomet"

  # Symlink vimrc, zshrc and aliases/functions
  echo -e "Symlinks for vimrc, zshrc, tmux.conf, etc to HOME...\n"
  #backup any original config files
  mv "${HOME}/.zshrc" "${HOME}/.zshrc.bak"
  mv "${HOME}/.bashrc" "${HOME}/.bashrc.bak"
  mv "${HOME}/.bash_profile" "${HOME}/.bash_profile.bak"

  # vim/nvim, config directories
  mkdir -p "${HOME}/.config/vim"
  mkdir -p "${HOME}/.vim/colors"
  mkdir -p "${HOME}/.config/nvim/colors"
  mkdir -p "${HOME}/.config/alacritty/themes"

  git clone https://github.com/alacritty/alacritty-theme "${HOME}/.config/alacritty/themes"
}

#### Run it ####
installBasics
if confirm "install rust via rustup"; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
fi
setRealName
if confirm "install NERDFonts"; then
  nerd_fonts_install
fi
