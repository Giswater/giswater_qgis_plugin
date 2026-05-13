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
SELECT has_table('cat_gully'::name, 'Table cat_gully should exist');

-- Check columns
SELECT columns_are(
    'cat_gully',
    ARRAY[
        'id', 'gully_type', 'matcat_id', 'length', 'width', 'ymax',
        'efficiency', 'descript', 'link', 'brand_id', 'model_id', 'svg',
        'label', 'active', 'code'
    ],
    'Table cat_gully should have the correct columns'
);

-- Check column types
SELECT col_type_is('cat_gully', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_gully', 'gully_type', 'text', 'Column gully_type should be text');
SELECT col_type_is('cat_gully', 'matcat_id', 'varchar(16)', 'Column matcat_id should be varchar(16)');
SELECT col_type_is('cat_gully', 'length', 'numeric(12,4)', 'Column length should be numeric(12,4)');
SELECT col_type_is('cat_gully', 'width', 'numeric(12,4)', 'Column width should be numeric(12,4)');
SELECT col_type_is('cat_gully', 'ymax', 'numeric(12,4)', 'Column ymax should be numeric(12,4)');
SELECT col_type_is('cat_gully', 'efficiency', 'numeric(12,4)', 'Column efficiency should be numeric(12,4)');
SELECT col_type_is('cat_gully', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('cat_gully', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_gully', 'brand_id', 'varchar(30)', 'Column brand_id should be varchar(30)');
SELECT col_type_is('cat_gully', 'model_id', 'varchar(30)', 'Column model_id should be varchar(30)');
SELECT col_type_is('cat_gully', 'svg', 'varchar(50)', 'Column svg should be varchar(50)');
SELECT col_type_is('cat_gully', 'label', 'varchar(255)', 'Column label should be varchar(255)');
SELECT col_type_is('cat_gully', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_gully', 'code', 'text', 'Column code should be text');

-- Check foreign keys
SELECT has_fk('cat_gully', 'Table cat_gully should have foreign keys');

SELECT fk_ok('cat_gully', 'brand_id', 'cat_brand', 'id', 'FK brand_id → cat_brand.id');
SELECT fk_ok('cat_gully', 'gully_type', 'cat_feature_gully', 'id', 'FK gully_type → cat_feature_gully.id');
SELECT fk_ok('cat_gully', 'model_id', 'cat_brand_model', 'id', 'FK model_id → cat_brand_model.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
