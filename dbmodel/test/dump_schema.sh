#!/usr/bin/env bash
# Dump project schema to custom-format file (GW_DUMP_PATH or GW_SCHEMA_DUMP).
set -euo pipefail

# shellcheck source=_env_inner.sh
source "$(dirname "${BASH_SOURCE[0]}")/_env_inner.sh" "${1:?Usage: dump_schema.sh ws|ud}"

OUT="${GW_DUMP_PATH:-${GW_SCHEMA_DUMP:-}}"
if [[ -z "${OUT}" ]]; then
  echo "error: set GW_DUMP_PATH or GW_SCHEMA_DUMP" >&2
  exit 1
fi

mkdir -p "$(dirname "${OUT}")"
echo "==> pg_dump schema ${SCHEMA} -> ${OUT} ($(pg_dump --version))"
pg_dump -h 127.0.0.1 -p 5432 -U postgres -n "${SCHEMA}" -Fc -f "${OUT}" gw_db
