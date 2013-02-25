#! /bin/bash
#Detect uname for proper os configuration
unamestr=$( uname -s )

#Install ZSH
echo -e "Installing ZSH and oh-my-zsh...\n"
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

#Install vimrc zshrc and functions
echo -e "Copying vimrc, zshrc, tmux.conf and such to HOME...\n"
cp .vimrc $HOME
case $unamestr in
   Linux) cp .zsh/.zshrc_linux "$HOME/.zshrc";;
  Darwin) cp .zsh/.zshrc_osx "$HOME/.zshrc"; echo -e "Also installing Homebrew for OSX...\n"; ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)";;
       *) echo -e "Uname was not properly detected, manually copy over zshrc.\n";;
esac
cp .tmux.conf $HOME
cp -R .vim $HOME
cp -R .zsh $HOME

while true; do
  read -p "Do you have git currently installed? (y/n): " yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) if [[ $unamestr == 'Darwin' ]]; then
              brew install git;
            else
              echo -e "Install git before proceeding.\n";
            fi ;;
        * ) echo -e "Please enter yes or no\n";;
  esac
done

read -p "Enter your git username (full name): " name
read -p "Enter your git email address: " email
git config --global user.name "$name"
git config --global user.email "$email"

echo -e "Installing Vundle and running BundleInstall for vim plugins...\n"
echo -e "NOTE: YOU WILL HAVE TO BUILD THE YCM AND POWERLINE DEPENDENCIES FOR YOUR MACHINE!:"
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +BundleInstall +qall
