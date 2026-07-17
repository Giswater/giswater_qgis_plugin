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
SELECT has_table('man_tank'::name, 'Table man_tank should exist');

-- Check columns
SELECT columns_are(
    'man_tank',
    ARRAY[
        'node_id', 'vmax', 'vutil', 'area', 'chlorination', 'name',
        'hmax', 'automated', 'length', 'width', 'shape', 'fence_type',
        'fence_length', 'inlet_arc', 'invert_level', 'vnom'
    ],
    'Table man_tank should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_tank', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_tank', 'vmax', 'numeric(12,4)', 'Column vmax should be numeric(12,4)');
SELECT col_type_is('man_tank', 'vutil', 'numeric(12,4)', 'Column vutil should be numeric(12,4)');
SELECT col_type_is('man_tank', 'area', 'numeric(12,4)', 'Column area should be numeric(12,4)');
SELECT col_type_is('man_tank', 'chlorination', 'varchar(255)', 'Column chlorination should be varchar(255)');
SELECT col_type_is('man_tank', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('man_tank', 'hmax', 'numeric(12,3)', 'Column hmax should be numeric(12,3)');
SELECT col_type_is('man_tank', 'automated', 'bool', 'Column automated should be bool');
SELECT col_type_is('man_tank', 'length', 'float8', 'Column length should be float8');
SELECT col_type_is('man_tank', 'width', 'float8', 'Column width should be float8');
SELECT col_type_is('man_tank', 'shape', 'int4', 'Column shape should be int4');
SELECT col_type_is('man_tank', 'fence_type', 'int4', 'Column fence_type should be int4');
SELECT col_type_is('man_tank', 'fence_length', 'float8', 'Column fence_length should be float8');
SELECT col_type_is('man_tank', 'inlet_arc', 'int4[]', 'Column inlet_arc should be int4[]');
SELECT col_type_is('man_tank', 'invert_level', 'numeric(12,3)', 'Column invert_level should be numeric(12,3)');
SELECT col_type_is('man_tank', 'vnom', 'numeric(12,3)', 'Column vnom should be numeric(12,3)');

-- Check foreign keys
SELECT has_fk('man_tank', 'Table man_tank should have foreign keys');

SELECT fk_ok('man_tank', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
