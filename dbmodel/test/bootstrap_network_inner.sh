#!/usr/bin/env bash
# Bootstrap integrated network (ws+ud+utils+cibs) for pgTAP network_* tests.
set -euo pipefail

# shellcheck source=_env_inner.sh
_TEST_ROOT="${GW_TEST_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
source "${_TEST_ROOT}/_env_inner.sh" "${1:?Usage: bootstrap_network_inner.sh network_ws|network_ud}"

export CONN="${GW_CONN}"
export WS="ws_40"
export UD="ud_40"
export UTILS="utils"
export CIBS="cibs"
export SATELLITES="${SATELLITES:-utils,cibs}"
export PARENT_PROFILE="${GW_PARENT_PROFILE:-empty}"

gw() {
  python3 -m giswater_admin "$@" \
    --dbmodel-path "${DBMODEL_DIR}" \
    --conn "${GW_CONN}" \
    ${GW_ADMIN_FLAGS[@]+"${GW_ADMIN_FLAGS[@]}"}
}

SCRIPTS="${REPO_ROOT}/scripts"

echo "==> db init (pgTAP)"
gw db init --conn "${GW_CONN}" --with-pgtap

echo "==> drop previous network (if any)"
SATELLITES="${SATELLITES}" WS="${WS}" UD="${UD}" \
  bash "${SCRIPTS}/gw_bootstrap_network.sh" --drop >/dev/null 2>&1 || true

echo "==> bootstrap integrated network (profile=${PARENT_PROFILE})"
SATELLITES="${SATELLITES}" PARENT_PROFILE="${PARENT_PROFILE}" WS="${WS}" UD="${UD}" \
  bash "${SCRIPTS}/gw_e2e_addons_integrate.sh"

if [[ ",${SATELLITES}," == *",cibs,"* ]]; then
  psql "${GW_CONN}" -v ON_ERROR_STOP=1 <<SQL
UPDATE ${WS}.config_param_system SET value = 'true' WHERE parameter = 'admin_cibs_schema';
UPDATE ${UD}.config_param_system SET value = 'true' WHERE parameter = 'admin_cibs_schema';
SQL
fi

echo "==> replace_vars (staging under test/.run/)"
TEST_STAGING="$(python3 "${SCRIPT_DIR}/replace_vars.py" "${PROJECT}")"
mkdir -p "$(dirname "${STAGING_MARKER}")"
echo "${TEST_STAGING}" > "${STAGING_MARKER}"
echo "==> test staging: ${TEST_STAGING}"
