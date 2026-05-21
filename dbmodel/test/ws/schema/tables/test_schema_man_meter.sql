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
SELECT has_table('man_meter'::name, 'Table man_meter should exist');

-- Check columns
SELECT columns_are(
    'man_meter',
    ARRAY[
        'node_id', 'real_press_max', 'real_press_min', 'real_press_avg', 'meter_code', 'automated',
        'closed', 'to_arc', 'meter_type', 'name', 'nominal_flowrate'
    ],
    'Table man_meter should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_meter', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_meter', 'real_press_max', 'numeric(12,2)', 'Column real_press_max should be numeric(12,2)');
SELECT col_type_is('man_meter', 'real_press_min', 'numeric(12,2)', 'Column real_press_min should be numeric(12,2)');
SELECT col_type_is('man_meter', 'real_press_avg', 'numeric(12,2)', 'Column real_press_avg should be numeric(12,2)');
SELECT col_type_is('man_meter', 'meter_code', 'text', 'Column meter_code should be text');
SELECT col_type_is('man_meter', 'automated', 'bool', 'Column automated should be bool');
SELECT col_type_is('man_meter', 'closed', 'bool', 'Column closed should be bool');
SELECT col_type_is('man_meter', 'to_arc', 'int4', 'Column to_arc should be int4');
SELECT col_type_is('man_meter', 'meter_type', 'int4', 'Column meter_type should be int4');
SELECT col_type_is('man_meter', 'name', 'text', 'Column name should be text');
SELECT col_type_is('man_meter', 'nominal_flowrate', 'numeric(12,3)', 'Column nominal_flowrate should be numeric(12,3)');

-- Check foreign keys
SELECT has_fk('man_meter', 'Table man_meter should have foreign keys');

SELECT fk_ok('man_meter', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
