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

-- Check table cat_arc_shape
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

-- Check column types
SELECT col_type_is('cat_arc_shape', 'id', 'character varying(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_arc_shape', 'epa', 'character varying(30)', 'Column epa should be varchar(30)');
SELECT col_type_is('cat_arc_shape', 'image', 'character varying(50)', 'Column image should be varchar(50)');
SELECT col_type_is('cat_arc_shape', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_arc_shape', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT hasnt_fk('cat_arc_shape', 'Table cat_arc_shape should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

SELECT * FROM finish();

ROLLBACK;
