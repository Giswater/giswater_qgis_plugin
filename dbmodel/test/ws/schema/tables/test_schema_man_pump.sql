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
SELECT has_table('man_pump'::name, 'Table man_pump should exist');

-- Check columns
SELECT columns_are(
    'man_pump',
    ARRAY[
        'node_id', 'max_flow', 'min_flow', 'nom_flow', 'power', 'pressure_exit',
        'elev_height', 'name', 'pump_number', 'to_arc', 'pump_type', 'engine_type'
    ],
    'Table man_pump should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_pump', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_pump', 'max_flow', 'numeric(12,4)', 'Column max_flow should be numeric(12,4)');
SELECT col_type_is('man_pump', 'min_flow', 'numeric(12,4)', 'Column min_flow should be numeric(12,4)');
SELECT col_type_is('man_pump', 'nom_flow', 'numeric(12,4)', 'Column nom_flow should be numeric(12,4)');
SELECT col_type_is('man_pump', 'power', 'numeric(12,4)', 'Column power should be numeric(12,4)');
SELECT col_type_is('man_pump', 'pressure_exit', 'numeric(12,4)', 'Column pressure_exit should be numeric(12,4)');
SELECT col_type_is('man_pump', 'elev_height', 'numeric(12,4)', 'Column elev_height should be numeric(12,4)');
SELECT col_type_is('man_pump', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('man_pump', 'pump_number', 'int4', 'Column pump_number should be int4');
SELECT col_type_is('man_pump', 'to_arc', 'int4', 'Column to_arc should be int4');
SELECT col_type_is('man_pump', 'pump_type', 'int4', 'Column pump_type should be int4');
SELECT col_type_is('man_pump', 'engine_type', 'int4', 'Column engine_type should be int4');

-- Check foreign keys
SELECT has_fk('man_pump', 'Table man_pump should have foreign keys');

SELECT fk_ok('man_pump', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
