#!/usr/bin/env bash
# Local/legacy orchestrator: bootstrap → all pg_prove groups → optional dump.
set -euo pipefail

PROJECT="${1:?Usage: run_tests_inner.sh ws|ud}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "${SCRIPT_DIR}/bootstrap_inner.sh" "${PROJECT}"

EXIT_CODE=0
TEST_GROUPS="${TEST_GROUPS:-all}" bash "${SCRIPT_DIR}/prove_inner.sh" "${PROJECT}" || EXIT_CODE=$?

if [[ "${EXIT_CODE}" -eq 0 && -n "${GW_DUMP_PATH:-}" ]]; then
  bash "${SCRIPT_DIR}/dump_schema.sh" "${PROJECT}"
fi

if [[ "${EXIT_CODE}" -eq 0 ]]; then
  echo "==> All requested tests passed."
else
  echo "==> Some tests failed."
fi

exit "${EXIT_CODE}"
