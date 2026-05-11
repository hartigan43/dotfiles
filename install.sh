#!/usr/bin/env bash
set -euo pipefail

# do not allow run as root - thanks @freekingdean
if [ "${EUID}" -eq 0 ]; then
  echo "This script should not be run as root!"
  exit 1
fi

# configuration variables
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${SCRIPT_DIR}"
HELPER_DIR="${DOTFILES_DIR}/helper_scripts"

# Log functions
log() {
  printf '\n==> %s\n' "$*"
}

warn() {
  printf 'WARN: %s\n' "$*" >&2
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

# Install specific helper functions
require_file() {
  local path="$1"
  [[ -f "$path" ]] || die "Required file not found: $path"
}

require_dir() {
  local path="$1"
  [[ -d "$path" ]] || die "Required directory not found: $path"
}

require_function() {
  local fn="$1"
  declare -F "$fn" >/dev/null || die "Required function not loaded: $fn"
}
run_required() {
  log "$*"
  "$@"
}

run_optional() {
  log "$*"
  if ! "$@"; then
    warn "Optional step failed: $*"
    return 0
  fi
}

backup_path() {
  local path="$1"
  local stamp backup n=1

  if [[ ! -e "$path" && ! -L "$path" ]]; then
    printf 'Skipping %s (does not exist)\n' "$path"
    return 0
  fi

  # Skip symlinks already managed by this dotfiles repo to avoid clobbering dotter-managed files
  if [[ -L "$path" && "$(realpath "$path")" == "${DOTFILES_DIR}/"* ]]; then
    printf 'Skipping %s (already a managed dotfiles symlink)\n' "$path"
    return 0
  fi

  stamp="$(date +%Y%m%d)"
  backup="${path}.bak.${stamp}"

  while [[ -e "$backup" || -L "$backup" ]]; do
    backup="${path}.bak.${stamp}.${n}"
    n=$((n + 1))
  done

  printf 'Backing up %s -> %s\n' "$path" "$backup"
  mv "$path" "$backup"
}

# renames files in the supplied path to their original name appended with ".bak" and timestamp
ensure_backup() {
  local path
  for path in "$@"; do
    backup_path "$path"
  done
}

# TODO improve with realpath detection?
# command -v realpath >/dev/null 2>&1 || die "realpath is required"
ensure_symlink() {
  local src="$1"
  local dest="$2"

  [[ -e "$src" || -L "$src" ]] || die "Symlink source does not exist: $src"

  if [[ -L "$dest" && -e "$dest" ]]; then
    if [[ "$(realpath "$dest")" == "$(realpath "$src")" ]]; then
      printf 'Skipping %s (already correct symlink)\n' "$dest"
      return 0
    fi
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    backup_path "$dest"
  fi

  printf 'Linking %s -> %s\n' "$dest" "$src"
  ln -s "$src" "$dest"
}

# Set real username
set_real_name() {
  local real_name
  printf 'Please enter your real name, for your user account. ex: John Doe:\n'
  read -r real_name
  sudo usermod -c "$real_name" "$(whoami)"
}

require_dir "$DOTFILES_DIR"
require_dir "$HELPER_DIR"

require_file "${HELPER_DIR}/alacritty_themes.sh"
require_file "${HELPER_DIR}/confirm.sh"
require_file "${HELPER_DIR}/mise_install.sh"
require_file "${HELPER_DIR}/nerdfonts_install.sh"
require_file "${HELPER_DIR}/rust_install.sh"
require_file "${HELPER_DIR}/zcomet_install.sh"

# make workspace and misc
mkdir -p "${HOME}/Workspace/misc"

#### PLATFORM AND PACKAGES ####
PLATFORM="$(uname)"
if [[ "$PLATFORM" == "Linux" ]]; then
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    PLATFORM="$ID"
  fi
fi

# EDITOR="${EDITOR:-$(command -v vim)}"

# load confirm function for optional prompting
. "${HELPER_DIR}/confirm.sh"
require_function confirm

if ! confirm "proceed with bootstrap on $PLATFORM"; then
  exit 1
fi

# Defaults for installation
NEEDS_SUDO=true
PACKAGER_BIN=""
PACKAGER_FLAGS=()
PACKAGER_UPDATE=()
PACKAGER_UPGRADE=()
PACKAGER_INSTALL=()
PACKAGES=(
  curl git go neovim openssh podman ruby tmux tree vim wget zsh
)

case "$PLATFORM" in
  centos)
    PACKAGER_BIN="yum"
    PACKAGER_FLAGS=(-y)
    PACKAGER_UPDATE=(update)
    PACKAGER_UPGRADE=(upgrade)
    PACKAGER_INSTALL=(install)
    PACKAGES+=(python3 python3-pip openssl-devel readline-devel zlib-devel)
    ;;

  debian|ubuntu)
    PACKAGER_BIN="apt-get"
    PACKAGER_FLAGS=(-y)
    PACKAGER_UPDATE=(update)
    PACKAGER_UPGRADE=(upgrade)
    PACKAGER_INSTALL=(install)
    PACKAGES+=(python3 python3-pip libssl-dev libreadline-dev zlib1g-dev)
    ;;

  fedora)
    PACKAGER_BIN="dnf"
    PACKAGER_FLAGS=(-y)
    PACKAGER_UPDATE=(update)
    PACKAGER_UPGRADE=(upgrade)
    PACKAGER_INSTALL=(install)
    PACKAGES+=(openssl-devel python3 python3-pip readline-devel zlib-devel)
    ;;

  arch|archarm)
    PACKAGER_BIN="pacman"
    PACKAGER_FLAGS=(--noconfirm)
    PACKAGER_UPDATE=(-Sy)
    PACKAGER_UPGRADE=(-Syu)
    PACKAGER_INSTALL=(-S)
    PACKAGES+=(base-devel bat cmake fd python python-pip python-pynvim)
    ;;

  Darwin)
    PACKAGER_BIN="brew"
    PACKAGER_FLAGS=()
    PACKAGER_UPDATE=(update)
    PACKAGER_UPGRADE=(upgrade)
    PACKAGER_INSTALL=(install)
    NEEDS_SUDO=false
    PACKAGES+=(ccat glances gnupg htop infracost pygments telnet watch wget)
    if ! command -v brew >/dev/null 2>&1; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    ;;

  *)
    echo "platform '$PLATFORM' is not supported"
    exit 1
    ;;
