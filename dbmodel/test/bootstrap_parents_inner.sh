#!/usr/bin/env bash
# Bootstrap ws_40 + ud_40 parent schemas (required before addon create/integrate).
# Usage: bootstrap_parents_inner.sh
#   GW_PARENT_PROFILE=empty|sample|inventory  (default: empty)
set -euo pipefail

# shellcheck source=_env_inner.sh
_TEST_ROOT="${GW_TEST_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
source "${_TEST_ROOT}/_env_inner.sh" ws

export CONN="${GW_CONN}"
PARENT_PROFILE="${GW_PARENT_PROFILE:-empty}"

gw() {
  python3 -m giswater_admin "$@" \
    --dbmodel-path "${DBMODEL_DIR}" \
    --conn "${GW_CONN}" \
    ${GW_ADMIN_FLAGS[@]+"${GW_ADMIN_FLAGS[@]}"}
}

echo "==> giswater_admin db init"
gw db init --conn "${GW_CONN}" --with-pgtap

for ptype in ws ud; do
  schema="${ptype}_40"
  echo "==> schema main create ${ptype} profile=${PARENT_PROFILE} name=${schema}"
  gw schema main drop --name "${schema}" --yes --cascade \
    --conn "${GW_CONN}" >/dev/null 2>&1 || true
  gw schema main create \
    --type "${ptype}" \
    --name "${schema}" \
    --profile "${PARENT_PROFILE}" \
    --srid 25831 \
    --lang en_US \
    --version "${GW_PLUGIN_VERSION}" \
    --conn "${GW_CONN}"
done

echo "==> parent schemas ws_40 + ud_40 ready (profile=${PARENT_PROFILE})"
