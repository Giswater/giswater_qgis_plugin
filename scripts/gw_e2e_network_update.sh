#!/usr/bin/env bash
# End-to-end: create linked network @ PLUGIN_VER, guards, lockstep update to TARGET_VER.
#
# Usage:
#   export CONN='postgresql://user@host:port/giswater_admin_cli'
#   ./scripts/gw_e2e_network_update.sh

set -euo pipefail

CONN="${CONN:?Set CONN to a postgresql URL}"
WS="${WS:-ws}"
SATELLITES="${SATELLITES:-utils,cibs}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=gw_e2e_common.sh
source "${SCRIPT_DIR}/gw_e2e_common.sh"

REPO="$(gw_e2e_repo_root)"
gw_e2e_setup_gw "${REPO}"
gw_e2e_resolve_versions

export WS SATELLITES PLUGIN_VER
export PARENT_PROFILE="${PARENT_PROFILE:-sample}"

echo "=== 1. Create + link network @ ${PLUGIN_VER} ==="
PLUGIN_VER="$PLUGIN_VER" "$SCRIPT_DIR/gw_e2e_satellites.sh"

echo "=== 2. Network topology ==="
gw network show --conn "$CONN"

echo "=== 3. Guard checks ==="
gw_e2e_run_guards

echo "=== 4. Lockstep plan ==="
gw network update --version "$TARGET_VER" --check --conn "$CONN"

echo "=== 5. Lockstep execute ==="
gw network update --version "$TARGET_VER" --conn "$CONN"

echo "=== 6. Assert versions ==="
gw_e2e_assert_sys_version "$WS" "$TARGET_VER"
gw_e2e_assert_sys_version "ud" "$TARGET_VER"
gw_e2e_assert_sys_version "utils" "$TARGET_VER"
gw_e2e_assert_sys_version "cibs" "$TARGET_VER"

echo "=== 7. Network after update ==="
gw network show --conn "$CONN"

echo "Done."
