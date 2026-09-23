# In the event where my dumbass forgets the commands
#ansible-playbook -i inventory/inventory.ini main-playbook.yaml -K


# Update this shell script to check if bitwarden cli is installed, if it is:
# 1. Check if the user has logged into bw cli
# 2. If yes, obtain the target machine password directly from bw's vault
# 3. If no, prompt the user for target machine's password to fulfil the become parameter via the -K command

#SYNC!!!! bitwarden and then unlock the session for ansible to use required credentials
#!/usr/bin/env bash
set -e

echo "==> Syncing Bitwarden vault..."
bw sync

echo "==> Unlocking Bitwarden vault"
echo "    Enter your Bitwarden master password when prompted:"
export BW_SESSION=$(bw unlock --raw)

if [ -z "$BW_SESSION" ]; then
    echo "!! Failed to unlock Bitwarden vault. Aborting."
    exit 1
fi
echo "==> Bitwarden vault unlocked."

echo ""
echo "==> Running Ansible playbook"
echo "    Enter your sudo/become password when prompted:"
ansible-playbook -i inventory/hosts.ini playbooks/site.yaml -K

echo "==> Playbook run complete."