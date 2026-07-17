#!/usr/bin/env bash
# compose run runner ws|ud          → full test orchestrator (run_tests_inner.sh)
# compose run runner bash path.sh … → CI / ad-hoc script (gw_bash strips CRLF)
set -eu
export GW_TEST_DIR=/workspace/dbmodel/test
# shellcheck source=/usr/local/lib/gw-test/gw_bash.sh
source /usr/local/lib/gw-test/gw_bash.sh

if [[ "${1:-}" == "bash" && -n "${2:-}" ]]; then
  shift
  gw_bash "$@"
  exit $?
fi

if [[ "${1:-}" == "ws" || "${1:-}" == "ud" ]]; then
  exec bash <(tr -d '\r' < "${GW_TEST_DIR}/run_tests_inner.sh") "$@"
fi

echo "usage: $0 ws|ud  OR  $0 bash /workspace/dbmodel/test/<script>.sh ws|ud" >&2
exit 2
