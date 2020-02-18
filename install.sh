#! /bin/bash

# do not allow run as root - thanks @freekingdean
if [ "$EUID" -eq 0 ]; then
  echo "This script should not be run as root!"
  exit 1
fi

# make workspace and misc
mkdir -p $HOME/Workspace/misc

###### PLATFORM AND PACKAGES

PLATFORM=$(uname)
if [ "$PLATFORM" = "linux" ] || [ "$PLATFORM" = "Linux" ]; then
  PLATFORM=$(cat /etc/*-release | grep ^ID= | sed 's/^ID=\(.*\)$/\1/')
  if [ "$PLATFORM" = "" ]; then
    if [ -x "$(command -v pacman)" ]; then
      PLATFORM="arch"
    fi
  fi
fi

PACKAGES="zsh ruby git curl wget neovim tmux openssh go docker"

if [ "$PLATFORM" = "centos" ]; then
  PACKAGER="sudo yum -y"
  PACKAGER_INSTALL="install"
  PACKAGER_UPDATE="update"
  PACKAGER_UPGRADE="upgrade"
  PACKAGES="$PACKAGES python3 python3-pip openssl-devel readline-devel zlib-devel"
elif [ "$PLATFORM" = "debian" ]; then
  PACKAGER="sudo apt-get -y"
  PACKAGER_INSTALL="install"
  PACKAGER_UPDATE="update"
  PACKAGER_UPGRADE="upgrade"
  PACKAGES="$PACKAGES python3 python3-pip libssl-dev libreadline-dev zlib1g-dev"
  sudo cp /usr/bin/pip3 /usr/bin/pip
elif [ "$PLATFORM" = "fedora" ]; then
  PACKAGER="sudo dnf -y"
  PACKAGER_INSTALL="install"
  PACKAGER_UPDATE="update"
  PACKAGER_UPGRADE="upgrade"
  PACKAGES="$PACKAGES python3 python3-pip openssl-devel readline-devel zlib-devel"
elif [ "$PLATFORM" = "arch" ]; then
  PACKAGER="sudo pacman --noconfirm"
  PACKAGER_INSTALL="-S"
  PACKAGER_UPDATE="-Syu"
  PACKAGER_UPGRADE="-Syu"
  PACKAGES="$PACKAGES base-devel python python-pip"
elif [ "$PLATFORM" = "Darwin" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  PACKAGER="brew"
  PACKAGER_INSTALL="install"
  PACKAGER_UPDATE="update"
  PACKAGER_UPGRADE="upgrade"
  PACKAGES="$PACKAGES python"
else
  echo "platform '$PLATFORM' is not supported"
  exit 1
fi

#### FUNCTIONS ####

# configure the global get settings for name, email, and editor
gitConfig() {
  echo -e "Running basic git configuration...\n"
  read -p "Enter your name (full name): " name
  read -p "Enter your git email address: " email
  git config --global user.name "$name"
  git config --global user.email "$email"
  git config --global core.editor vim
}

# clone and install patched nerdfonts to work with airline and powerline symbols locally
installNERDFonts() {
  echo -e "Installing Powerline compatible Nerd Fonts..."
  mkdir -p $HOME/.local/share/fonts

  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git $HOME/Workspace/misc/nerd-fonts
  cd $HOME/Workspace/misc/nerd-fonts
  ./install.sh Inconsolata
  ./install.sh InconsolataGo
  ./install.sh Iosevka
  ./install.sh DroidSansMono
}

# install fzf
fzfInstall() {
  if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    cd $HOME/.fzf &&  ./install
  fi
}

# intall pyenv and pyenv-build
pyenvInstall() {
  if [ ! -d "$HOME/.pyenv" ]; then
    echo -e "Instally pyenv...\n"
    git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
  fi
}

# Install rbenv and ruby-build
rbenvInstall() {
  if [ ! -d "$HOME/.rbenv" ]; then
    echo -e "Installing rbenv and ruby-build...\n"
    git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
    cd ~/.rbenv && src/configure && make -C src
  fi
  if [ ! -d "$HOME/.rbenv/plugins/ruby-build" ]; then
    git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
  fi
}

# Set real username
setRealName() {
  read -p "Please enter you real name. ex: John Doe:\n" realName
  currentUser=whoami
  sudo usermod -c "'$realName'" $currentUser
}

installBasics() {
  mkdir -p $HOME/.bin
  mkdir -p $HOME/.local/bin

  # first update and install of packages
  echo -e "Updating then installing zsh wget curl git tmux...\n"
  $PACKAGER $PACKAGER_UPDATE
  $PACKAGER $PACKAGER_UPGRADE
  $PACKAGER $PACKAGER_INSTALL ${PACKAGES}

  # install zgen
  echo -e "Cloning zgen into ~/.zgen ...\n"
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

  # Symlink vimrc, zshrc and aliases/functions
  echo -e "Symlinks for vimrc, zshrc, tmux.conf, etc to HOME...\n"
  touch $HOME/.zshrc
  mv $HOME/.zshrc $HOME/.zshrc.bak #remove original zshrc


  # vim/nvim directories
  mkdir -p $HOME/.config/vim
  mkdir -p $HOME/.vim
  mkdir -p $HOME/.config/nvim
  
  ln -s $HOME/.dotfiles/.bash_profile $HOME/.bash_profile
  ln -s $HOME/.dotfiles/.bashrc $HOME/.bashrc
  ln -s $HOME/.dotfiles/.zshrc_linux $HOME/.zshrc
  ln -s $HOME/.dotfiles/.aliases.sh $HOME/.aliases.sh
  ln -s $HOME/.dotfiles/.tmux_linux.conf $HOME/.tmux.conf
  ln -s $HOME/.dotfiles/.tmux $HOME/.tmux
  ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc
  ln -s $HOME/.dotfiles/.vimrc $HOME/.config/nvim/init.vim
}

####END FUNCTIONS####

installBasics
gitConfig
fzfInstall
pyenvInstall
rbenvInstall
setRealName
installNERDFonts
