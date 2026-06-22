#!/usr/bin/env bash
# Bootstrap standalone addon schema for pgTAP (utils or cibs).
set -euo pipefail

# shellcheck source=_env_inner.sh
_TEST_ROOT="${GW_TEST_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
source "${_TEST_ROOT}/_env_inner.sh" "${1:?Usage: bootstrap_addon_inner.sh utils|cibs}"

export CONN="${GW_CONN}"

gw() {
  python3 -m giswater_admin "$@" \
    --dbmodel-path "${DBMODEL_DIR}" \
    --conn "${GW_CONN}" \
    ${GW_ADMIN_FLAGS[@]+"${GW_ADMIN_FLAGS[@]}"}
}

echo "==> giswater_admin db init"
gw db init --conn "${GW_CONN}" --with-pgtap

echo "==> drop addon schema ${SCHEMA}"
gw schema addon drop --type "${PROJECT}" --name "${SCHEMA}" --yes --cascade \
  --conn "${GW_CONN}" >/dev/null 2>&1 || true

echo "==> schema addon create --type ${PROJECT} --name ${SCHEMA}"
gw schema addon create \
  --type "${PROJECT}" \
  --name "${SCHEMA}" \
  --profile empty \
  --version "${GW_PLUGIN_VERSION}" \
  --conn "${GW_CONN}"

echo "==> replace_vars (staging under test/.run/)"
TEST_STAGING="$(python3 "${SCRIPT_DIR}/replace_vars.py" "${PROJECT}")"
mkdir -p "$(dirname "${STAGING_MARKER}")"
echo "${TEST_STAGING}" > "${STAGING_MARKER}"
echo "==> test staging: ${TEST_STAGING}"
