#!/usr/bin/env bash
# =============================================================================
# Verify — Health check all services
# =============================================================================
set -euo pipefail

PASS=0
FAIL=0

check_service() {
  local name="$1"
  local url="$2"
  if curl -sf --max-time 5 "$url" > /dev/null 2>&1; then
    echo "  ✓ $name is running"
    PASS=$((PASS + 1))
  else
    echo "  ✗ $name is NOT responding at $url"
    FAIL=$((FAIL + 1))
  fi
}

echo "==> Checking service health..."
echo ""

check_service "Paperclip API"      "http://localhost:3100/health"
check_service "Paperclip Dashboard" "http://localhost:3101"
check_service "OpenClaw"           "http://localhost:18789/health"
check_service "Hermes-Agent"       "http://localhost:4000/health"
check_service "Qdrant"             "http://localhost:6333/healthz"
check_service "Postgres"           "http://localhost:5432"

echo ""
echo "==> Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  echo "==> Some services are down. Check 'make logs' for details."
  exit 1
fi

echo "==> All services healthy."

# Cross-service connectivity checks
echo ""
echo "==> Checking inter-service connectivity..."
docker exec orchestrator-hermes curl -sf --max-time 5 http://qdrant:6333/healthz > /dev/null 2>&1 && \
  echo "  ✓ Hermes → Qdrant" || echo "  ✗ Hermes → Qdrant"

docker exec orchestrator-hermes curl -sf --max-time 5 http://paperclip:3100/health > /dev/null 2>&1 && \
  echo "  ✓ Hermes → Paperclip" || echo "  ✗ Hermes → Paperclip"

docker exec orchestrator-openclaw curl -sf --max-time 5 http://paperclip:3100/health > /dev/null 2>&1 && \
  echo "  ✓ OpenClaw → Paperclip" || echo "  ✗ OpenClaw → Paperclip"

echo ""
echo "==> Verification complete."
