#! /bin/bash
#Detect uname for proper os configuration
unamestr=$( uname -s )

####FUNCTIONS####
#uname case function
getOS() {
  case $unamestr in
    Darwin) os=0;;
     Linux) os=1; if [ -n $linux ]; then getLinux; fi;;
         *) echo -e "Uname was nor properly detected, this script will not complete properly.\n";;
  esac
}

#choose between my two main linux distributions
getLinux() {
  while true; do
    read -p "Enter a 1 if using Arch, enter 2 if using Ubuntu: " lin
    case $lin in
      1) linux=1; break;;
      2) linux=2; break;;
      *) echo -e "Please enter a 1 or 2.\n";;
    esac
  done
}

#install rbenv on osx or any linux
rbenvInstall() {
  if [[ $os -eq 1 ]]; then
    brew install rbenv
    brew install ruby-build
  else
    git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.zshrc
    git clone git://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
  fi
  echo -e "If you're not using the zshrc in this repo add 'eval "$(rbenv init -)"' to your bashrc or zshrc.\n"
}

#ubuntu YCM plugin plugin installation
ubuYCM() {
  echo -e "Installing YCM plugin plugin... \n"
  sudo apt-get install build-essential cmake python-dev
  cd $HOME/.vim/bundle/YouCompleteme
  ./install.sh --clang-completer
}

ubuPowerline() {
  sudo apt-get install python-pip
  pip install --user git+git://github.com/Lokaltog/powerline
  echo "set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim" >> $HOME/.vimrc
  mkdir $HOME/.fonts && cd $HOME/.fonts
  fontConfDir='unset'
  if [[ -d "$HOME/.fonts.conf.d" ]]; then   #fontconfig
    fontConfDir="$HOME/.fonts.conf.d"
  elif  [[ -d "$HOME/.config/fontconfig/conf.d" ]]; then  
    fontConfDir="$HOME/.config/fontconfig/conf.d"
  fi
  if [[ $fontConfDir != 'unset' ]]; then
    echo -e "Setting up fontconfig so powerline has proper symbols...\n"
    wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
    cd $fontConfDir && wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
  else # no fontconfig detected
    echo -e "Downloading two patched fonts (Inconsolata/DroidSansMono) that you can set for use in your terminal of choice since fontconfig failed...\n"
    wget https://github.com/Lokaltog/powerline-fonts/tree/master/Inconsolata/Inconsolata\ for\ Powerline.otf
    wget https://github.com/Lokaltog/powerline-fonts/tree/master/DroidSansMono/Inconsolata\ for\ Powerline.otf
  fi
  fc-cache -vf $HOME/.fonts
  echo -e "Powerline should have installed successfully.  Locate it and add rtp+=path/to/powerline/bindings/vim to your vimrc.\n":
}

#arch YCM plugin plugin installation
archYCM() {
  echo -e "Installing YCM plugin plugin... \n"
  sudo pacman -S clang cmake
  mkdir $HOME/ycm_build && cd $HOME/ycm_build
  cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG=ON . $HOME/.vim/bundle/YouCompleteMe/cpp
  make ycm_core
  cp /usr/lib/llvm/libclang.so $HOME/.vim/bundle/YouCompleteMe/python
}
#Install oh-my-zsh
ohmyzsh() {
  echo -e "Installing oh-my-zsh...\n"
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
  #in case prompt fails for zsh
  chsh -s /bin/zsh
}
####END FUNCTIONS####

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

#install oh-my-zsh
ohmyzsh

#Install vimrc zshrc and functions
echo -e "Copying vimrc, zshrc, tmux.conf and such to HOME...\n"
cp .tmux.conf $HOME
cp -R .vim $HOME
cp -R .zsh $HOME
mkdir $HOME/.vim/tmp $HOME/.vim/backups

#slightly different configs for paths and plugins
if [[ $os -eq 0 ]]; then
  cp .vimrc "$HOME/.vimrc"
  cp .zsh/.zshrc_osx "$HOME/.zshrc"
else
  cp .vimrc "$HOME/.vimrc"
  cp .zsh/.zshrc_linux "$HOME/.zshrc"
fi

echo -e "Running basic git configuration...\n"
read -p "Enter your name (full name): " name
read -p "Enter your git email address: " email
git config --global user.name "$name"
git config --global user.email "$email"

echo -e "Installing Vundle and running BundleInstall for vim plugins...\n"
git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
vim +BundleInstall +qall

#YCM BUILD AND POWERLINE INSTALLATION - CURRENTLY NOT AUTOMATED IN OSX DUE TO GOOFY PYTHON ISSUS WITH HOMEBREW / SYSTEM
if [[ $os -ne 0 ]]; then
  if [[ $linux -eq 2 ]]; then  #UBUNTU 
    ubuYCM
    echo -e "YCM complete, now installing poerline and its fonts...\n"
    ubuPowerline
  else   #ARCH
    echo -e "Installing YCM plugin plugin... \n"
    archYCM
    ehco -e "YCM complete, installing powerline...\n"
    packer -S python2-powerline-git
  fi
fi

#rbenv installation
rbenvInstall

#ip tables to prevent a good bit of bullshit ISP throttling
echo -e "Adding ISP throttling IP to iptables...\n"
sudo iptables -A INPUT -s 173.194.55.0/24 -j DROP
sudo iptables -A INPUT -s 206.111.0.0/16 -j DROP
