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

-- Check table man_meter
SELECT has_table('man_meter'::name, 'Table man_meter should exist');

-- Check columns
SELECT columns_are(
    'man_meter',
    ARRAY[
        'node_id', 'real_press_max', 'real_press_min', 'real_press_avg', 'meter_code',
        'automated', 'closed'
    ],
    'Table man_meter should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_meter', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_meter', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('man_meter', 'real_press_max', 'numeric(12,2)', 'Column real_press_max should be numeric(12,2)');
SELECT col_type_is('man_meter', 'real_press_min', 'numeric(12,2)', 'Column real_press_min should be numeric(12,2)');
SELECT col_type_is('man_meter', 'real_press_avg', 'numeric(12,2)', 'Column real_press_avg should be numeric(12,2)');
SELECT col_type_is('man_meter', 'meter_code', 'text', 'Column meter_code should be text');
SELECT col_type_is('man_meter', 'automated', 'boolean', 'Column automated should be boolean');
SELECT col_type_is('man_meter', 'closed', 'boolean', 'Column closed should be boolean');

-- Check not null constraints
SELECT col_not_null('man_meter', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_meter', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

SELECT * FROM finish();

ROLLBACK; 