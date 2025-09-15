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

-- Check table sector
SELECT has_table('sector'::name, 'Table sector should exist');

-- Check columns
SELECT columns_are(
    'sector',
    ARRAY[
        'sector_id', 'code', 'name', 'descript', 'sector_type', 'macrosector_id', 'expl_id', 'muni_id', 'parent_id', 'graphconfig',
        'stylesheet', 'link', 'lock_level', 'active', 'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by', 'addparam'
    ],
    'Table sector should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sector', ARRAY['sector_id'], 'Column sector_id should be primary key');

-- Check column types
SELECT col_type_is('sector', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('sector', 'code', 'text', 'Column code should be text');
SELECT col_type_is('sector', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('sector', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('sector', 'sector_type', 'varchar(50)', 'Column sector_type should be varchar(50)');
SELECT col_type_is('sector', 'macrosector_id', 'integer', 'Column macrosector_id should be integer');
SELECT col_type_is('sector', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('sector', 'muni_id', 'integer[]', 'Column muni_id should be integer[]');
SELECT col_type_is('sector', 'parent_id', 'integer', 'Column parent_id should be integer');
SELECT col_type_is('sector', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('sector', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('sector', 'link', 'text', 'Column link should be text');
SELECT col_type_is('sector', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('sector', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('sector', 'the_geom', 'geometry(MultiPolygon,SRID_VALUE)', 'Column the_geom should be geometry(MultiPolygon,SRID_VALUE)');
SELECT col_type_is('sector', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('sector', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('sector', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('sector', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

-- Check indexes
SELECT has_index('sector', 'sector_index', 'Table should have sector_index');

-- Check triggers
SELECT has_trigger('sector', 'gw_trg_edit_controls', 'Table should have gw_trg_edit_controls trigger');
SELECT has_trigger('sector', 'gw_trg_fk_array_array_table_expl', 'Table should have gw_trg_fk_array_array_table_expl trigger');
SELECT has_trigger('sector', 'gw_trg_fk_array_array_table_muni', 'Table should have gw_trg_fk_array_array_table_muni trigger');
SELECT has_trigger('sector', 'gw_trg_fk_array_id_table', 'Table should have gw_trg_fk_array_id_table trigger');
SELECT has_trigger('sector', 'gw_trg_fk_array_id_table_update', 'Table should have gw_trg_fk_array_id_table_update trigger');
SELECT has_trigger('sector', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('sector', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check sequences
SELECT has_sequence('sector_sector_id_seq', 'Sequence sector_sector_id_seq should exist');

-- Check constraints
SELECT col_default_is('sector', 'macrosector_id', '0', 'Column macrosector_id should default to 0');
SELECT col_default_is('sector', 'active', 'true', 'Column active should default to true');
SELECT col_default_is('sector', 'created_at', 'now()', 'Column created_at should default to now()');
SELECT col_default_is('sector', 'created_by', 'CURRENT_USER', 'Column created_by should default to CURRENT_USER');

-- Check foreign keys
SELECT has_fk('sector', 'Table should have foreign key sector_macrosector_id_fkey');
SELECT fk_ok('sector', 'macrosector_id', 'macrosector', 'macrosector_id', 'Foreign key macrosector_id should reference macrosector.macrosector_id');
SELECT fk_ok('sector', 'parent_id', 'sector', 'sector_id', 'Foreign key parent_id should reference sector.sector_id');

SELECT * FROM finish();

ROLLBACK;
