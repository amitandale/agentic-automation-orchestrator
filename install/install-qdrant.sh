#!/usr/bin/env bash
# =============================================================================
# Install Qdrant — Vector Store
# =============================================================================
set -euo pipefail

echo "==> Pulling Qdrant image..."
docker pull qdrant/qdrant:1.12.1

echo "==> Creating storage directory..."
mkdir -p qdrant_storage

echo "==> Validating collection config..."
if [ ! -f qdrant/collections.json ]; then
  echo "WARNING: qdrant/collections.json not found. Default collections will be created at indexing time."
fi

echo "==> Qdrant ready. Will start with 'make start'."
