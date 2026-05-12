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
SELECT has_table('cat_material'::name, 'Table cat_material should exist');

-- Check columns
SELECT columns_are(
    'cat_material',
    ARRAY[
        'id', 'descript', 'feature_type', 'featurecat_id', 'n', 'link', 'active', 'family'
    ],
    'Table cat_material should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_material', 'id', 'Column id should be primary key'); 

-- Check column types
SELECT col_type_is('cat_material', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_material', 'descript', 'varchar(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_material', 'feature_type', 'text[]', 'Column feature_type should be text[]');
SELECT col_type_is('cat_material', 'featurecat_id', 'text[]', 'Column featurecat_id should be text[]');
SELECT col_type_is('cat_material', 'n', 'numeric(12, 4)', 'Column n should be numeric(12, 4)');
SELECT col_type_is('cat_material', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_material', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_material', 'family', 'varchar(100)', 'Column family should be varchar(100)');

-- Check foreign keys
SELECT fk_ok('cat_material','family','inp_family','family_id','Table should have foreign key from family to inp_family.family_id');

-- Check default values
SELECT col_has_default('cat_material', 'active', 'Column active should have default value');

-- Check indexes
SELECT has_index('cat_material', 'cat_mat_pkey', ARRAY['id'], 'Table should have index on id');

-- Check triggers
SELECT has_trigger('cat_material', 'gw_trg_config_control', 'Table should have trigger gw_trg_config_control');

-- Finish
SELECT * FROM finish();

ROLLBACK;