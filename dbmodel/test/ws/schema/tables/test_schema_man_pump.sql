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

-- Check table man_pump
SELECT has_table('man_pump'::name, 'Table man_pump should exist');

-- Check columns
SELECT columns_are(
    'man_pump',
    ARRAY[
        'node_id', 'max_flow', 'min_flow', 'nom_flow', 'power', 'pressure_exit', 'elev_height',
        'name', 'pump_number', 'to_arc'
    ],
    'Table man_pump should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_pump', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_pump', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('man_pump', 'max_flow', 'numeric(12,4)', 'Column max_flow should be numeric(12,4)');
SELECT col_type_is('man_pump', 'min_flow', 'numeric(12,4)', 'Column min_flow should be numeric(12,4)');
SELECT col_type_is('man_pump', 'nom_flow', 'numeric(12,4)', 'Column nom_flow should be numeric(12,4)');
SELECT col_type_is('man_pump', 'power', 'numeric(12,4)', 'Column power should be numeric(12,4)');
SELECT col_type_is('man_pump', 'pressure_exit', 'numeric(12,4)', 'Column pressure_exit should be numeric(12,4)');
SELECT col_type_is('man_pump', 'elev_height', 'numeric(12,4)', 'Column elev_height should be numeric(12,4)');
SELECT col_type_is('man_pump', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('man_pump', 'pump_number', 'integer', 'Column pump_number should be integer');
SELECT col_type_is('man_pump', 'to_arc', 'integer', 'Column to_arc should be integer');

-- Check not null constraints
SELECT col_not_null('man_pump', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_pump', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

SELECT * FROM finish();

ROLLBACK;