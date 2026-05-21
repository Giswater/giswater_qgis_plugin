#!/usr/bin/env bash
# Host orchestrator: Postgres in Docker, bootstrap + pg_prove in runner (no host port).
# Usage: ./test/run_tests.sh ws|ud
#   PG_MAJOR=16|17|18
#   TEST_GROUPS=all|schema|security|function|data|performance
#   PG_PROVE_JOBS=4
#   GW_CLEAN=1          remove volumes on exit
#   GW_DUMP_PATH=...    write pg_dump (path under /workspace in CI, e.g. dbmodel/gw_ws.dump)
#   GW_VERBOSE=1        per-file SQL paths on stderr (-v)
#   GW_TIMING=1         phase/file timings; with GW_VERBOSE, ms on each line
#   GW_TIMING_TOP=30    slowest files in summary (default 20)
#   GW_DEBUG=1          verbose + SQL preview (-d)
#   GW_PROFILE_LASTPROCESS=1  gw_fct_admin_schema_lastprocess step timings
set -euo pipefail

PROJECT="${1:?Usage: $0 ws|ud}"
PG_MAJOR="${PG_MAJOR:-16}"
TEST_GROUPS="${TEST_GROUPS:-all}"
PG_PROVE_JOBS="${PG_PROVE_JOBS:-4}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DBMODEL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

case "${PG_MAJOR}" in
  18) POSTGIS_VERSION="${POSTGIS_VERSION:-3.6}" ;;
  *)  POSTGIS_VERSION="${POSTGIS_VERSION:-3.5}" ;;
esac

export PG_MAJOR POSTGIS_VERSION TEST_GROUPS PG_PROVE_JOBS GW_DUMP_PATH="${GW_DUMP_PATH:-}"
export GW_VERBOSE="${GW_VERBOSE:-}" GW_DEBUG="${GW_DEBUG:-}" GW_TIMING="${GW_TIMING:-}"
export GW_TIMING_TOP="${GW_TIMING_TOP:-}" GW_TIMING_THRESHOLD_MS="${GW_TIMING_THRESHOLD_MS:-}"
export GW_TIMING_DETAIL="${GW_TIMING_DETAIL:-}"
export GW_PROFILE_LASTPROCESS="${GW_PROFILE_LASTPROCESS:-}" GW_PROFILE_SUMMARY="${GW_PROFILE_SUMMARY:-}"
export GW_SCHEMA_DUMP="${GW_SCHEMA_DUMP:-}"

cd "${DBMODEL_DIR}"

if command -v lsof >/dev/null 2>&1 && lsof -i ":55432" -sTCP:LISTEN -t >/dev/null 2>&1; then
  echo "WARN: something listens on host port 55432 (legacy local Postgres?)." >&2
  echo "      Tests use Docker internal network only; use GW_CLEAN=1 if runs fail." >&2
fi

chmod +x "${SCRIPT_DIR}"/*.sh

echo "==> PostgreSQL ${PG_MAJOR} (PostGIS ${POSTGIS_VERSION}) project ${PROJECT}"
docker compose -f docker-compose.test.yml build --quiet postgres runner

docker compose -f docker-compose.test.yml up -d postgres --wait

EXIT_CODE=0
docker compose -f docker-compose.test.yml run --rm -T runner \
  bash /workspace/dbmodel/test/run_tests_inner.sh "${PROJECT}" || EXIT_CODE=$?

if [[ -n "${GW_CLEAN:-}" ]]; then
  docker compose -f docker-compose.test.yml down -v
else
  docker compose -f docker-compose.test.yml down
fi

exit "${EXIT_CODE}"
