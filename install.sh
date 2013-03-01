#! /bin/bash
#Detect uname for proper os configuration
unamestr=$( uname -s )

#uname case function
getOS() {
  case $unamestr in
    Darwin) os=0;;
     Linux) os=1; if [ -n $linux ]; then linuxVersion; fi;;
         *) echo -e "Uname was nor properly detected, this script will not complete properly.\n";;
  esac
}

#choose between my two main linux distributions
linuxVersion() {
  while true; do
    read -p "Enter a 1 if using Arch, enter 2 if using Ubuntu: " lin
    case $lin in
      1) linux=1; break;;
      2) linux=2; break;;
      *) echo -e "Please enter a 1 or 2.\n";;
    esac
  done
}

echo -e "$unamestr detected!\n"
getOS

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
#in case prompt fails for zsh
chsh -s /bin/zsh

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

echo -e "Running basic git configuration...\n"
read -p "Enter your name (full name): " name
read -p "Enter your git email address: " email
git config --global user.name "$name"
git config --global user.email "$email"

echo -e "Installing Vundle and running BundleInstall for vim plugins...\n"
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +BundleInstall +qall

#YCM BUILD AND POWERLINE INSTALLATION - CURRENTLY NOT AUTOMATED IN OSX DUE TO GOOFY PYTHON ISSUS WITH HOMEBREW / SYSTEM
if [[ $os -ne 0 ]]; then
  if [[ $linux -eq 2]]; then  #UBUNTU 
    sudo apt-get install build-essential cmake python-dev
    cd ~/.vim/bundle/YouCompleteme
    ./install.sh --clang-completer
    sudo apt-get install python-pip
    pip install --user git+git://github.com/Lokaltog/powerline
    echo "set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim" >> $HOME/.vimrc
    mkdir $HOME/.fonts && cd $HOME/.fonts
    wget https://github.com/Lokaltog/powerline-fonts/tree/master/Inconsolata/Inconsolata\ for\ Powerline.otf
    fc-cache -vf $HOME/.fonts
  else   #ARCH
    sudo pacman -S clang cmake
    mkdir ~/ycm_build && cd ~/ycm_build
    cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG=ON . ~/.vim/bundle/YouCompleteMe/cpp
    make ycm_core
    cp /usr/lib/llvm/libclang.so ~/.vim/bundle/YouCompleteMe/python
    ehco -e "YCM complete, installing powerline...\n"
    packer -S python2-powerline-git
  fi
fi

#ip tables to prevent a good bit of bullshit ISP throttling
echo -e "Adding ISP throttling IP to iptables...\n"
sudo iptables -A INPUT -s 173.194.55.0/24 -j DROP
sudo iptables -A INPUT -s 206.111.0.0/16 -j DROP

#rbenv installation
if [[ $ os -eq 0 ]]; then
  brew install rbenv
  brew install ruby-build
  echo 'eval "$(rbenv init -)"' >> ~/.zshrc
else
  git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(rbenv init -)"' >> ~/.zshrc
  git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi
