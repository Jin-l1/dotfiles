#!/usr/bin/env bash
set -euo pipefail

REMOTE_HOST="${REMOTE_HOST:-admin@ms-raspberrypi.local}"
REMOTE_PORT="${REMOTE_PORT:-19020}"
REMOTE_CTL="jlink-rmt"

usage() {
  cat <<EOF
Usage:
  jlink-pi setup-ssh
  jlink-pi revoke-ssh
  jlink-pi ip
  jlink-pi start [PORT]
  jlink-pi stop
  jlink-pi restart [PORT]
  jlink-pi status
  jlink-pi logs

Environment:
  REMOTE_HOST   SSH target (default: admin@ms-raspberrypi.local)
  REMOTE_PORT   Default J-Link Remote Server port (default: 19020)

Examples:
  jlink-pi start 19020
  jlink-pi status
  jlink-pi ip
EOF
}

ssh_run() {
  ssh "${REMOTE_HOST}" "$@"
}

resolve_ip() {
  echo "SSH self-report from host:"
  ssh_run 'ip -o -4 addr show up | awk "{print \$2, \$4}"'
}

setup_ssh_key() {
  local remote_host="${REMOTE_HOST}"

  local local_host local_user safe_host key comment ssh_config host_alias
  local_host="$(hostname -s 2>/dev/null || hostname)"
  local_user="${USER:-$(id -un)}"
  safe_host="$(printf '%s' "${local_host}" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9._-' '-')"

  host_alias="jlink-pi-${safe_host}"
  key="${SSH_KEY_PATH:-$HOME/.ssh/${host_alias}_ed25519}"
  comment="${local_user}@${local_host}-jlink-pi"

  echo "Setting up SSH key for ${remote_host}"
  echo "Local machine: ${local_host}"
  echo "Key file: ${key}"

  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  if [[ ! -f "${key}" ]]; then
    echo "Generating SSH key..."
    ssh-keygen -t ed25519 -f "${key}" -C "${comment}" -N ""
  else
    echo "SSH key already exists: ${key}"
  fi

  if command -v ssh-copy-id >/dev/null 2>&1; then
    echo "Installing public key with ssh-copy-id..."
    ssh-copy-id -i "${key}.pub" "${remote_host}"
  else
    echo "ssh-copy-id not found, using manual install..."
    cat "${key}.pub" | ssh "${remote_host}" \
      'umask 077; mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && cat >> ~/.ssh/authorized_keys'
  fi

  ssh_config="$HOME/.ssh/config"
  if [[ ! -f "${ssh_config}" ]]; then
    touch "${ssh_config}"
    chmod 600 "${ssh_config}"
  fi

  if ! grep -q "^Host ${host_alias}$" "${ssh_config}" 2>/dev/null; then
    cat >> "${ssh_config}" <<EOF

Host ${host_alias}
  HostName ${remote_host#*@}
  User ${remote_host%@*}
  IdentityFile ${key}
  AddKeysToAgent yes
  UseKeychain yes
EOF
    echo "Added SSH config entry: ${host_alias}"
  else
    echo "SSH config entry already exists: ${host_alias}"
  fi

  echo
  echo "Done."
  echo "You can now test with:"
  echo "  ssh ${host_alias}"
}

revoke_ssh_key() {
  local keys=( $HOME/.ssh/jlink-pi-*_ed25519 )
  if ((${#keys[@]} == 0)); then
    echo "No J-Link SSH keys found to revoke." >&2
    return
  elif ((${#keys[@]} > 1)); then
    echo "Multiple J-Link SSH keys found, you need to manually revoke the desired key." >&2
    exit 1
  fi

  local key="${keys}"
  local host_alias="$(basename ${key%_*})"

  echo "Revoking SSH key for ${REMOTE_HOST}"
  timeout 10 ssh "${REMOTE_HOST}" "sed -i.bak '/${host_alias}/d' ~/.ssh/authorized_keys"
  [ $? -ne 0 ] && echo "Warning: Failed to remove key from remote host, it may still be authorized." >&2

  echo "Removing local config and key files..."
  sed -i '' '/^Host ${host_alias}/,/^Host /d' config
  rm -f "${key}" "${key}.pub"
  echo "Done."
}

setup_pi() {
  echo "Setting up J-Link Remote Server on ${REMOTE_HOST}"
  local password
  read -rsp "Pi sudo password: " password
  echo

  if ! printf '%s\n' "$password" | ssh "${REMOTE_HOST}" "sudo -k -S -p '' -v"; then
    echo "Incorrect sudo password" >&2
    exit 1
  fi

  bin_path="/usr/local/bin"

  echo ">> Installing J-Link..."
  {
    printf '%s\n' "$password"
    cat jlink_pi/jlink_linux_setup.sh
  } | ssh "${REMOTE_HOST}" "sudo -k -S -p '' bash -s --"

  echo ">> Creating remote control script..."
  {
    printf '%s\n' "$password"
    cat jlink_pi/jlink-rmt
  } | ssh "${REMOTE_HOST}" "sudo -k -S -p '' sh -c 'cat > ${bin_path}/jlink-rmt && chmod 755 ${bin_path}/jlink-rmt'"
  echo "Done"
}

case "${1:-}" in
  setup-pi)
    setup_pi
    ;;
  setup-ssh)
    setup_ssh_key
    ;;
  revoke-ssh)
    revoke_ssh_key
    ;;
  start)
    shift
    port="${1:-$REMOTE_PORT}"
    ssh_run "${REMOTE_CTL} start ${port}"
    ;;
  stop)
    ssh_run "${REMOTE_CTL} stop"
    ;;
  restart)
    shift || true
    port="${1:-$REMOTE_PORT}"
    ssh_run "${REMOTE_CTL} restart ${port}"
    ;;
  status)
    ssh_run "${REMOTE_CTL} status"
    ;;
  logs)
    ssh -t "${REMOTE_HOST}" "${REMOTE_CTL} logs"
    ;;
  ip)
    resolve_ip
    ;;
  *)
    usage
    exit 2
    ;;
esac
