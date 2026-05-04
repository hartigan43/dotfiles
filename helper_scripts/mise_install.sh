# this script shell-agnostic and intended to be sourced, not executed directly

mise_install() {
  echo "mise binary not found, installing mise..."
  tmp_install_dir=$(mktemp -d) && cd "$tmp_install_dir" || exit

  gpg --keyserver hkps://keys.openpgp.org --recv-keys 24853EC9F655CE80B48E6C3A8B81C9D17413A06D
  curl https://mise.jdx.dev/install.sh.sig | gpg --decrypt > install.sh
  # ensure the above is signed with the mise release key
  sh ./install.sh

  #return to previous working directory
  cd -  || exit
  rm -rf "$tmp_install_dir"
}
