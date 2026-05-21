#!/usr/bin/env bash
# Runs inside the test runner container (shares postgres network namespace).
set -euo pipefail
shopt -s nullglob

PROJECT="${1:?Usage: run_tests_inner.sh ws|ud}"
TEST_GROUPS="${TEST_GROUPS:-all}"
PG_PROVE_JOBS="${PG_PROVE_JOBS:-4}"
SCHEMA="${PROJECT}_40"
GW_CONN="${GW_CONN:-postgresql://postgres:postgres@127.0.0.1:5432/gw_db}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DBMODEL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${DBMODEL_DIR}/.." && pwd)"

export PYTHONPATH="${REPO_ROOT}${PYTHONPATH:+:${PYTHONPATH}}"
export PGPASSWORD=postgres

cd "${DBMODEL_DIR}"

python3 -m pip install -q -r "${REPO_ROOT}/giswater_admin/requirements.txt"

GW_PLUGIN_VERSION="$(python3 "${SCRIPT_DIR}/plugin_version.py")"
echo "==> plugin-version ${GW_PLUGIN_VERSION}"
echo "==> database gw_db via ${GW_CONN}"

# giswater_admin global flags (stderr progress + timing). Examples:
#   GW_VERBOSE=1 GW_TIMING=1 ./test/run_tests.sh ws
#   GW_VERBOSE=1 GW_TIMING=1 GW_TIMING_TOP=50 GW_PROFILE_LASTPROCESS=1 ./test/run_tests.sh ws
#   GW_DEBUG=1  # verbose + SQL preview in logs
GW_ADMIN_FLAGS=()
[[ -n "${GW_VERBOSE:-}" ]] && GW_ADMIN_FLAGS+=(-v)
[[ -n "${GW_DEBUG:-}" ]] && GW_ADMIN_FLAGS+=(-d)
[[ -n "${GW_TIMING:-}" ]] && GW_ADMIN_FLAGS+=(--timing)
[[ -n "${GW_TIMING_TOP:-}" ]] && GW_ADMIN_FLAGS+=(--timing-top "${GW_TIMING_TOP}")
[[ -n "${GW_TIMING_THRESHOLD_MS:-}" ]] && GW_ADMIN_FLAGS+=(--timing-threshold-ms "${GW_TIMING_THRESHOLD_MS}")
[[ -n "${GW_TIMING_DETAIL:-}" ]] && GW_ADMIN_FLAGS+=(--timing-detail)
[[ -n "${GW_PROFILE_LASTPROCESS:-}" ]] && GW_ADMIN_FLAGS+=(--profile-lastprocess)
[[ -n "${GW_PROFILE_SUMMARY:-}" ]] && GW_ADMIN_FLAGS+=(--profile-summary)
if [[ ${#GW_ADMIN_FLAGS[@]} -gt 0 ]]; then
  echo "==> giswater_admin flags: ${GW_ADMIN_FLAGS[*]}"
fi

echo "==> giswater_admin init-db"
python3 -m giswater_admin init-db --conn "${GW_CONN}" --dbmodel-path "${DBMODEL_DIR}" \
  ${GW_ADMIN_FLAGS[@]+"${GW_ADMIN_FLAGS[@]}"}

echo "==> drop schema ${SCHEMA} (if exists)"
python3 -m giswater_admin drop --schema "${SCHEMA}" --yes --cascade \
  --conn "${GW_CONN}" --dbmodel-path "${DBMODEL_DIR}" >/dev/null 2>&1 || true

echo "==> giswater_admin create --profile ci (schema ${SCHEMA})"
python3 -m giswater_admin create \
  --kind "${PROJECT}" \
  --schema "${SCHEMA}" \
  --profile ci \
  --srid 25831 \
  --locale en_US \
  --plugin-version "${GW_PLUGIN_VERSION}" \
  --conn "${GW_CONN}" \
  --dbmodel-path "${DBMODEL_DIR}" \
  ${GW_ADMIN_FLAGS[@]+"${GW_ADMIN_FLAGS[@]}"}

echo "==> replace_vars (staging under test/.run/, sources unchanged)"
TEST_STAGING="$(python3 "${SCRIPT_DIR}/replace_vars.py" "${PROJECT}")"
echo "==> test staging: ${TEST_STAGING}"

run_pg_prove() {
  local label="$1"
  shift
  if [[ "$#" -eq 0 ]]; then
    return 0
  fi
  echo "==> pg_prove ${label}"
  pg_prove -h 127.0.0.1 -p 5432 -U postgres -d gw_db -j "${PG_PROVE_JOBS}" "$@" || return 1
}

EXIT_CODE=0

if [[ "${TEST_GROUPS}" == "all" || "${TEST_GROUPS}" == *"schema"* ]]; then
  run_pg_prove SCHEMA \
    "${TEST_STAGING}"/schema/tables/*.sql \
    "${TEST_STAGING}"/schema/views/*.sql || EXIT_CODE=1
fi

if [[ "${TEST_GROUPS}" == "all" || "${TEST_GROUPS}" == *"security"* ]]; then
  run_pg_prove SECURITY "${TEST_STAGING}"/security/*.sql || EXIT_CODE=1
fi

if [[ "${TEST_GROUPS}" == "all" || "${TEST_GROUPS}" == *"function"* ]]; then
  run_pg_prove FUNCTION "${TEST_STAGING}"/function/*.sql || EXIT_CODE=1
fi

if [[ "${TEST_GROUPS}" == "all" || "${TEST_GROUPS}" == *"data"* ]]; then
  run_pg_prove DATA "${TEST_STAGING}"/data/*.sql || EXIT_CODE=1
fi

if [[ "${TEST_GROUPS}" == "all" || "${TEST_GROUPS}" == *"performance"* ]]; then
  run_pg_prove PERFORMANCE "${TEST_STAGING}"/performance/*.sql || EXIT_CODE=1
fi

if [[ "${EXIT_CODE}" -eq 0 && -n "${GW_DUMP_PATH:-}" ]]; then
  echo "==> pg_dump schema ${SCHEMA} -> ${GW_DUMP_PATH}"
  mkdir -p "$(dirname "${GW_DUMP_PATH}")"
  pg_dump -h 127.0.0.1 -p 5432 -U postgres -n "${SCHEMA}" -Fc -f "${GW_DUMP_PATH}" gw_db
fi

if [[ "${EXIT_CODE}" -eq 0 ]]; then
  echo "==> All requested tests passed."
else
  echo "==> Some tests failed."
fi

exit "${EXIT_CODE}"
