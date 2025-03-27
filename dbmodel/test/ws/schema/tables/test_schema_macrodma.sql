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

-- Check table macrodma
SELECT has_table('macrodma'::name, 'Table macrodma should exist');

-- Check columns
SELECT columns_are(
    'macrodma',
    ARRAY[
        'macrodma_id', 'name', 'expl_id', 'descript', 'the_geom', 'active', 'lock_level'
    ],
    'Table macrodma should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('macrodma', ARRAY['macrodma_id'], 'Column macrodma_id should be primary key');

-- Check column types
SELECT col_type_is('macrodma', 'macrodma_id', 'integer', 'Column macrodma_id should be integer');
SELECT col_type_is('macrodma', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('macrodma', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('macrodma', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('macrodma', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('macrodma', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('macrodma', 'lock_level', 'integer', 'Column lock_level should be integer');

-- Check not null constraints
SELECT col_not_null('macrodma', 'macrodma_id', 'Column macrodma_id should be NOT NULL');
SELECT col_not_null('macrodma', 'name', 'Column name should be NOT NULL');
SELECT col_not_null('macrodma', 'expl_id', 'Column expl_id should be NOT NULL');

-- Check default values
SELECT col_default_is('macrodma', 'active', 'true', 'Column active should default to true');

-- Check indexes
SELECT has_index('macrodma', 'macrodma_index', 'Should have index on the_geom');

-- Check triggers
SELECT has_trigger('macrodma', 'gw_trg_edit_controls', 'Trigger gw_trg_edit_controls should exist');

-- Check rules
SELECT has_rule('macrodma', 'macrodma_del_undefined', 'Rule macrodma_del_undefined should exist');
SELECT has_rule('macrodma', 'macrodma_undefined', 'Rule macrodma_undefined should exist');

-- Check foreign keys
SELECT fk_ok('macrodma', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation(expl_id)');

SELECT * FROM finish();

ROLLBACK;