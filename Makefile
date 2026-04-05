.PHONY: bootstrap start stop restart status logs verify index-books warm-up backup restore export-company test-e2e update

# =============================================================================
# Infrastructure
# =============================================================================

bootstrap:
	@echo "==> Bootstrapping VPS..."
	bash install/vps-bootstrap.sh

install: bootstrap
	@echo "==> Installing all services..."
	bash install/install-paperclip.sh
	bash install/install-openclaw.sh
	bash install/install-hermes.sh
	bash install/install-qdrant.sh
	@echo "==> All services installed. Run 'make start' to launch."

start:
	docker compose -f docker-compose.yml up -d
	@echo "==> All services started."

stop:
	docker compose -f docker-compose.yml down
	@echo "==> All services stopped."

restart: stop start

status:
	@echo "==> Service health check..."
	bash install/verify.sh

verify: status

logs:
	docker compose -f docker-compose.yml logs -f --tail=100

# =============================================================================
# Data Operations
# =============================================================================

index-books:
	@echo "==> Indexing content into Qdrant..."
	npx tsx qdrant/index-books.ts

warm-up:
	@echo "==> Running account warm-up state machine..."
	npx tsx scripts/warm-up-accounts.ts

# =============================================================================
# Backup & Restore
# =============================================================================

backup:
	@echo "==> Backing up Postgres + Qdrant..."
	bash scripts/backup-db.sh

restore:
	@echo "==> Restoring from backup..."
	bash scripts/restore-db.sh

export-company:
	@echo "==> Exporting governance config..."
	bash scripts/export-company.sh

# =============================================================================
# Testing & Staging
# =============================================================================

test-e2e:
	@echo "==> Running E2E in dry-run mode (no actual submissions)..."
	DRY_RUN=true docker compose -f docker-compose.yml -f docker/docker-compose.dev.yml up -d
	@echo "==> Staging environment running. Browser flows will log instead of submit."
	@echo "==> Stop with: make stop"

# =============================================================================
# Maintenance
# =============================================================================

update:
	@echo "==> Pulling latest images..."
	docker compose -f docker-compose.yml pull
	docker compose -f docker-compose.yml up -d --build
	@echo "==> All services updated."
