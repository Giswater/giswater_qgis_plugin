#!/usr/bin/env bash
# Release gate: isolated ws/ud upgrades + linked network lockstep update.
# Profiles and standalone addon integrate remain as separate scenarios
# (./dbmodel/test/run_e2e.sh profiles|addons) and pgTAP on PR.
#
# Usage:
#   export CONN='postgresql://...'
#   ./scripts/gw_e2e_update_all.sh

set -euo pipefail

CONN="${CONN:?Set CONN to a postgresql URL}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export PARENT_PROFILE="${PARENT_PROFILE:-empty}"

echo "########## E2E update_all: update_isolated ##########"
"$SCRIPT_DIR/gw_e2e_update_isolated.sh"

echo ""
echo "########## E2E update_all: update_network ##########"
"$SCRIPT_DIR/gw_e2e_network_update.sh"

echo ""
echo "E2E update_all passed."
