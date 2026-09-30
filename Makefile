.PHONY: help up down ps logs deploy backup check
help:
	@echo "make up | down | ps | logs | deploy | backup | check"

up:
	[ -f .env ] || cp .env.example .env
	docker compose up -d --build && docker compose ps

down:
	docker compose down

ps:
	docker compose ps

logs:
	docker compose logs -f --tail=100

deploy:
	bash scripts/deploy.sh

backup:
	docker compose --profile tools run --rm backup

check:
	docker compose config --quiet && echo "compose OK"
