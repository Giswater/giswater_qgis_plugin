#!/usr/bin/env bash
# End-to-end: create linked network @ 4.15.0, then lockstep update to 4.16.0.
#
# Usage:
#   export CONN='postgresql://user@host:port/giswater_admin_cli'
#   ./scripts/gw_e2e_network_update.sh

set -euo pipefail

CONN="${CONN:?Set CONN to a postgresql URL}"
PLUGIN_VER="${PLUGIN_VER:-4.15.0}"
TARGET_VER="${TARGET_VER:-4.16.0}"
WS="${WS:-ws}"

echo "=== 1. Create + link network @ ${PLUGIN_VER} ==="
PLUGIN_VER="$PLUGIN_VER" ./scripts/gw_e2e_satellites.sh

echo "=== 2. Network topology ==="
gw network show --conn "$CONN"

echo "=== 3. Guard: single update must fail ==="
if gw schema addon update --type utils --conn "$CONN" 2>/dev/null; then
  echo "expected gw schema addon update --type utils to fail" >&2
  exit 1
fi
echo "guard ok (blocked)"

echo "=== 4. Lockstep plan ==="
gw network update --version "$TARGET_VER" --check --conn "$CONN"

echo "=== 5. Lockstep execute ==="
gw network update --version "$TARGET_VER" --conn "$CONN"

echo "=== 6. Assert markers ==="
psql "$CONN" -v ON_ERROR_STOP=1 <<SQL
SELECT giswater FROM ${WS}.sys_version ORDER BY id DESC LIMIT 1;
SELECT giswater FROM ud.sys_version ORDER BY id DESC LIMIT 1;
SELECT giswater FROM utils.sys_version ORDER BY id DESC LIMIT 1;
SELECT giswater FROM cibs.sys_version ORDER BY id DESC LIMIT 1;
SELECT value FROM ${WS}.config_param_system WHERE parameter = 'gw_lockstep_ws';
SELECT target_version FROM utils.gw_lockstep_marker;
SQL

echo "=== 7. Network after update ==="
gw network show --conn "$CONN"

echo "Done."
