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

SELECT * FROM no_plan();

-- Check table
SELECT has_table('plan_netscenario'::name, 'Table plan_netscenario should exist');

-- Check columns
SELECT columns_are(
    'plan_netscenario',
    ARRAY[
        'netscenario_id', 'name', 'descript', 'parent_id', 'netscenario_type', 'active',
        'expl_id', 'log'
    ],
    'Table plan_netscenario should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_netscenario', 'netscenario_id', 'int4', 'Column netscenario_id should be int4');
SELECT col_type_is('plan_netscenario', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('plan_netscenario', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('plan_netscenario', 'parent_id', 'int4', 'Column parent_id should be int4');
SELECT col_type_is('plan_netscenario', 'netscenario_type', 'text', 'Column netscenario_type should be text');
SELECT col_type_is('plan_netscenario', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('plan_netscenario', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('plan_netscenario', 'log', 'text', 'Column log should be text');

-- Check foreign keys
SELECT has_fk('plan_netscenario', 'Table plan_netscenario should have foreign keys');

SELECT fk_ok('plan_netscenario', 'parent_id', 'plan_netscenario', 'netscenario_id', 'FK parent_id → plan_netscenario.netscenario_id');
SELECT fk_ok('plan_netscenario', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id → exploitation.expl_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
