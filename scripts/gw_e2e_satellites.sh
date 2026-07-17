#!/usr/bin/env bash
# End-to-end satellite schema smoke test (ws + ud + utils + cibs).
#
# Usage:
#   export CONN='postgresql://user@host:port/dbname'
#   ./scripts/gw_e2e_satellites.sh          # run all steps
#   ./scripts/gw_e2e_satellites.sh --check  # plan only
#
# Cleanup:
#   ./scripts/gw_e2e_satellites.sh --drop

set -euo pipefail

CONN="${CONN:?Set CONN to a postgresql URL}"
WS="${WS:-ws}"
UD="${UD:-ud}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bootstrap_args=("$@")

run_drop=true
for arg in "$@"; do
  case "$arg" in
    --check|--drop) run_drop=false ;;
  esac
done
if [[ "$run_drop" == true ]]; then
  SATELLITES="${SATELLITES:-utils,cibs}" WS="${WS}" UD="${UD}" \
    "$SCRIPT_DIR/gw_bootstrap_network.sh" --drop >/dev/null 2>&1 || true
fi

"$SCRIPT_DIR/gw_bootstrap_network.sh" "${bootstrap_args[@]}"

for arg in "$@"; do
  case "$arg" in
    --check|--drop) exit 0 ;;
  esac
done

echo "=== Post-steps (cibs flags + role permissions) ==="
psql "$CONN" -v ON_ERROR_STOP=1 <<SQL
SELECT ${WS}.gw_fct_admin_role_permissions();
UPDATE ${WS}.config_param_system SET value = 'true' WHERE parameter = 'admin_cibs_schema';
SELECT ${UD}.gw_fct_admin_role_permissions();
UPDATE ${UD}.config_param_system SET value = 'true' WHERE parameter = 'admin_cibs_schema';
SQL

echo "E2E satellites done."
