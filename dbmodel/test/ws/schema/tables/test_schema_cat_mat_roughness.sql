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
SELECT has_table('cat_mat_roughness'::name, 'Table cat_mat_roughness should exist');

-- Check columns
SELECT columns_are(
    'cat_mat_roughness',
    ARRAY[
        'id', 'matcat_id', 'period_id', 'init_age', 'end_age', 'roughness',
        'descript', 'active'
    ],
    'Table cat_mat_roughness should have the correct columns'
);

-- Check column types
SELECT col_type_is('cat_mat_roughness', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('cat_mat_roughness', 'matcat_id', 'varchar(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('cat_mat_roughness', 'period_id', 'varchar(30)', 'Column period_id should be varchar(30)');
SELECT col_type_is('cat_mat_roughness', 'init_age', 'int4', 'Column init_age should be int4');
SELECT col_type_is('cat_mat_roughness', 'end_age', 'int4', 'Column end_age should be int4');
SELECT col_type_is('cat_mat_roughness', 'roughness', 'numeric(12,4)', 'Column roughness should be numeric(12,4)');
SELECT col_type_is('cat_mat_roughness', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_mat_roughness', 'active', 'bool', 'Column active should be bool');

-- Check foreign keys
SELECT has_fk('cat_mat_roughness', 'Table cat_mat_roughness should have foreign keys');

SELECT fk_ok('cat_mat_roughness', 'matcat_id', 'cat_material', 'id', 'FK matcat_id → cat_material.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
