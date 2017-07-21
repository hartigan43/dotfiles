#! /bin/sh

#Check for git and curl
prereqCheck() {
  test="curl git"
  for i in $test; do
   echo -e "Checking for $i ..."
   if which $i &> /dev/null; then
     echo -e "$i found...\n"
   else
     echo "Cannot find $i - please install it to continue"
     exit 0
   fi
   done
}

#Git Config
gitConf() {
  echo -e "Running basic git configuration...\n"
  read -p "Enter your name (full name): " name
  read -p "Enter your git email address: " email
  git config --global user.name "$name"
  git config --global user.email "$email"
  git config --global core.editor vim
}

installNERDFont() {
  echo -e "Installing Inconsolata for Powerline Nerd Font..."
  mkdir -p $HOME/.local/share/fonts
  cd $HOME/.local/share/fonts 
  curl -fLo "Inconsolata for Powerline Nerd Font Complete.otf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Inconsolata/complete/Inconsolata%20for%20Powerline%20Nerd%20Font%20Complete.otf
}

Install rbenv and ruby-build
rbenvInstall() {
  echo -e "Installing rbenv and ruby-build...\n"
  git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
}

#Set real username
setRealName() {
  read -p "Please enter you real name. ex: John Doe:\n" realName
  currentUser=whoami
  sudo usermod -c "'$realName'" $currentUser
}

#TODO
#SSH key gen prompt
#sshKeygen() {
#  read -p "Would you like to generate a new ssh keypair? " Yn
#  case
#}

install() {
  #install zgen
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

  #Symlink vimrc, zshrc and aliases/functions
  echo -e "Configuration files symlinked to HOME...\n"
  mv $HOME/.zshrc $HOME/.zshrc.bak #remove original zshrc

  mkdir -p $HOME/.config/vim
  mkdir -p $HOME/.vim

  #ln -s $HOME/.dotfiles/antigen/antigen.zsh $HOME/.antigen.zsh
  ln -s $HOME/.dotfiles/.zshrc_linux $HOME/.zshrc
  ln -s $HOME/.dotfiles/.tmux_linux.conf $HOME/.tmux.conf
  ln -s $HOME/.dotfiles/.zsh_aliases $HOME/.zsh_aliases
  ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc
  ln -s $HOME/.dotfiles/.tmux $HOME/.tmux
  ln -s $HOME/.dotfiles/.vimrc $HOME/.config/nvim/init.vim

  #Setup git
  gitConf

  #set the real username
  setRealName

  installNERDFont

  #rbenv installation
  #rbenvInstall

  #TODO see if this is still valid
  #ip tables to prevent a good bit of ISP video throttling
  #echo -e "Adding ISP throttling IP to iptables...\n"
  #sudo iptables -A INPUT -s 173.194.55.0/24 -j DROP
  #sudo iptables -A INPUT -s 206.111.0.0/16 -j DROP
}

####END FUNCTIONS####

prereqCheck
install
