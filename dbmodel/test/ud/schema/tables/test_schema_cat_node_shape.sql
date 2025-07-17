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
SELECT has_table('cat_node_shape'::name, 'Table cat_node_shape should exist');

-- Check columns
SELECT columns_are(
    'cat_node_shape',
    ARRAY[
        'id', 'descript', 'active'
    ],
    'Table cat_node_shape should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_node_shape', 'id', 'Column id should be primary key'); 

-- Check column types
SELECT col_type_is('cat_node_shape', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_node_shape', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_node_shape', 'active', 'bool', 'Column active should be bool');

-- Check default values
SELECT col_has_default('cat_node_shape', 'active', 'Column active should have default value');

-- Check indexes
SELECT has_index('cat_node_shape', 'cat_node_shape_pkey', ARRAY['id'], 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;