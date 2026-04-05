#!/usr/bin/env bash
# =============================================================================
# Install Hermes-Agent — Reasoning Brain
# =============================================================================
set -euo pipefail

echo "==> Pulling Hermes-Agent image..."
docker pull nousresearch/hermes-agent:2.1.0

echo "==> Validating Hermes config..."
if [ ! -f config/hermes/system-prompt.md ]; then
  echo "ERROR: config/hermes/system-prompt.md not found."
  exit 1
fi

if [ ! -f config/hermes/models.json ]; then
  echo "ERROR: config/hermes/models.json not found."
  exit 1
fi

echo "==> Hermes-Agent ready. Will start with 'make start'."
