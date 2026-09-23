# Homelab Ansible Automation

Ansible automation for deploying and managing part of my homelab infrastructure. This is still in progress

## What this deploys

**Base setup**
- Common/base packages across all managed hosts
- Docker

**Container services** (deployed via Docker Compose, orchestrated through Ansible)
- AdGuard Home
- Forgejo
- Gluetun
- SearXNG

**Native package installs**
- MongoDB (installed via APT, not containerized)

## Secrets management

This project does **not** use `.env` files or plaintext variables for credentials.

Secrets (DB users/passwords, service credentials, etc.) are pulled at runtime from **Bitwarden**, via the `bw` CLI and the `community.general.bitwarden` Ansible lookup plugin. Nothing sensitive is stored in this repository, encrypted or otherwise.

## Structure

```
ansible/
├── inventory/
│   └── hosts.ini
├── playbooks/
│   └── site.yaml
└── roles/
    ├── mongodb/
    └── ...
```

## How to run

```bash
sudo chmod +x run_playbook.sh
./run_playbook.sh
```