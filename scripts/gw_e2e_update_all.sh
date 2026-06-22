#!/usr/bin/env bash
# Run full E2E suite for release gate (profiles + isolated update + addons + network).
#
# Usage:
#   export CONN='postgresql://...'
#   ./scripts/gw_e2e_update_all.sh

set -euo pipefail

CONN="${CONN:?Set CONN to a postgresql URL}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "########## E2E update_all: profiles ##########"
"$SCRIPT_DIR/gw_e2e_profiles.sh"

echo ""
echo "########## E2E update_all: update_isolated ##########"
"$SCRIPT_DIR/gw_e2e_update_isolated.sh"

echo ""
echo "########## E2E update_all: addons ##########"
SATELLITES="${SATELLITES:-utils,cibs}" "$SCRIPT_DIR/gw_e2e_addons_integrate.sh"

echo ""
echo "########## E2E update_all: cleanup network before lockstep ##########"
SATELLITES="${SATELLITES:-utils,cibs}" "$SCRIPT_DIR/gw_bootstrap_network.sh" --drop

echo ""
echo "########## E2E update_all: update_network ##########"
"$SCRIPT_DIR/gw_e2e_network_update.sh"

echo ""
echo "E2E update_all passed."
