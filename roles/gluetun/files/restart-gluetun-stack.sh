# This script restarts all containers that rely on gluetun. Used when gluetun requires re-composing.

cd /opt/containers/gluetun && docker compose down && docker compose up -d
cd /opt/containers/searxng && docker compose down && docker compose up -d
cd /opt/containers/wg-easy && docker compose down && docker compose up -d
cd /opt/containers/qbittorrent && docker compose down && docker compose up -d
