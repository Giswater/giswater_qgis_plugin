#!/usr/bin/env bash
# Run one pgTAP group (TEST_GROUPS=schema|security|function|data|performance|all).
set -euo pipefail
shopt -s nullglob

# shellcheck source=_env_inner.sh
_TEST_ROOT="${GW_TEST_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
source "${_TEST_ROOT}/_env_inner.sh" "${1:?Usage: prove_inner.sh ws|ud}"

if [[ -f "${STAGING_MARKER}" ]]; then
  TEST_STAGING="$(cat "${STAGING_MARKER}")"
else
  echo "==> no staging marker; running replace_vars"
  TEST_STAGING="$(python3 "${SCRIPT_DIR}/replace_vars.py" "${PROJECT}")"
fi

run_pg_prove() {
  local label="$1"
  shift
  if [[ "$#" -eq 0 ]]; then
    echo "==> pg_prove ${label}: no files, skip"
    return 0
  fi
  # function/data mutate shared schema — parallel pg_prove (-j>1) causes deadlocks
  local jobs="${PG_PROVE_JOBS}"
  if [[ "${label}" == "FUNCTION" || "${label}" == "DATA" ]]; then
    jobs=1
  fi
  echo "==> pg_prove ${label} (-j ${jobs})"
  pg_prove -h 127.0.0.1 -p 5432 -U postgres -d gw_db -j "${jobs}" "$@"
}

EXIT_CODE=0

case "${TEST_GROUPS}" in
  all)
    run_pg_prove SCHEMA \
      "${TEST_STAGING}"/schema/tables/*.sql \
      "${TEST_STAGING}"/schema/views/*.sql || EXIT_CODE=1
    run_pg_prove SECURITY "${TEST_STAGING}"/security/*.sql || EXIT_CODE=1
    run_pg_prove FUNCTION "${TEST_STAGING}"/function/*.sql || EXIT_CODE=1
    run_pg_prove DATA "${TEST_STAGING}"/data/*.sql || EXIT_CODE=1
    run_pg_prove PERFORMANCE "${TEST_STAGING}"/performance/*.sql || EXIT_CODE=1
    ;;
  schema)
    run_pg_prove SCHEMA \
      "${TEST_STAGING}"/schema/tables/*.sql \
      "${TEST_STAGING}"/schema/views/*.sql || EXIT_CODE=1
    ;;
  security)
    run_pg_prove SECURITY "${TEST_STAGING}"/security/*.sql || EXIT_CODE=1
    ;;
  function)
    run_pg_prove FUNCTION "${TEST_STAGING}"/function/*.sql || EXIT_CODE=1
    ;;
  data)
    run_pg_prove DATA "${TEST_STAGING}"/data/*.sql || EXIT_CODE=1
    ;;
  performance)
    run_pg_prove PERFORMANCE "${TEST_STAGING}"/performance/*.sql || EXIT_CODE=1
    ;;
  *)
    echo "error: unknown TEST_GROUPS=${TEST_GROUPS}" >&2
    exit 1
    ;;
esac

if [[ "${EXIT_CODE}" -eq 0 ]]; then
  echo "==> pg_prove ${TEST_GROUPS} passed."
else
  echo "==> pg_prove ${TEST_GROUPS} failed."
fi

exit "${EXIT_CODE}"
