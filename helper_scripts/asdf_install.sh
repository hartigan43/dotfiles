# this script shell-agnostic and intended to be sourced, not executed directly

asdf_install () {
  BRANCH=$(curl -s https://api.github.com/repos/asdf-vm/asdf/releases/latest | sed -n 's/.*"tag_name": "\(.*\)".*/\1/p')
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "$BRANCH"
}
