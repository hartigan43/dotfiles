# this script shell-agnostic and intended to be sourced, not executed directly

# TODO own script?
read_with_default() {
  local var_name=$1
  local current=$2

  if [[ "${NON_INTERACTIVE:-false}" == "true" ]]; then
    printf '%s\n' "$current"
    return 0
  fi

  printf "Enter a value for %s [%s]: " "$var_name" "$current" >&2
  read -r input
  printf '%s\n' "${input:-$current}"
}

rust_install() {
  local default_rustup_home="${HOME}/.local/share/rust/rustup"
  local default_cargo_home="${HOME}/.local/share/rust/cargo"

  export RUSTUP_HOME="$(read_with_default RUSTUP_HOME "${default_rustup_home}")"
  export CARGO_HOME="$(read_with_default CARGO_HOME "${default_cargo_home}")"

  if [[ -x "${CARGO_HOME}/bin/rustup" ]] || command -v rustup >/dev/null 2>&1; then
    printf 'Skipping rustup install (already installed)\n'
    return 0
  fi

  mkdir -p "${RUSTUP_HOME}" "${CARGO_HOME}"
  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path
}
