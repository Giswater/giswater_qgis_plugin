#!/usr/bin/env bash
# Restore schema from pg_dump artifact (CI test jobs).
set -euo pipefail

# shellcheck source=_env_inner.sh
source "$(dirname "${BASH_SOURCE[0]}")/_env_inner.sh" "${1:?Usage: restore_inner.sh ws|ud}"

GW_SCHEMA_DUMP="${GW_SCHEMA_DUMP:?GW_SCHEMA_DUMP required (path to pg_dump -Fc)}"
if [[ ! -f "${GW_SCHEMA_DUMP}" ]]; then
  echo "error: dump not found: ${GW_SCHEMA_DUMP}" >&2
  exit 1
fi

echo "==> giswater_admin init-db"
python3 -m giswater_admin init-db --conn "${GW_CONN}" --dbmodel-path "${DBMODEL_DIR}" \
  ${GW_ADMIN_FLAGS[@]+"${GW_ADMIN_FLAGS[@]}"}

echo "==> create Giswater roles (for security/function tests)"
for role in role_admin role_basic role_crm role_edit role_epa role_om role_plan role_system; do
  gw_psql -d gw_db -c "DO \$\$ BEGIN CREATE ROLE ${role}; EXCEPTION WHEN duplicate_object THEN NULL; END \$\$;"
done
gw_psql -d gw_db -c "GRANT role_plan TO role_admin;" 2>/dev/null || true
gw_psql -d gw_db -c "GRANT role_om TO role_edit;" 2>/dev/null || true
gw_psql -d gw_db -c "GRANT role_edit TO role_epa;" 2>/dev/null || true
gw_psql -d gw_db -c "GRANT role_basic TO role_om;" 2>/dev/null || true
gw_psql -d gw_db -c "GRANT role_epa TO role_plan;" 2>/dev/null || true
gw_psql -d gw_db -c "GRANT role_admin TO role_system;" 2>/dev/null || true

echo "==> pg_restore schema ${SCHEMA} from ${GW_SCHEMA_DUMP}"
gw_psql -d gw_db -c "DROP SCHEMA IF EXISTS \"${SCHEMA}\" CASCADE;"
pg_restore -h 127.0.0.1 -p 5432 -U postgres -d gw_db --no-owner --role=postgres "${GW_SCHEMA_DUMP}"

echo "==> replace_vars (staging)"
TEST_STAGING="$(python3 "${SCRIPT_DIR}/replace_vars.py" "${PROJECT}")"
mkdir -p "$(dirname "${STAGING_MARKER}")"
echo "${TEST_STAGING}" > "${STAGING_MARKER}"
echo "==> test staging: ${TEST_STAGING}"
