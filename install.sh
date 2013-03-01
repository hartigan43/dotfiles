#! /bin/bash
#Detect uname for proper os configuration
unamestr=$( uname -s )
linux=''

#TODO ADD UBUNTU CONFIG AS WELL AS ARCH WHEN WORKING
#TODO .vimrcs folder for diff configs
#uname case function
getOS() {
  case $unamestr in
    Darwin) os=0;;
     Linux) os=1; if [[ -n $linux ]]; then linuxVersion(); fi;;
         *) echo -e "Uname was nor properly detected, this script will not complete properly.\n";;
  esac
}

#choose between my two main linux instalations Arch for desktop and ubuntu server
linuxVersion() {
  while true; do
    read -p "Enter a 1 if using Arch, enter 2 if using Ubuntu" lin
    case $lin in
      1) linux=1; break;;
      2) linux=2; break;;
      *) echo -e "Please enter a 1 or 2.\n";;
    esac
  done
}

#Install zsh and git
echo -e "Installing zsh and git...\n"
if [[ $os -eq 0 ]]; then
  echo -e "Installing homebrew first...\n"; ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
  brew update; brew install zsh git
elif [[ $linux -eq 1 ]]; then
  sudo pacman -Syu; sudo pacman -S zsh git
else
  sudo apt-get update; sudo apt-get install zsh git
fi

#Install oh-my-zsh
echo -e "Installing oh-my-zsh...\n"
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

#Install vimrc zshrc and functions
echo -e "Copying vimrc, zshrc, tmux.conf and such to HOME...\n"
cp .tmux.conf $HOME
cp -R .vim $HOME
cp -R .zsh $HOME
mkdir $HOME/.vim/tmp $HOME/.vim/backups

#slightly different configs for paths and plugins
if [[ $os -eq 0 ]]; then
  cp .vimrcs/.vimrc_osx "$HOME/.vimrc"
  cp .zsh/.zshrc_osx "$HOME/.zshrc"
elif [[ $linux -eq 1 ]]; then
  cp .vimrcs/.vimrc_arch "$HOME/.vimrc"
  cp .zsh/.zshrc_arch "$HOME/.zshrc"
else
  cp .vimrcs/.vimrc_linux "$HOME/.vimrc"
  cp .zsh/.zshrc_linux "$HOME/.zshrc"
fi

read -p "Enter your name (full name): " name
read -p "Enter your git email address: " email
git config --global user.name "$name"
git config --global user.email "$email"

echo -e "Installing Vundle and running BundleInstall for vim plugins...\n"
echo -e "NOTE: YOU WILL HAVE TO BUILD THE YCM AND POWERLINE DEPENDENCIES FOR YOUR MACHINE!:"
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +BundleInstall +qall