esac

SUDO=()
if [[ "$NEEDS_SUDO" == true ]]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO=(sudo)
  else
    warn "sudo not found; package manager will run as the current user and may fail"
  fi
fi

run_packager() {
  "${SUDO[@]}" "$PACKAGER_BIN" "${PACKAGER_FLAGS[@]}" "$@"
}

# Update and install provided packages
echo "Running package list update..."
run_required run_packager "${PACKAGER_UPDATE[@]}"

if confirm "run a full system upgrade (may be slow on re-runs)"; then
  echo "Running upgrade..."
  run_required run_packager "${PACKAGER_UPGRADE[@]}"
fi

echo "Installing packages..."
run_required run_packager "${PACKAGER_INSTALL[@]}" "${PACKAGES[@]}"

# Get mise and zcomet installed
echo "Creating a local binary directory within homedir..."
mkdir -p "${HOME}/.local/bin"

. "${HELPER_DIR}/zcomet_install.sh"
require_function zcomet_install
run_required zcomet_install

. "${HELPER_DIR}/mise_install.sh"
require_function mise_install
run_required mise_install

# Symlink vimrc, zshrc and aliases/functions
printf 'Backing up existing config files...\n'
#backup any original config files
ensure_backup \
  "${HOME}/.bashrc" \
  "${HOME}/.bash_profile" \
  "${HOME}/.zshrc" \
  "${HOME}/.zprofile"

# vim/nvim, config directories
mkdir -p "${HOME}/.config/vim" \
  "${HOME}/.vim/colors" \
  "${HOME}/.config/alacritty/themes" \
  "${HOME}/.config/mise" \
  "${HOME}/.config/nvim/colors"

# Manually link mise config so mise can install tools (including dotter) before dotter itself runs.
# Once dotter has run, it manages ~/.config/mise as a directory symlink; skip to avoid conflicts.
if [[ -L "${HOME}/.config/mise" ]]; then
  printf 'Skipping mise config symlink (already managed by dotter)\n'
else
  run_required ensure_symlink "${DOTFILES_DIR}/config/mise/config.toml" "${HOME}/.config/mise/config.toml"
fi

# TODO make configurable path and as a helper script function?  These paths map to configured path in common.sh/zshrc
# TODO these vars are necessary outside the rust install as we pass the path to the mise install command
. "${HELPER_DIR}/rust_install.sh"
require_function rust_install
run_required rust_install

#export RUSTUP_HOME="${HOME}/.local/share/rust/rustup"
#export CARGO_HOME="${HOME}/.local/share/rust/cargo"
#
#mkdir -p "$RUSTUP_HOME" "$CARGO_HOME"
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path

if [[ "${PLATFORM}" != "Darwin" ]] ; then
  if confirm "set current user's real name"; then
    run_optional set_real_name
  fi
fi

if confirm "install NERDFonts"; then
  # shellcheck source=/dev/null
  . "${HELPER_DIR}/nerdfonts_install.sh"
  require_function nerd_fonts_install
  run_optional nerd_fonts_install
fi

if confirm "install alacritty themes"; then
  # shellcheck source=/dev/null
  . "${HELPER_DIR}/alacritty_themes.sh"
  require_function alacritty_themes_install
  run_optional alacritty_themes_install
fi

printf '\nWrapping up... Running mise install and then dotter deploy\n'

if [[ ! -f .dotter/local.toml ]]; then
  if [[ "$PLATFORM" == "Linux" ]]; then
    cp misc/dotter_linux.toml .dotter/local.toml
  else
    cp misc/dotter_mac.toml .dotter/local.toml
  fi

  printf 'Enter your email for git/dotter config (leave blank to skip): '
  read -r dotter_email
  if [[ -n "$dotter_email" ]]; then
    if [[ "$PLATFORM" == "Linux" ]]; then
      # we still need two sed commands because BSD sed requires a separate argument to -i
      sed -i "s/email[[:space:]]*=[[:space:]]*\"\"/email = \"${dotter_email}\"/" .dotter/local.toml
    else
      sed -i '' "s/email[[:space:]]*=[[:space:]]*\"\"/email = \"${dotter_email}\"/" .dotter/local.toml
    fi
  fi
else
  printf '.dotter/local.toml already exists, skipping copy\n'
fi

# : -- do nothing no op that succeeds allowing us to run parameter expansion and set CARGO_HOME
# in the event rust install was skipped.  It should be exported before exiting the helper but this covers all cases
: "${CARGO_HOME:=${HOME}/.local/share/rust/cargo}"
PATH="$HOME/.local/bin:$CARGO_HOME/bin:$PATH" mise i && cd "${DOTFILES_DIR}" && mise x github:SuperCuber/dotter -- dotter deploy
