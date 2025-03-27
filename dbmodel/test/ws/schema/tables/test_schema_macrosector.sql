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

-- Check table macrosector
SELECT has_table('macrosector'::name, 'Table macrosector should exist');

-- Check columns
SELECT columns_are(
    'macrosector',
    ARRAY[
        'macrosector_id', 'name', 'descript', 'the_geom', 'active', 'lock_level'
    ],
    'Table macrosector should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('macrosector', ARRAY['macrosector_id'], 'Column macrosector_id should be primary key');

-- Check column types
SELECT col_type_is('macrosector', 'macrosector_id', 'integer', 'Column macrosector_id should be integer');
SELECT col_type_is('macrosector', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('macrosector', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('macrosector', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('macrosector', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('macrosector', 'lock_level', 'integer', 'Column lock_level should be integer');

-- Check not null constraints
SELECT col_not_null('macrosector', 'macrosector_id', 'Column macrosector_id should be NOT NULL');
SELECT col_not_null('macrosector', 'name', 'Column name should be NOT NULL');

-- Check default values
SELECT col_default_is('macrosector', 'active', 'true', 'Column active should default to true');

-- Check indexes
SELECT has_index('macrosector', 'macrosector_index', 'Should have index on the_geom');

-- Check triggers
SELECT has_trigger('macrosector', 'gw_trg_edit_controls', 'Trigger gw_trg_edit_controls should exist');

-- Check rules
SELECT has_rule('macrosector', 'macrosector_del_undefined', 'Rule macrosector_del_undefined should exist');
SELECT has_rule('macrosector', 'macrosector_undefined', 'Rule macrosector_undefined should exist');

SELECT * FROM finish();

ROLLBACK;