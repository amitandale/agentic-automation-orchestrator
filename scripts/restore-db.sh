#!/usr/bin/env bash
# =============================================================================
# Restore — Recover Postgres + Qdrant from backup archive
# =============================================================================
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-./backups}"

echo "==> Available backups:"
echo ""
ls -lht "$BACKUP_DIR"/*.gz 2>/dev/null || { echo "  No backups found in $BACKUP_DIR"; exit 1; }
echo ""

# If a specific timestamp is provided, use it
if [ -n "${1:-}" ]; then
  TIMESTAMP="$1"
else
  # Find the latest backup timestamp
  TIMESTAMP=$(ls -t "$BACKUP_DIR"/postgres_*.sql.gz 2>/dev/null | head -1 | grep -oP '\d{8}_\d{6}')
  if [ -z "$TIMESTAMP" ]; then
    echo "ERROR: No Postgres backups found."
    exit 1
  fi
fi

echo "==> Restoring from timestamp: $TIMESTAMP"
echo ""

# Confirm
read -p "This will OVERWRITE current data. Continue? (y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Aborted."
  exit 0
fi

# Restore Postgres
PG_BACKUP="$BACKUP_DIR/postgres_${TIMESTAMP}.sql.gz"
if [ -f "$PG_BACKUP" ]; then
  echo "==> Restoring Postgres..."
  docker exec orchestrator-db dropdb -U postgres --if-exists orchestrator
  docker exec orchestrator-db createdb -U postgres orchestrator
  gunzip -c "$PG_BACKUP" | docker exec -i orchestrator-db psql -U postgres orchestrator
  echo "    ✓ Postgres restored"
else
  echo "    ⚠ Postgres backup not found: $PG_BACKUP"
fi

# Restore Qdrant
QDRANT_BACKUP="$BACKUP_DIR/qdrant_${TIMESTAMP}.tar.gz"
if [ -f "$QDRANT_BACKUP" ]; then
  echo "==> Restoring Qdrant storage..."
  docker compose stop qdrant
  rm -rf qdrant_storage/*
  tar -xzf "$QDRANT_BACKUP" -C .
  docker compose start qdrant
  echo "    ✓ Qdrant restored"
else
  echo "    ⚠ Qdrant backup not found: $QDRANT_BACKUP"
fi

# Restore config
CONFIG_BACKUP="$BACKUP_DIR/config_${TIMESTAMP}.tar.gz"
if [ -f "$CONFIG_BACKUP" ]; then
  echo "==> Restoring Paperclip config..."
  tar -xzf "$CONFIG_BACKUP" -C .
  echo "    ✓ Config restored"
else
  echo "    ⚠ Config backup not found: $CONFIG_BACKUP"
fi

echo ""
echo "==> Restore complete. Verify with: make verify"
