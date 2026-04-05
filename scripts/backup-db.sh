#!/usr/bin/env bash
# =============================================================================
# Backup — Postgres + Qdrant volume snapshot
# =============================================================================
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-./backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-30}"

mkdir -p "$BACKUP_DIR"

echo "==> Backing up Postgres..."
docker exec orchestrator-db pg_dump -U postgres orchestrator | gzip > "$BACKUP_DIR/postgres_${TIMESTAMP}.sql.gz"
echo "    ✓ Postgres backup: postgres_${TIMESTAMP}.sql.gz"

echo "==> Backing up Qdrant storage..."
tar -czf "$BACKUP_DIR/qdrant_${TIMESTAMP}.tar.gz" -C . qdrant_storage/
echo "    ✓ Qdrant backup: qdrant_${TIMESTAMP}.tar.gz"

echo "==> Backing up Paperclip company config..."
tar -czf "$BACKUP_DIR/config_${TIMESTAMP}.tar.gz" -C . config/paperclip/
echo "    ✓ Config backup: config_${TIMESTAMP}.tar.gz"

# Clean up old backups
echo "==> Cleaning backups older than ${RETENTION_DAYS} days..."
find "$BACKUP_DIR" -type f -name "*.gz" -mtime +${RETENTION_DAYS} -delete
echo "    ✓ Cleanup complete"

echo ""
echo "==> Backup complete. Files in $BACKUP_DIR:"
ls -lh "$BACKUP_DIR"/*_${TIMESTAMP}.*
