#!/usr/bin/env bash
set -euo pipefail

# ansible-playbook -i inventory/hosts.ini playbooks/site.yaml -K   (manual version)
# Usage: ./run.sh [extra ansible-playbook args, e.g. --tags traefik]

INVENTORY="inventory/hosts.ini"
PLAYBOOK="playbooks/site.yaml"
BECOME_ITEM="Hydaelyn Machine password"   # name of the Bitwarden item holding the sudo password

args=()

if command -v bw >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  status=$(bw status | jq -r .status)

  if [ "$status" = "unauthenticated" ]; then
    echo "!! Not logged in to Bitwarden (run 'bw login'). Falling back to -K."
    args+=(-K)
  else
    if [ "$status" = "locked" ]; then
      echo "==> Unlocking Bitwarden vault..."
      BW_SESSION=$(bw unlock --raw)
      export BW_SESSION
      [ -n "$BW_SESSION" ] || { echo "!! Unlock failed. Aborting."; exit 1; }
    fi

    echo "==> Syncing Bitwarden vault..."
    bw sync >/dev/null

    if pw=$(bw get password "$BECOME_ITEM" 2>/dev/null) && [ -n "$pw" ]; then
      echo "==> Using become password from Bitwarden."
      tmp=$(mktemp)
      chmod 600 "$tmp"
      trap 'rm -f "$tmp"' EXIT
      jq -n --arg p "$pw" '{ansible_become_password: $p}' > "$tmp"
      args+=(-e "@$tmp")
    else
      echo "!! Item '$BECOME_ITEM' not found. Falling back to -K."
      args+=(-K)
    fi
  fi
else
  echo "!! bw or jq not installed. Falling back to -K."
  args+=(-K)
fi

echo "==> Running Ansible playbook"
ansible-playbook -i "$INVENTORY" "$PLAYBOOK" "${args[@]}" "$@"
echo "==> Playbook run complete."