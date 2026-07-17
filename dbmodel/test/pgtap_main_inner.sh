#!/usr/bin/env bash
# CI pgTAP main lane: bootstrap → dump (gw-db artifact) → prove.
# Usage: pgtap_main_inner.sh ws|ud
set -euo pipefail

PROJECT="${1:?Usage: pgtap_main_inner.sh ws|ud}"
_TEST_ROOT="${GW_TEST_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

bash "${_TEST_ROOT}/bootstrap_inner.sh" "${PROJECT}"
bash "${_TEST_ROOT}/dump_schema.sh" "${PROJECT}"
bash "${_TEST_ROOT}/prove_inner.sh" "${PROJECT}"
