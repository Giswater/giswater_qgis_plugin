#!/usr/bin/env bash
# Create CI schema and test SQL staging (sources under test/ws|ud unchanged).
set -euo pipefail

# shellcheck source=_env_inner.sh
_TEST_ROOT="${GW_TEST_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
source "${_TEST_ROOT}/_env_inner.sh" "${1:?Usage: bootstrap_inner.sh ws|ud}"

echo "==> giswater_admin db init"
python3 -m giswater_admin db init --conn "${GW_CONN}" --dbmodel-path "${DBMODEL_DIR}" \
  --with-pgtap \
  ${GW_ADMIN_FLAGS[@]+"${GW_ADMIN_FLAGS[@]}"}

echo "==> drop schema ${SCHEMA} (if exists)"
python3 -m giswater_admin schema main drop --name "${SCHEMA}" --yes --cascade \
  --conn "${GW_CONN}" --dbmodel-path "${DBMODEL_DIR}" >/dev/null 2>&1 || true

echo "==> giswater_admin schema main create --profile ci (schema ${SCHEMA})"
python3 -m giswater_admin schema main create \
  --type "${PROJECT}" \
  --name "${SCHEMA}" \
  --profile ci \
  --srid 25831 \
  --locale en_US \
  --version "${GW_PLUGIN_VERSION}" \
  --conn "${GW_CONN}" \
  --dbmodel-path "${DBMODEL_DIR}" \
  ${GW_ADMIN_FLAGS[@]+"${GW_ADMIN_FLAGS[@]}"}

echo "==> replace_vars (staging under test/.run/)"
TEST_STAGING="$(python3 "${SCRIPT_DIR}/replace_vars.py" "${PROJECT}")"
mkdir -p "$(dirname "${STAGING_MARKER}")"
echo "${TEST_STAGING}" > "${STAGING_MARKER}"
echo "==> test staging: ${TEST_STAGING}"
