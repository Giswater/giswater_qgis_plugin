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
        'id', 'descript', 'feature_type', 'featurecat_id', 'n', 'link',
        'active', 'family'
    ],
    'Table cat_material should have the correct columns'
);

-- Check column types
SELECT col_type_is('cat_material', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_material', 'descript', 'varchar(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_material', 'feature_type', 'text[]', 'Column feature_type should be text[]');
SELECT col_type_is('cat_material', 'featurecat_id', 'text[]', 'Column featurecat_id should be text[]');
SELECT col_type_is('cat_material', 'n', 'numeric(12,4)', 'Column n should be numeric(12,4)');
SELECT col_type_is('cat_material', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_material', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_material', 'family', 'varchar(100)', 'Column family should be varchar(100)');

-- Check foreign keys
SELECT has_fk('cat_material', 'Table cat_material should have foreign keys');

SELECT fk_ok('cat_material', 'family', 'inp_family', 'family_id', 'FK family → inp_family.family_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
