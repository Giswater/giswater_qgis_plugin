#!/usr/bin/env bash
# E2E: isolated ws and ud schema upgrades (no linked network).
#
# Usage:
#   export CONN='postgresql://...'
#   ./scripts/gw_e2e_update_isolated.sh
#   PLUGIN_VER=4.14.0 TARGET_VER=4.15.0 ./scripts/gw_e2e_update_isolated.sh

set -euo pipefail

CONN="${CONN:?Set CONN to a postgresql URL}"
E2E_TYPES="${E2E_TYPES:-ws,ud}"
E2E_UPDATE_PROFILE="${E2E_UPDATE_PROFILE:-sample}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=gw_e2e_common.sh
source "${SCRIPT_DIR}/gw_e2e_common.sh"

REPO="$(gw_e2e_repo_root)"
gw_e2e_setup_gw "${REPO}"
gw_e2e_resolve_versions

echo "=== db init ==="
gw db init --conn "$CONN"
echo "=== upgrade path ${PLUGIN_VER} -> ${TARGET_VER} ==="

IFS=',' read -ra TYPES <<< "${E2E_TYPES}"
for ptype in "${TYPES[@]}"; do
  schema="e2e_upd_${ptype}"
  echo ""
  echo "=== ${ptype}: create @ ${PLUGIN_VER} ==="
  gw schema main drop --name "$schema" --yes --cascade --conn "$CONN" >/dev/null 2>&1 || true
  gw schema main create \
    --type "$ptype" \
    --name "$schema" \
    --profile "$E2E_UPDATE_PROFILE" \
    --version "$PLUGIN_VER" \
    --conn "$CONN"

  gw_e2e_assert_sys_version "$schema" "$PLUGIN_VER"

  echo "=== ${ptype}: update -> ${TARGET_VER} ==="
  gw schema main update --name "$schema" --version "$TARGET_VER" --conn "$CONN"
  gw_e2e_assert_sys_version "$schema" "$TARGET_VER"

  gw schema main drop --name "$schema" --yes --cascade --conn "$CONN"
done

echo ""
echo "E2E update isolated done."
