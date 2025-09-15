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

-- Check table macrodma
SELECT has_table('macrodma'::name, 'Table macrodma should exist');

-- Check columns
SELECT columns_are(
    'macrodma',
    ARRAY[
        'macrodma_id', 'code', 'name', 'descript', 'expl_id', 'lock_level', 'active', 'the_geom',
        'created_at', 'created_by', 'updated_at', 'updated_by', 'addparam', 'link',
        'muni_id', 'sector_id', 'stylesheet'
    ],
    'Table macrodma should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('macrodma', ARRAY['macrodma_id'], 'Column macrodma_id should be primary key');

-- Check column types
SELECT col_type_is('macrodma', 'macrodma_id', 'integer', 'Column macrodma_id should be integer');
SELECT col_type_is('macrodma', 'code', 'text', 'Column code should be text');
SELECT col_type_is('macrodma', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('macrodma', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('macrodma', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('macrodma', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('macrodma', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('macrodma', 'the_geom', 'geometry(MultiPolygon,SRID_VALUE)', 'Column the_geom should be geometry(MultiPolygon,SRID_VALUE)');
SELECT col_type_is('macrodma', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('macrodma', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('macrodma', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('macrodma', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

-- Check not null constraints
SELECT col_not_null('macrodma', 'macrodma_id', 'Column macrodma_id should be NOT NULL');
SELECT col_not_null('macrodma', 'name', 'Column name should be NOT NULL');

-- Check default values
SELECT col_default_is('macrodma', 'active', 'true', 'Column active should default to true');
SELECT col_default_is('macrodma', 'created_at', 'now()', 'Column created_at should default to now()');
SELECT col_default_is('macrodma', 'created_by', 'CURRENT_USER', 'Column created_by should default to CURRENT_USER');

-- Check indexes
SELECT has_index('macrodma', 'macrodma_index', 'Should have index on the_geom');

-- Check triggers
SELECT has_trigger('macrodma', 'gw_trg_edit_controls', 'Trigger gw_trg_edit_controls should exist');
SELECT has_trigger('macrodma', 'gw_trg_fk_array_array_table_expl', 'Trigger gw_trg_fk_array_array_table_expl should exist');

SELECT * FROM finish();

ROLLBACK;



