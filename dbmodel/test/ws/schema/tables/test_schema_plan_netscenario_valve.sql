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
SELECT has_table('plan_netscenario_valve'::name, 'Table plan_netscenario_valve should exist');

-- Check columns
SELECT columns_are(
    'plan_netscenario_valve',
    ARRAY[
        'netscenario_id', 'node_id', 'closed'
    ],
    'Table plan_netscenario_valve should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_netscenario_valve', 'netscenario_id', 'int4', 'Column netscenario_id should be int4');
SELECT col_type_is('plan_netscenario_valve', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('plan_netscenario_valve', 'closed', 'bool', 'Column closed should be bool');

-- Check foreign keys
SELECT has_fk('plan_netscenario_valve', 'Table plan_netscenario_valve should have foreign keys');

SELECT fk_ok('plan_netscenario_valve', 'netscenario_id', 'plan_netscenario', 'netscenario_id', 'FK netscenario_id → plan_netscenario.netscenario_id');
SELECT fk_ok('plan_netscenario_valve', 'node_id', 'man_valve', 'node_id', 'FK node_id → man_valve.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
