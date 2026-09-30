#!/usr/bin/env bash
# Dump all databases to /backups with timestamp. Run via compose profile "tools".
set -euo pipefail
STAMP="$(date +%F-%H%M)"
mkdir -p /backups
mariadb-dump -h db -u root --all-databases | gzip > "/backups/full-${STAMP}.sql.gz"
ls -lh /backups | tail -5
echo "Backup done: /backups/full-${STAMP}.sql.gz"
