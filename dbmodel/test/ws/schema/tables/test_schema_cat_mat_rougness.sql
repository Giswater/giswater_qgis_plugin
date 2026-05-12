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

-- Check table cat_mat_roughness
SELECT has_table('cat_mat_roughness'::name, 'Table cat_mat_roughness should exist');

-- Check columns
SELECT columns_are(
    'cat_mat_roughness',
    ARRAY[
        'id', 'matcat_id', 'period_id', 'init_age', 'end_age', 'roughness', 'descript', 'active'
    ],
    'Table cat_mat_roughness should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_mat_roughness', 'id', 'Column id should be primary key');

-- Check indexes

-- Check column types
SELECT col_type_is('cat_mat_roughness', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('cat_mat_roughness', 'matcat_id', 'character varying(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('cat_mat_roughness', 'period_id', 'character varying(30)', 'Column period_id should be varchar(30)');
SELECT col_type_is('cat_mat_roughness', 'init_age', 'integer', 'Column init_age should be integer');
SELECT col_type_is('cat_mat_roughness', 'end_age', 'integer', 'Column end_age should be integer');
SELECT col_type_is('cat_mat_roughness', 'roughness', 'numeric(12,4)', 'Column roughness should be numeric(12,4)');
SELECT col_type_is('cat_mat_roughness', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_mat_roughness', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT has_fk('cat_mat_roughness', 'Table cat_mat_roughness should have foreign keys');
SELECT fk_ok('cat_mat_roughness', 'matcat_id', 'cat_material', 'id', 'Column matcat_id should reference cat_material(id)');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('cat_mat_roughness_id_seq', 'Sequence cat_mat_roughness_id_seq should exist');

-- Check constraints
SELECT col_default_is('cat_mat_roughness', 'period_id', 'Default'::character varying, 'Column period_id should have default value');
SELECT col_default_is('cat_mat_roughness', 'init_age', 0, 'Column init_age should have default value');
SELECT col_default_is('cat_mat_roughness', 'end_age', 999, 'Column end_age should have default value');
SELECT col_default_is('cat_mat_roughness', 'active', true, 'Column active should have default value');
SELECT col_is_unique('cat_mat_roughness', ARRAY['matcat_id', 'init_age', 'end_age'], 'Columns matcat_id,init_age,end_age should be unique');

SELECT * FROM finish();

ROLLBACK;
