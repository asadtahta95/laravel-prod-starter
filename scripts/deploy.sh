#!/usr/bin/env bash
# First deploy / update: install deps, migrate, cache config.
set -euo pipefail
docker compose exec app composer install --no-dev --optimize-autoloader
docker compose exec app php artisan migrate --force
docker compose exec app php artisan config:cache
docker compose exec app php artisan route:cache
docker compose exec app php artisan view:cache
echo "Deploy done."
