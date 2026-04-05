#!/usr/bin/env bash
# =============================================================================
# Install Paperclip — Governance OS
# Pulls the Docker image and validates configuration files.
# =============================================================================
set -euo pipefail

echo "==> Pulling Paperclip image..."
docker pull paperclipai/paperclip:1.4.2

echo "==> Validating company configuration..."
if [ ! -f config/paperclip/company.json ]; then
  echo "ERROR: config/paperclip/company.json not found."
  exit 1
fi

if [ ! -f config/paperclip/agents.json ]; then
  echo "ERROR: config/paperclip/agents.json not found."
  exit 1
fi

if [ ! -f config/paperclip/routines.json ]; then
  echo "ERROR: config/paperclip/routines.json not found."
  exit 1
fi

echo "==> Paperclip ready. Will start with 'make start'."
