#!/usr/bin/env bash
set -euo pipefail
pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" /docker-entrypoint-initdb.d/10-gw_ws.dump
