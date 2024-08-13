#!/usr/bin/env bash

mise_install() {
  echo "mise binary not found, installing mise..."
  tmp_install_dir=$(mktemp -d) && cd "$tmp_install_dir" || exit

  # verify the install script and execute it
  gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 0x7413A06D
  curl https://mise.jdx.dev/install.sh.sig | gpg --decrypt > install.sh
  sh ./install.sh

  #return to previous working directory
  cd -  || exit
  rm -rf "$tmp_install_dir"
}
