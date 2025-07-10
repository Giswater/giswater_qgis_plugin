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
SELECT has_table('dwfzone'::name, 'Table dwfzone should exist');

-- Check columns
SELECT columns_are(
    'dwfzone',
    ARRAY[
        'dwfzone_id', 'code', 'name', 'dwfzone_type', 'expl_id', 'descript', 'link', 'graphconfig', 'stylesheet', 'lock_level',
        'active', 'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by', 'drainzone_id'
    ],
    'Table dwfzone should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('dwfzone', 'dwfzone_id', 'Column dwfzone_id should be primary key'); 

-- Check column types
SELECT col_type_is('dwfzone', 'dwfzone_id', 'serial4', 'Column dwfzone_id should be serial4');
SELECT col_type_is('dwfzone', 'code', 'text', 'Column code should be text');
SELECT col_type_is('dwfzone', 'name', 'varchar(30)', 'Column name should bevarchar(30)');
SELECT col_type_is('dwfzone', 'dwfzone_type', 'varchar(16)', 'Column dwfzone_type should be varchar(16)');
SELECT col_type_is('dwfzone', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('dwfzone', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('dwfzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('dwfzone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('dwfzone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('dwfzone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('dwfzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('dwfzone', 'the_geom', 'geometry(multipolygon, 25831)', 'Column the_geom should be geometry(multipolygon, 25831)');
SELECT col_type_is('dwfzone', 'created_at', 'timestamp', 'Column created_at should be timestamp');
SELECT col_type_is('dwfzone', 'created_by', 'varchar(50)', 'created_by should be varchar(50)');
SELECT col_type_is('dwfzone', 'updated_at', 'timestamp', 'Column updated_at should be timestamp');
SELECT col_type_is('dwfzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('dwfzone', 'drainzone_id', 'int4', 'Column drainzone_id should be int4');

-- Check default values
SELECT col_has_default('dwfzone', 'graphconfig', 'Column graphconfig should have default value');
SELECT col_has_default('dwfzone', 'active', 'Column active should have default value');
SELECT col_has_default('dwfzone', 'created_at', 'Column created_at should have default value');
SELECT col_has_default('dwfzone', 'created_by', 'Column created_by should have default value');

-- Check foreign keys
SELECT has_fk('dwfzone', 'Table dwfzone should have foreign keys');

SELECT fk_ok('dwfzone', 'drainzone_id', 'drainzone', 'drainzone_id', 'Table should have foreign key from drainzone_id to drainzone.drainzone_id');

-- Check indexes
SELECT has_index('dwfzone', 'dwfzone_id', 'Table should have index on dwfzone_id');

-- Check triggers
SELECT has_trigger('dwfzone', 'gw_trg_edit_controls', 'Table should have trigger gw_trg_edit_controls');
SELECT has_trigger('dwfzone', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('dwfzone', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');

-- Finish
SELECT * FROM finish();

ROLLBACK;