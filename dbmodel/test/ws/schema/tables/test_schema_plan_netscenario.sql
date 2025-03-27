/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table plan_netscenario
SELECT has_table('plan_netscenario'::name, 'Table plan_netscenario should exist');

-- Check columns
SELECT columns_are(
    'plan_netscenario',
    ARRAY[
        'netscenario_id', 'name', 'descript', 'parent_id', 'netscenario_type', 'active', 'expl_id', 'log'
    ],
    'Table plan_netscenario should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_netscenario', ARRAY['netscenario_id'], 'Column netscenario_id should be primary key');

-- Check column types
SELECT col_type_is('plan_netscenario', 'netscenario_id', 'integer', 'Column netscenario_id should be integer');
SELECT col_type_is('plan_netscenario', 'name', 'character varying(30)', 'Column name should be character varying(30)');
SELECT col_type_is('plan_netscenario', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('plan_netscenario', 'parent_id', 'integer', 'Column parent_id should be integer');
SELECT col_type_is('plan_netscenario', 'netscenario_type', 'text', 'Column netscenario_type should be text');
SELECT col_type_is('plan_netscenario', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('plan_netscenario', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('plan_netscenario', 'log', 'text', 'Column log should be text');

-- Check default values
SELECT col_has_default('plan_netscenario', 'netscenario_id', 'Column netscenario_id should have a default value');
SELECT col_default_is('plan_netscenario', 'active', 'true', 'Default value for active should be true');

-- Check foreign keys
SELECT has_fk('plan_netscenario', 'Table plan_netscenario should have foreign keys');
SELECT fk_ok('plan_netscenario', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation.expl_id');
SELECT fk_ok('plan_netscenario', 'parent_id', 'plan_netscenario', 'netscenario_id', 'FK parent_id should reference plan_netscenario.netscenario_id');

-- Check constraints
SELECT col_not_null('plan_netscenario', 'netscenario_id', 'Column netscenario_id should be NOT NULL');
SELECT col_is_unique('plan_netscenario', ARRAY['name'], 'Column name should be unique');

SELECT * FROM finish();

ROLLBACK;