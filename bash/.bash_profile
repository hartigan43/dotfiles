# https://superuser.com/a/583502/225931
if [ -f /etc/profile ]; then
  PATH=
  source /etc/profile
fi

. ~/.bashrc

export GPG_TTY=$(tty)

complete -C $(which terraform) terraform
