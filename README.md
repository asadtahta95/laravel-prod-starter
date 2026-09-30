# Laravel Prod Starter

Production-ready **Laravel (PHP 8.3-FPM + Nginx + MariaDB 11 + Redis + queue + scheduler + backups)** in one Compose file. Upgrades the old `Docker_Compose_Laravel` (dev-only, hardcoded passwords, `latest` tags) into a deployable starter.

## Architecture

```
client -> web (nginx:1.27) -> app (php:8.3-fpm, extensions + opcache)
app -> db (mariadb:11.4, healthchecked volume) + redis:7 (AOF + password)
queue worker + scheduler run as separate containers from the same PHP image
backup runs on demand via compose profile "tools"
```

## Structure

```
laravel-prod-starter/
├── docker-compose.yml
├── .env.example
├── php/Dockerfile + opcache.ini
├── nginx/default.conf
├── src/                  # put your Laravel app here
├── scripts/deploy.sh     # composer install + migrate + caches
├── scripts/backup-db.sh  # timestamped mariadb-dump
└── Makefile
```

## Quick Installation (One Line setup)

```bash
git clone https://github.com/asadtahta95/laravel-prod-starter.git && cd laravel-prod-starter && make up
```

Then put your code in `./src` (or clone your app there), and deploy:

```bash
cp .env.example .env
vim .env   # set DB_PASS, DB_ROOT_PASS, REDIS_PASS
make up
make deploy
open http://localhost:8080
```

Backup and restore:

```bash
make backup
ls backups/
gunzip -c backups/full-YYYY-MM-DD-HHMM.sql.gz | docker compose exec -T db mariadb -uroot -p"$DB_ROOT_PASS"
```

Behind TLS: point your `reverse-proxy-lab` Traefik/NPM at `http://<host>:8080`.

## What changed from the old repo

1. **Pinned versions:** `mariadb:latest` + `phpmyadmin` + unpinned PHP -> `mariadb:11.4`, `php:8.3-fpm-alpine`, `nginx:1.27-alpine`, `redis:7-alpine`.
2. **No hardcoded secrets:** `testdock/passdock` in compose -> required `DB_PASS`/`DB_ROOT_PASS`/`REDIS_PASS` via `.env` (fail-fast `:?`).
3. **Portable volume:** absolute `/var/www/html` host mount -> relative `./src`.
4. **Removed `links` + `version`:** deprecated keys dropped; `depends_on` with `service_healthy` for MariaDB.
5. **Added prod pieces missing before:** opcache, queue worker, scheduler, Redis with password+AOF, healthcheck, backup sidecar, `deploy.sh`.
6. Added `Makefile`, `.env.example`, CI compose validation.

## Security notes

- Never commit `.env` or `backups/*.gz`.
- Change all `change-me-*` passwords before first `up`.
- Do not expose MariaDB (no published 3306) or phpMyAdmin in production — removed by design.

## License

MIT
