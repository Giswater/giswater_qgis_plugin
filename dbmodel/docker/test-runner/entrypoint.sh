#!/usr/bin/env bash
set -eu
export GW_TEST_DIR=/workspace/dbmodel/test
# shellcheck source=/usr/local/lib/gw-test/gw_bash.sh
source /usr/local/lib/gw-test/gw_bash.sh
exec bash <(tr -d '\r' < "${GW_TEST_DIR}/run_tests_inner.sh") "$@"
