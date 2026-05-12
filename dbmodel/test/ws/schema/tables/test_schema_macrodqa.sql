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

-- Check table macrodqa
SELECT has_table('macrodqa'::name, 'Table macrodqa should exist');

-- Check columns
SELECT columns_are(
    'macrodqa',
    ARRAY[
        'macrodqa_id', 'code', 'name', 'descript', 'expl_id', 'lock_level', 'active', 'the_geom',
        'created_at', 'created_by', 'updated_at', 'updated_by', 'addparam', 'link',
        'muni_id', 'sector_id', 'stylesheet'
    ],
    'Table macrodqa should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('macrodqa', ARRAY['macrodqa_id'], 'Column macrodqa_id should be primary key');

-- Check column types
SELECT col_type_is('macrodqa', 'macrodqa_id', 'integer', 'Column macrodqa_id should be integer');
SELECT col_type_is('macrodqa', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('macrodqa', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('macrodqa', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('macrodqa', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('macrodqa', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('macrodqa', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('macrodqa', 'the_geom', 'geometry(MultiPolygon,SRID_VALUE)', 'Column the_geom should be geometry(MultiPolygon,SRID_VALUE)');
SELECT col_type_is('macrodqa', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('macrodqa', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('macrodqa', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('macrodqa', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

-- Check not null constraints
SELECT col_not_null('macrodqa', 'macrodqa_id', 'Column macrodqa_id should be NOT NULL');
SELECT col_not_null('macrodqa', 'name', 'Column name should be NOT NULL');

-- Check default values
SELECT col_default_is('macrodqa', 'active', 'true', 'Column active should default to true');
SELECT col_default_is('macrodqa', 'created_at', 'now()', 'Column created_at should default to now()');
SELECT col_default_is('macrodqa', 'created_by', 'CURRENT_USER', 'Column created_by should default to CURRENT_USER');

-- Check triggers
SELECT has_trigger('macrodqa', 'gw_trg_edit_controls', 'Trigger gw_trg_edit_controls should exist');
SELECT has_trigger('macrodqa', 'gw_trg_fk_array_array_table_expl', 'Trigger gw_trg_fk_array_array_table_expl should exist');

-- Check sequences

-- Check constraints

SELECT * FROM finish();

ROLLBACK;