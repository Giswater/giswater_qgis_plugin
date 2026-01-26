#!/usr/bin/env bash
set -euo pipefail

# Create extensions if they don't exist.
psql -h localhost -U postgres -d gw_db -c 'CREATE EXTENSION IF NOT EXISTS postgis;'
psql -h localhost -U postgres -d gw_db -c 'CREATE EXTENSION IF NOT EXISTS pgrouting;'
psql -h localhost -U postgres -d gw_db -c 'CREATE EXTENSION IF NOT EXISTS postgis_raster;'
psql -h localhost -U postgres -d gw_db -c 'CREATE EXTENSION IF NOT EXISTS postgis_topology;'
psql -h localhost -U postgres -d gw_db -c 'CREATE EXTENSION IF NOT EXISTS pgtap;'

# Create roles if they don't exist.
psql -h localhost -U postgres -d gw_db -c 'CREATE ROLE IF NOT EXISTS role_admin;'
psql -h localhost -U postgres -d gw_db -c 'CREATE ROLE IF NOT EXISTS role_basic;'
psql -h localhost -U postgres -d gw_db -c 'CREATE ROLE IF NOT EXISTS role_crm;'
psql -h localhost -U postgres -d gw_db -c 'CREATE ROLE IF NOT EXISTS role_edit;'
psql -h localhost -U postgres -d gw_db -c 'CREATE ROLE IF NOT EXISTS role_epa;'
psql -h localhost -U postgres -d gw_db -c 'CREATE ROLE IF NOT EXISTS role_om;'
psql -h localhost -U postgres -d gw_db -c 'CREATE ROLE IF NOT EXISTS role_plan;'
psql -h localhost -U postgres -d gw_db -c 'CREATE ROLE IF NOT EXISTS role_system;'

# Grant roles to roles if they don't exist.
psql -h localhost -U postgres -d gw_db -c 'GRANT role_plan TO role_admin;'
psql -h localhost -U postgres -d gw_db -c 'GRANT role_om TO role_edit;'
psql -h localhost -U postgres -d gw_db -c 'GRANT role_edit TO role_epa;'
psql -h localhost -U postgres -d gw_db -c 'GRANT role_basic TO role_om;'
psql -h localhost -U postgres -d gw_db -c 'GRANT role_epa TO role_plan;'
psql -h localhost -U postgres -d gw_db -c 'GRANT role_admin TO role_system;'

# Skip topology schema managed by PostGIS to avoid conflict with existing extension.
pg_restore \
  --exclude-schema=topology \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB" \
  /docker-entrypoint-initdb.d/10-gw_ws.dump
