/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(48);

-- Login users (cleaned up by ROLLBACK)
CREATE USER gw_basic;
GRANT role_basic TO gw_basic;

CREATE USER gw_om;
GRANT role_om TO gw_om;

CREATE USER gw_edit;
GRANT role_edit TO gw_edit;

CREATE USER gw_epa;
GRANT role_epa TO gw_epa;

CREATE USER gw_admin;
GRANT role_admin TO gw_admin;

-- ===========================
-- gw_basic / gw_om (read-only on network)
-- ===========================
SELECT ok(
    has_table_privilege('gw_basic', 'node', 'SELECT'),
    'gw_basic has SELECT on node'
);
SELECT ok(
    NOT has_table_privilege('gw_basic', 'node', 'INSERT'),
    'gw_basic has no INSERT on node'
);
SELECT ok(
    NOT has_table_privilege('gw_basic', 'node', 'UPDATE'),
    'gw_basic has no UPDATE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_basic', 'node', 'DELETE'),
    'gw_basic has no DELETE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_basic', 'node', 'TRUNCATE'),
    'gw_basic has no TRUNCATE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_basic', 'node', 'TRIGGER'),
    'gw_basic has no TRIGGER on node'
);
SELECT ok(
    NOT has_table_privilege('gw_basic', 'cat_dscenario', 'INSERT'),
    'gw_basic has no INSERT on cat_dscenario'
);
SELECT ok(
    NOT has_table_privilege('gw_basic', 'sys_table', 'INSERT'),
    'gw_basic has no INSERT on sys_table'
);

SELECT ok(
    has_table_privilege('gw_om', 'node', 'SELECT'),
    'gw_om has SELECT on node'
);
SELECT ok(
    NOT has_table_privilege('gw_om', 'node', 'INSERT'),
    'gw_om has no INSERT on node'
);
SELECT ok(
    NOT has_table_privilege('gw_om', 'node', 'UPDATE'),
    'gw_om has no UPDATE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_om', 'node', 'DELETE'),
    'gw_om has no DELETE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_om', 'node', 'TRUNCATE'),
    'gw_om has no TRUNCATE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_om', 'node', 'TRIGGER'),
    'gw_om has no TRIGGER on node'
);
SELECT ok(
    NOT has_table_privilege('gw_om', 'cat_dscenario', 'INSERT'),
    'gw_om has no INSERT on cat_dscenario'
);
SELECT ok(
    NOT has_table_privilege('gw_om', 'sys_table', 'INSERT'),
    'gw_om has no INSERT on sys_table'
);

-- ===========================
-- gw_edit (network DML)
-- ===========================
SELECT ok(
    has_table_privilege('gw_edit', 'node', 'SELECT'),
    'gw_edit has SELECT on node'
);
SELECT ok(
    has_table_privilege('gw_edit', 'node', 'INSERT'),
    'gw_edit has INSERT on node'
);
SELECT ok(
    has_table_privilege('gw_edit', 'node', 'UPDATE'),
    'gw_edit has UPDATE on node'
);
SELECT ok(
    has_table_privilege('gw_edit', 'node', 'DELETE'),
    'gw_edit has DELETE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_edit', 'node', 'TRUNCATE'),
    'gw_edit has no TRUNCATE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_edit', 'node', 'TRIGGER'),
    'gw_edit has no TRIGGER on node'
);
SELECT ok(
    NOT has_table_privilege('gw_edit', 'cat_dscenario', 'INSERT'),
    'gw_edit has no INSERT on cat_dscenario'
);
SELECT ok(
    NOT has_table_privilege('gw_edit', 'sys_table', 'INSERT'),
    'gw_edit has no INSERT on sys_table'
);

-- ===========================
-- gw_epa (EPA tables)
-- ===========================
SELECT ok(
    has_table_privilege('gw_epa', 'node', 'SELECT'),
    'gw_epa has SELECT on node'
);
SELECT ok(
    has_table_privilege('gw_epa', 'node', 'INSERT'),
    'gw_epa has INSERT on node'
);
SELECT ok(
    has_table_privilege('gw_epa', 'node', 'UPDATE'),
    'gw_epa has UPDATE on node'
);
SELECT ok(
    has_table_privilege('gw_epa', 'node', 'DELETE'),
    'gw_epa has DELETE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_epa', 'node', 'TRUNCATE'),
    'gw_epa has no TRUNCATE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_epa', 'node', 'TRIGGER'),
    'gw_epa has no TRIGGER on node'
);
SELECT ok(
    has_table_privilege('gw_epa', 'cat_dscenario', 'INSERT'),
    'gw_epa has INSERT on cat_dscenario'
);
SELECT ok(
    NOT has_table_privilege('gw_epa', 'sys_table', 'INSERT'),
    'gw_epa has no INSERT on sys_table'
);

-- ===========================
-- gw_admin (admin catalog)
-- ===========================
SELECT ok(
    has_table_privilege('gw_admin', 'node', 'SELECT'),
    'gw_admin has SELECT on node'
);
SELECT ok(
    has_table_privilege('gw_admin', 'node', 'INSERT'),
    'gw_admin has INSERT on node'
);
SELECT ok(
    has_table_privilege('gw_admin', 'node', 'UPDATE'),
    'gw_admin has UPDATE on node'
);
SELECT ok(
    has_table_privilege('gw_admin', 'node', 'DELETE'),
    'gw_admin has DELETE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_admin', 'node', 'TRUNCATE'),
    'gw_admin has no TRUNCATE on node'
);
SELECT ok(
    NOT has_table_privilege('gw_admin', 'node', 'TRIGGER'),
    'gw_admin has no TRIGGER on node'
);
SELECT ok(
    has_table_privilege('gw_admin', 'cat_dscenario', 'INSERT'),
    'gw_admin has INSERT on cat_dscenario'
);
SELECT ok(
    has_table_privilege('gw_admin', 'sys_table', 'INSERT'),
    'gw_admin has INSERT on sys_table'
);

-- ===========================
-- sys_table role_basic (cat_workspace)
-- ===========================
SELECT ok(
    has_table_privilege('gw_basic', 'cat_workspace', 'SELECT'),
    'gw_basic has SELECT on cat_workspace'
);
SELECT ok(
    has_table_privilege('gw_basic', 'cat_workspace', 'INSERT'),
    'gw_basic has INSERT on cat_workspace'
);
SELECT ok(
    has_table_privilege('gw_edit', 'cat_workspace', 'SELECT'),
    'gw_edit has SELECT on cat_workspace'
);
SELECT ok(
    has_table_privilege('gw_edit', 'cat_workspace', 'INSERT'),
    'gw_edit has INSERT on cat_workspace'
);

-- ===========================
-- Runtime SQL (sample actions)
-- ===========================
SET ROLE gw_edit;

SELECT lives_ok(
    'SELECT 1 FROM node LIMIT 1',
    'gw_edit can SELECT from node'
);

SELECT throws_ok(
    'TRUNCATE node',
    '42501',
    NULL,
    'gw_edit cannot TRUNCATE node'
);

SELECT throws_ok(
    'ALTER TABLE node DISABLE TRIGGER ALL',
    '42501',
    NULL,
    'gw_edit cannot DISABLE TRIGGER ALL on node'
);

RESET ROLE;
SET ROLE gw_basic;

SELECT throws_ok(
    'INSERT INTO node DEFAULT VALUES',
    '42501',
    NULL,
    'gw_basic cannot INSERT into node'
);

RESET ROLE;

SELECT * FROM finish();

ROLLBACK;
