#!/usr/bin/env bash
# =============================================================================
# VPS Bootstrap — One-shot server provisioning for Ubuntu 24.04
# Run this once on a fresh Hetzner CX21 (2 vCPU, 4GB RAM) or equivalent.
# =============================================================================
set -euo pipefail

echo "==> [1/7] Updating system packages..."
sudo apt-get update -y && sudo apt-get upgrade -y

echo "==> [2/7] Installing Docker + Docker Compose..."
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$USER"

echo "==> [3/7] Installing Node.js 24 via NodeSource..."
curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pnpm@9.15.0

echo "==> [4/7] Installing Chromium + browser dependencies (for OpenClaw)..."
sudo apt-get install -y chromium-browser fonts-liberation libappindicator3-1 libasound2t64 \
  libatk-bridge2.0-0t64 libatk1.0-0t64 libcups2t64 libdbus-1-3 libdrm2 libgbm1 \
  libgtk-3-0t64 libnspr4 libnss3 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 \
  xdg-utils

echo "==> [5/7] Setting up Nginx + Certbot for HTTPS..."
sudo apt-get install -y nginx certbot python3-certbot-nginx
sudo systemctl enable nginx

echo "==> [6/7] Configuring firewall (UFW) + Fail2ban..."
sudo apt-get install -y fail2ban
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 3101/tcp   # Paperclip dashboard
sudo ufw --force enable
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

echo "==> [7/7] Creating directory structure..."
mkdir -p backups books pgdata qdrant_storage

echo ""
echo "============================================"
echo "  VPS bootstrap complete."
echo "  Log out and back in for Docker group."
echo "  Then run: make start"
echo "============================================"
