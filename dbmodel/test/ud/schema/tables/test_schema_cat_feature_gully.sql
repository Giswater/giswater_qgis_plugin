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
SELECT has_table('cat_feature_gully'::name, 'Table cat_feature_gully should exist');

-- Check columns
SELECT columns_are(
    'cat_feature_gully',
    ARRAY[
        'id', 'double_geom', 'epa_default'
    ],
    'Table cat_feature_gully should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_feature_gully', 'id', 'Column id should be primary key'); 

-- Check check columns
SELECT col_has_check('cat_feature_gully', 'epa_default', 'Table should have check on epa_default');

-- Check column types
SELECT col_type_is('cat_feature_gully', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_feature_gully', 'double_geom', 'json', 'Column double_geom should be json');
SELECT col_type_is('cat_feature_gully', 'epa_default', 'varchar(30)', 'Column epa_default should be varchar(30)');

-- Check default values
SELECT col_has_default('cat_feature_gully', 'epa_default', 'Column epa_default should have default value');

-- Check foreign keys
SELECT has_fk('cat_feature_gully', 'Table cat_feature_gully should have foreign keys');

SELECT fk_ok('cat_feature_gully', 'id', 'cat_feature', 'id', 'Table should have foreign key from id to cat_feature.id');

-- Check indexes
SELECT has_index('cat_feature_gully', 'id', 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;