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
SELECT has_table('cat_arc_shape'::name, 'Table cat_arc_shape should exist');

-- Check columns
SELECT columns_are(
    'cat_arc_shape',
    ARRAY[
        'id', 'epa', 'image', 'descript', 'active'
    ],
    'Table cat_arc_shape should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_arc_shape', 'id', 'Column id should be primary key'); 

-- Check check columns
SELECT col_has_check('cat_arc_shape', 'epa', 'Table should have check on epa');

-- Check column types
SELECT col_type_is('cat_arc_shape', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_arc_shape', 'epa', 'varchar(30)', 'Column epa should be varchar(30)');
SELECT col_type_is('cat_arc_shape', 'image', 'varchar(50)', 'Column image should be varchar(50)');
SELECT col_type_is('cat_arc_shape', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_arc_shape', 'active', 'bool', 'Column active should be bool');

-- Check default values
SELECT col_has_default('cat_arc_shape', 'active', 'Column active should have default value');

-- Check indexes
SELECT has_index('cat_arc_shape', 'id', 'Table should have index on id');

-- Check triggers
SELECT has_trigger('cat_arc_shape', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('cat_arc_shape', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');

-- Finish
SELECT * FROM finish();

ROLLBACK;