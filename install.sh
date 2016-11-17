#! /bin/sh
# TODO maybe ignore creating vim directories with new vimrc

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

#TODO zgen and zsh

#TODO Replace with vim-plug
#Install Vundle
#installVundle() {
#  echo -e "Installing Vundle and running BundleInstall for vim plugins...\n"
#  git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
#  vim +BundleInstall +qall
#}

#Git Config
gitConf() {
  echo -e "Running basic git configuration...\n"
  read -p "Enter your name (full name): " name
  read -p "Enter your git email address: " email
  git config --global user.name "$name"
  git config --global user.email "$email"
  git config --global core.editor vim
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

#common settings
commonInstall() {
#Symlink vimrc, zshrc and aliases/functions
echo -e "Configuration files symlinked to HOME...\n"
mv $HOME/.zshrc $HOME/.zshrc.bak #remove original zshrc

mkdir -p $HOME/.vim/tmp/backups $HOME/.vim/tmp/undo $HOME/.vim/tmp/swap

#Vundle installation and plugin install from vimrc
#installVundle

#zsh and zgen

#Setup git
gitConf

#set the real username
setRealName
}

workstationInstall() {
  #TODO replace antigen with zgen
  #ln -s $HOME/.dotfiles/antigen/antigen.zsh $HOME/.antigen.zsh
  ln -s $HOME/.dotfiles/.zshrc_linux $HOME/.zshrc
  #ln -s $HOME/.dotfiles/.zshrc_linux $HOME/.zshenv
  ln -s $HOME/.dotfiles/.tmux_linux.conf $HOME/.tmux.conf
  ln -s $HOME/.dotfiles/.zsh_aliases $HOME/.zsh_aliases
  ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc
  ln -s $HOME/.dotfiles/.tmux $HOME/.tmux
  commonInstall

  #rbenv installation
  #rbenvInstall

  #TODO see if this is still valid
  #ip tables to prevent a good bit of ISP video throttling
  echo -e "Adding ISP throttling IP to iptables...\n"
  sudo iptables -A INPUT -s 173.194.55.0/24 -j DROP
  sudo iptables -A INPUT -s 206.111.0.0/16 -j DROP
}

####END FUNCTIONS####

prereqCheck
workstationInstall
