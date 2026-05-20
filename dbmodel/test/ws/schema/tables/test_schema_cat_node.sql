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
SELECT has_table('cat_node'::name, 'Table cat_node should exist');

-- Check columns
SELECT columns_are(
    'cat_node',
    ARRAY[
        'id', 'node_type', 'matcat_id', 'pnom', 'dnom', 'dint',
        'dext', 'shape', 'descript', 'link', 'brand_id', 'model_id',
        'svg', 'estimated_depth', 'cost_unit', 'cost', 'active', 'label',
        'ischange', 'acoeff', 'code'
    ],
    'Table cat_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('cat_node', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_node', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('cat_node', 'matcat_id', 'varchar(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('cat_node', 'pnom', 'varchar(16)', 'Column pnom should be varchar(16)');
SELECT col_type_is('cat_node', 'dnom', 'varchar(16)', 'Column dnom should be varchar(16)');
SELECT col_type_is('cat_node', 'dint', 'numeric(12,5)', 'Column dint should be numeric(12,5)');
SELECT col_type_is('cat_node', 'dext', 'numeric(12,5)', 'Column dext should be numeric(12,5)');
SELECT col_type_is('cat_node', 'shape', 'varchar(50)', 'Column shape should be varchar(50)');
SELECT col_type_is('cat_node', 'descript', 'varchar(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_node', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_node', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('cat_node', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('cat_node', 'svg', 'varchar(50)', 'Column svg should be varchar(50)');
SELECT col_type_is('cat_node', 'estimated_depth', 'numeric(12,2)', 'Column estimated_depth should be numeric(12,2)');
SELECT col_type_is('cat_node', 'cost_unit', 'varchar(3)', 'Column cost_unit should be varchar(3)');
SELECT col_type_is('cat_node', 'cost', 'varchar(16)', 'Column cost should be varchar(16)');
SELECT col_type_is('cat_node', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_node', 'label', 'varchar(255)', 'Column label should be varchar(255)');
SELECT col_type_is('cat_node', 'ischange', 'int2', 'Column ischange should be int2');
SELECT col_type_is('cat_node', 'acoeff', 'float8', 'Column acoeff should be float8');
SELECT col_type_is('cat_node', 'code', 'text', 'Column code should be text');

-- Check foreign keys
SELECT has_fk('cat_node', 'Table cat_node should have foreign keys');

SELECT fk_ok('cat_node', 'cost', 'plan_price', 'id', 'FK cost → plan_price.id');
SELECT fk_ok('cat_node', 'node_type', 'cat_feature_node', 'id', 'FK node_type → cat_feature_node.id');
SELECT fk_ok('cat_node', 'brand_id', 'cat_brand', 'id', 'FK brand_id → cat_brand.id');
SELECT fk_ok('cat_node', 'model_id', 'cat_brand_model', 'id', 'FK model_id → cat_brand_model.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
