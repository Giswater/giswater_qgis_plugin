#!/usr/bin/env bash
# Debug host -> Postgres (requires debug compose with published port).
set -euo pipefail

PORT="${GW_PUBLISH_PORT:-15432}"
CONN="postgresql://postgres:postgres@127.0.0.1:${PORT}/gw_db"

echo "==> Checking ${CONN}"
if ! psql "${CONN}" -v ON_ERROR_STOP=1 -tAc "SELECT 1" 2>/dev/null; then
  echo "FAIL: cannot connect. Start with:" >&2
  echo "  docker compose -f docker-compose.test.yml -f docker-compose.debug.yml up -d postgres" >&2
  echo "Or stop local Postgres on port ${PORT} (legacy CI used 55432)." >&2
  exit 1
fi

psql "${CONN}" -c "SELECT current_database(), inet_server_addr(), version();"
psql "postgresql://postgres:postgres@127.0.0.1:${PORT}/postgres" -tAc \
  "SELECT datname FROM pg_database WHERE datname = 'gw_db'"
