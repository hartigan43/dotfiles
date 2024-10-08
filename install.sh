#!/usr/bin/env bash
# TODO cleanup symlink section, source RUST vars before install
# TODO figure out what the hell happened with sudo and "${PACKAGER}" expansion
# TODO symlink for vim snippets that work for both vim/nvim
# TODO deprecate all of this except for installs of base packages, dotter, and mise

# do not allow run as root - thanks @freekingdean
if [ "${EUID}" -eq 0 ]; then
  echo "This script should not be run as root!"
  exit 1
fi

# source installation helper scripts. each script here is just an individual function
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

# configure the global get settings for name, email, and editor
# TODO move to helper_scripts
gitConfig() {
  echo -e "Running basic git configuration...\n"
  echo "Enter your full name for git: "; read name
  echo "Enter your git email address: "; read email
  git config --global user.name "${name}"
  git config --global user.email "${email}"
  git config --global core.editor "${EDITOR}"
  git config --global init.defaultBranch "main"
  if confirm "add global git aliases"; then
    git config --global alias.main "! MAIN=$(git branch -l master main | sed -r 's/^[* ] //' | head -n 1) && git fetch && git checkout $MAIN && git pull origin $MAIN"
  fi
}

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

  # TODO GNUSTOW/alternative
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

  # symlinks to $HOME
  ln -s "${HOME}/.dotfiles/bash/.bash_profile" "${HOME}/.bash_profile"
  ln -s "${HOME}/.dotfiles/bash/.bashrc" "${HOME}/.bashrc"
  ln -s "${HOME}/.dotfiles/alacritty/alacritty.toml" "${HOME}/.config/alacritty/alacritty.toml"
  ln -s "${HOME}/.dotfiles/misc/.common.sh" "${HOME}/.common.sh"
  ln -s "${HOME}/.dotfiles/misc/.ripgreprc" "${HOME}/.config/ripgrep/.ripgreprc"
  ln -s "${HOME}/.dotfiles/misc/.editorconfig" "${HOME}/.editorconfig"
  # TODO FIX this
  ln -s "${HOME}/.dotfiles/tmux/.tmux.conf" "${HOME}/.tmux.conf"
  ln -s "${HOME}/.dotfiles/tmux" "${HOME}/.tmux"
  ln -s "${HOME}/.dotfiles/vim/.vimrc" "${HOME}/.vimrc"
  ln -s "${HOME}/.dotfiles/vim/.vimrc" "${HOME}/.config/nvim/init.vim"
  ln -s "${HOME}/.dotfiles/zsh/.zshrc" "${HOME}/.zshrc"

  # use find and cp -s to add symlink for any .vim colors files
  find "${HOME}/.dotfiles/vim/colors/" -type f -name "*.vim" -exec cp -s {} "${HOME}/.vim/colors/" \;
  find "${HOME}/.dotfiles/vim/colors/" -type f -name "*.vim" -exec cp -s {} "${HOME}/.config/nvim/colors/" \;
  # do the same for alacritty themes after cloning public themes repo
  git clone https://github.com/alacritty/alacritty-theme "${HOME}/.config/alacritty/themes"
  find "${HOME}/.dotfiles/alacritty/themes" -type f -name "*.toml" -exec cp -s {} "${HOME}/.config/alacritty/themes/themes/" \;
}

#### Run it ####
installBasics
if confirm "configure git"; then
  gitConfig
fi
if confirm "install rust via rustup"; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
fi
setRealName
if confirm "install NERDFonts"; then
  nerd_fonts_install
fi
