#!/usr/bin/env bash
set -euo pipefail

# Restore roles/privileges if globals exist, then restore DB dump.
if [ -f /docker-entrypoint-initdb.d/00-gw_globals.sql ]; then
  psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d postgres /docker-entrypoint-initdb.d/00-gw_globals.sql
fi

# Skip topology schema managed by PostGIS to avoid conflict with existing extension.
pg_restore \
  --exclude-schema=topology \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB" \
  /docker-entrypoint-initdb.d/10-gw_ws.dump
