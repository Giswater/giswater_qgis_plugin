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

-- Check table man_tank
SELECT has_table('man_tank'::name, 'Table man_tank should exist');

-- Check columns
SELECT columns_are(
    'man_tank',
    ARRAY[
        'node_id', 'vmax', 'vutil', 'area', 'chlorination', 'name', 'hmax', 'automated',
        'length', 'width', 'shape', 'fence_type', 'fence_length', 'inlet_arc', 'invert_level'
    ],
    'Table man_tank should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_tank', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_tank', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('man_tank', 'vmax', 'numeric(12,4)', 'Column vmax should be numeric(12,4)');
SELECT col_type_is('man_tank', 'vutil', 'numeric(12,4)', 'Column vutil should be numeric(12,4)');
SELECT col_type_is('man_tank', 'area', 'numeric(12,4)', 'Column area should be numeric(12,4)');
SELECT col_type_is('man_tank', 'chlorination', 'varchar(255)', 'Column chlorination should be varchar(255)');
SELECT col_type_is('man_tank', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('man_tank', 'hmax', 'numeric(12,3)', 'Column hmax should be numeric(12,3)');
SELECT col_type_is('man_tank', 'automated', 'boolean', 'Column automated should be boolean');
SELECT col_type_is('man_tank', 'length', 'double precision', 'Column length should be double precision');
SELECT col_type_is('man_tank', 'width', 'double precision', 'Column width should be double precision');
SELECT col_type_is('man_tank', 'shape', 'integer', 'Column shape should be integer');
SELECT col_type_is('man_tank', 'fence_type', 'integer', 'Column fence_type should be integer');
SELECT col_type_is('man_tank', 'fence_length', 'double precision', 'Column fence_length should be double precision');
SELECT col_type_is('man_tank', 'inlet_arc', 'integer[]', 'Column inlet_arc should be integer[]');
SELECT col_type_is('man_tank', 'invert_level', 'numeric(12,3)', 'Column invert_level should be numeric(12,3)');

-- Check foreign keys
SELECT has_fk('man_tank', 'Table man_tank should have foreign keys');
SELECT fk_ok('man_tank', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id with ON DELETE CASCADE ON UPDATE CASCADE');

-- Check triggers
SELECT has_trigger('man_tank', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('man_tank', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check constraints
SELECT col_not_null('man_tank', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_not_null('man_tank', 'shape', 'Column shape should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;