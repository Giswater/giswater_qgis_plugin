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

-- Check table macrodqa
SELECT has_table('macrodqa'::name, 'Table macrodqa should exist');

-- Check columns
SELECT columns_are(
    'macrodqa',
    ARRAY[
        'macrodqa_id', 'name', 'expl_id', 'descript', 'the_geom', 'active', 'lock_level'
    ],
    'Table macrodqa should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('macrodqa', ARRAY['macrodqa_id'], 'Column macrodqa_id should be primary key');

-- Check column types
SELECT col_type_is('macrodqa', 'macrodqa_id', 'integer', 'Column macrodqa_id should be integer');
SELECT col_type_is('macrodqa', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('macrodqa', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('macrodqa', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('macrodqa', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('macrodqa', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('macrodqa', 'lock_level', 'integer', 'Column lock_level should be integer');

-- Check not null constraints
SELECT col_not_null('macrodqa', 'macrodqa_id', 'Column macrodqa_id should be NOT NULL');
SELECT col_not_null('macrodqa', 'name', 'Column name should be NOT NULL');
SELECT col_not_null('macrodqa', 'expl_id', 'Column expl_id should be NOT NULL');

-- Check default values
SELECT col_default_is('macrodqa', 'active', 'true', 'Column active should default to true');

-- Check foreign keys
SELECT fk_ok('macrodqa', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation(expl_id)');

-- Check triggers
SELECT has_trigger('macrodqa', 'gw_trg_edit_controls', 'Trigger gw_trg_edit_controls should exist');

-- Check rules
SELECT has_rule('macrodqa', 'macrodqa_del_undefined', 'Rule macrodqa_del_undefined should exist');
SELECT has_rule('macrodqa', 'macrodqa_undefined', 'Rule macrodqa_undefined should exist');

-- Check sequences

-- Check constraints

SELECT * FROM finish();

ROLLBACK;