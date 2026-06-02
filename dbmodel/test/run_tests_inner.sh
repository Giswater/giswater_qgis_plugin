#!/usr/bin/env bash
# Local/legacy orchestrator: bootstrap → all pg_prove groups → optional dump.
set -euo pipefail

PROJECT="${1:?Usage: run_tests_inner.sh ws|ud}"
export GW_TEST_DIR="${GW_TEST_DIR:-/workspace/dbmodel/test}"
SCRIPT_DIR="${GW_TEST_DIR}"
# shellcheck source=/usr/local/lib/gw-test/gw_bash.sh
source /usr/local/lib/gw-test/gw_bash.sh

gw_bash "${SCRIPT_DIR}/bootstrap_inner.sh" "${PROJECT}"

EXIT_CODE=0
TEST_GROUPS="${TEST_GROUPS:-all}" gw_bash "${SCRIPT_DIR}/prove_inner.sh" "${PROJECT}" || EXIT_CODE=$?

if [[ "${EXIT_CODE}" -eq 0 && -n "${GW_DUMP_PATH:-}" ]]; then
  gw_bash "${SCRIPT_DIR}/dump_schema.sh" "${PROJECT}"
fi

if [[ "${EXIT_CODE}" -eq 0 ]]; then
  echo "==> All requested tests passed."
else
  echo "==> Some tests failed."
fi

exit "${EXIT_CODE}"
