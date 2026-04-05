#!/usr/bin/env bash
# =============================================================================
# Export Company — Export Paperclip company config for backup/portability
# =============================================================================
set -euo pipefail

EXPORT_DIR="${1:-./exports}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$EXPORT_DIR"

echo "==> Exporting Paperclip company configuration..."

# Export config files
tar -czf "$EXPORT_DIR/company-config_${TIMESTAMP}.tar.gz" \
  config/paperclip/company.json \
  config/paperclip/agents.json \
  config/paperclip/routines.json

echo "    ✓ Config exported: company-config_${TIMESTAMP}.tar.gz"

# Export via Paperclip API if available
if curl -sf http://localhost:3100/health > /dev/null 2>&1; then
  echo "==> Exporting company state from Paperclip API..."
  curl -s http://localhost:3100/api/company/export > "$EXPORT_DIR/company-state_${TIMESTAMP}.json"
  echo "    ✓ State exported: company-state_${TIMESTAMP}.json"
else
  echo "    ⚠ Paperclip API not available — skipping state export"
fi

echo ""
echo "==> Export complete. Files in $EXPORT_DIR:"
ls -lh "$EXPORT_DIR"/*_${TIMESTAMP}.*
