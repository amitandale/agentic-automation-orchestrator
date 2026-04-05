#!/usr/bin/env bash
# =============================================================================
# Install OpenClaw — Browser Automation Agent
# =============================================================================
set -euo pipefail

echo "==> Pulling OpenClaw image..."
docker pull openclaw/openclaw:0.9.7

echo "==> Validating OpenClaw config..."
if [ ! -f config/openclaw/openclaw.json ]; then
  echo "ERROR: config/openclaw/openclaw.json not found."
  exit 1
fi

echo "==> Checking browser dependencies..."
if ! command -v chromium-browser &> /dev/null && ! command -v chromium &> /dev/null; then
  echo "WARNING: Chromium not found. Run 'make bootstrap' first."
fi

echo "==> OpenClaw ready. Will start with 'make start'."
