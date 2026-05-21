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
SELECT has_table('cat_connec'::name, 'Table cat_connec should exist');

-- Check columns
SELECT columns_are(
    'cat_connec',
    ARRAY[
        'id', 'connec_type', 'matcat_id', 'pnom', 'dnom', 'dint',
        'dext', 'descript', 'link', 'brand_id', 'model_id', 'svg',
        'active', 'label', 'estimated_depth', 'code'
    ],
    'Table cat_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('cat_connec', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_connec', 'connec_type', 'varchar(18)', 'Column connec_type should be varchar(18)');
SELECT col_type_is('cat_connec', 'matcat_id', 'varchar(16)', 'Column matcat_id should be varchar(16)');
SELECT col_type_is('cat_connec', 'pnom', 'varchar(16)', 'Column pnom should be varchar(16)');
SELECT col_type_is('cat_connec', 'dnom', 'varchar(16)', 'Column dnom should be varchar(16)');
SELECT col_type_is('cat_connec', 'dint', 'numeric(12,5)', 'Column dint should be numeric(12,5)');
SELECT col_type_is('cat_connec', 'dext', 'numeric(12,5)', 'Column dext should be numeric(12,5)');
SELECT col_type_is('cat_connec', 'descript', 'varchar(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_connec', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_connec', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('cat_connec', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('cat_connec', 'svg', 'varchar(50)', 'Column svg should be varchar(50)');
SELECT col_type_is('cat_connec', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_connec', 'label', 'varchar(255)', 'Column label should be varchar(255)');
SELECT col_type_is('cat_connec', 'estimated_depth', 'numeric(12,3)', 'Column estimated_depth should be numeric(12,3)');
SELECT col_type_is('cat_connec', 'code', 'text', 'Column code should be text');

-- Check foreign keys
SELECT has_fk('cat_connec', 'Table cat_connec should have foreign keys');

SELECT fk_ok('cat_connec', 'connec_type', 'cat_feature_connec', 'id', 'FK connec_type → cat_feature_connec.id');
SELECT fk_ok('cat_connec', 'brand_id', 'cat_brand', 'id', 'FK brand_id → cat_brand.id');
SELECT fk_ok('cat_connec', 'model_id', 'cat_brand_model', 'id', 'FK model_id → cat_brand_model.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
