#!/usr/bin/env bash
# Host orchestrator: Postgres in Docker, E2E scenarios in runner.
# Usage: ./test/run_e2e.sh [scenario]
#   scenario: profiles|addons|update_isolated|update_network|update_all|satellites (default: update_all)
#   PG_MAJOR=16|17|18
#   SATELLITES=utils,cibs
#   PARENT_PROFILE=empty|sample|inventory
#   GW_CLEAN=1
set -euo pipefail

SCENARIO="${1:-update_all}"
PG_MAJOR="${PG_MAJOR:-18}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DBMODEL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

case "${PG_MAJOR}" in
  18) POSTGIS_VERSION="${POSTGIS_VERSION:-3.6}" ;;
  *)  POSTGIS_VERSION="${POSTGIS_VERSION:-3.5}" ;;
esac

export PG_MAJOR POSTGIS_VERSION
export SATELLITES="${SATELLITES:-utils,cibs}"
export PARENT_PROFILE="${PARENT_PROFILE:-empty}"
export GW_VERBOSE="${GW_VERBOSE:-}" GW_DEBUG="${GW_DEBUG:-}" GW_TIMING="${GW_TIMING:-}"
export GW_ADMIN_FLAGS="${GW_ADMIN_FLAGS:-}"

cd "${DBMODEL_DIR}"
chmod +x "${SCRIPT_DIR}"/*.sh
chmod +x "${DBMODEL_DIR}/../scripts"/*.sh 2>/dev/null || true

if [[ "${GW_COMPOSE:-}" == podman ]]; then
  COMPOSE=(podman compose)
elif [[ "${GW_COMPOSE:-}" == docker ]]; then
  COMPOSE=(docker compose)
elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1 \
    && ! docker version 2>/dev/null | grep -q 'Podman Engine'; then
  COMPOSE=(docker compose)
elif command -v podman >/dev/null 2>&1 && podman compose version >/dev/null 2>&1; then
  COMPOSE=(podman compose)
else
  echo "ERROR: need docker compose or podman compose" >&2
  exit 1
fi

compose() { "${COMPOSE[@]}" -f docker-compose.test.yml "$@"; }

echo "==> E2E scenario=${SCENARIO} PostgreSQL ${PG_MAJOR} (${COMPOSE[*]})"
compose build postgres runner

echo "==> starting postgres..."
if compose up --help 2>&1 | grep -qE '(^|[[:space:]])--wait([[:space:],]|$)'; then
  compose up -d postgres --wait
else
  compose up -d postgres
  for i in $(seq 1 120); do
    compose ps 2>/dev/null | grep -qE '\(healthy\)' && break
    if [[ "${i}" -eq 120 ]]; then
      echo "ERROR: postgres not healthy after 120s" >&2
      compose ps >&2 || true
      exit 1
    fi
    sleep 1
  done
fi

EXIT_CODE=0
if ! compose run --rm -T runner bash /workspace/dbmodel/test/e2e_inner.sh "${SCENARIO}"; then
  EXIT_CODE=$?
fi

if [[ -n "${GW_CLEAN:-}" ]]; then
  compose rm -sfv postgres >/dev/null 2>&1 || true
else
  compose stop postgres >/dev/null 2>&1 || true
fi

exit "${EXIT_CODE}"
