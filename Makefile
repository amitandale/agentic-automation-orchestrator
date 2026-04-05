install:
	bash install/vps-bootstrap.sh

start:
	docker-compose up -d

stop:
	docker-compose down

test-e2e:
	@echo 'Running e2e staging tests'

restore:
	bash scripts/restore.sh
