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
SELECT has_table('cat_arc'::name, 'Table cat_arc should exist');

-- Check columns
SELECT columns_are(
    'cat_arc',
    ARRAY[
        'id', 'arc_type', 'matcat_id', 'pnom', 'dnom', 'dint',
        'dext', 'descript', 'link', 'brand_id', 'model_id', 'svg',
        'z1', 'z2', 'width', 'area', 'estimated_depth', 'thickness',
        'cost_unit', 'cost', 'm2bottom_cost', 'm3protec_cost', 'active', 'label',
        'shape', 'acoeff', 'connect_cost', 'dr', 'code'
    ],
    'Table cat_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('cat_arc', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_arc', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('cat_arc', 'matcat_id', 'varchar(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('cat_arc', 'pnom', 'varchar(16)', 'Column pnom should be varchar(16)');
SELECT col_type_is('cat_arc', 'dnom', 'varchar(16)', 'Column dnom should be varchar(16)');
SELECT col_type_is('cat_arc', 'dint', 'numeric(12,5)', 'Column dint should be numeric(12,5)');
SELECT col_type_is('cat_arc', 'dext', 'numeric(12,5)', 'Column dext should be numeric(12,5)');
SELECT col_type_is('cat_arc', 'descript', 'varchar(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_arc', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_arc', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('cat_arc', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('cat_arc', 'svg', 'varchar(50)', 'Column svg should be varchar(50)');
SELECT col_type_is('cat_arc', 'z1', 'numeric(12,2)', 'Column z1 should be numeric(12,2)');
SELECT col_type_is('cat_arc', 'z2', 'numeric(12,2)', 'Column z2 should be numeric(12,2)');
SELECT col_type_is('cat_arc', 'width', 'numeric(12,2)', 'Column width should be numeric(12,2)');
SELECT col_type_is('cat_arc', 'area', 'numeric(12,4)', 'Column area should be numeric(12,4)');
SELECT col_type_is('cat_arc', 'estimated_depth', 'numeric(12,2)', 'Column estimated_depth should be numeric(12,2)');
SELECT col_type_is('cat_arc', 'thickness', 'numeric(12,2)', 'Column thickness should be numeric(12,2)');
SELECT col_type_is('cat_arc', 'cost_unit', 'varchar(3)', 'Column cost_unit should be varchar(3)');
SELECT col_type_is('cat_arc', 'cost', 'varchar(16)', 'Column cost should be varchar(16)');
SELECT col_type_is('cat_arc', 'm2bottom_cost', 'varchar(16)', 'Column m2bottom_cost should be varchar(16)');
SELECT col_type_is('cat_arc', 'm3protec_cost', 'varchar(16)', 'Column m3protec_cost should be varchar(16)');
SELECT col_type_is('cat_arc', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_arc', 'label', 'varchar(255)', 'Column label should be varchar(255)');
SELECT col_type_is('cat_arc', 'shape', 'varchar(30)', 'Column shape should be varchar(30)');
SELECT col_type_is('cat_arc', 'acoeff', 'float8', 'Column acoeff should be float8');
SELECT col_type_is('cat_arc', 'connect_cost', 'text', 'Column connect_cost should be text');
SELECT col_type_is('cat_arc', 'dr', 'int4', 'Column dr should be int4');
SELECT col_type_is('cat_arc', 'code', 'text', 'Column code should be text');

-- Check foreign keys
SELECT has_fk('cat_arc', 'Table cat_arc should have foreign keys');

SELECT fk_ok('cat_arc', 'arc_type', 'cat_feature_arc', 'id', 'FK arc_type → cat_feature_arc.id');
SELECT fk_ok('cat_arc', 'cost', 'plan_price', 'id', 'FK cost → plan_price.id');
SELECT fk_ok('cat_arc', 'm2bottom_cost', 'plan_price', 'id', 'FK m2bottom_cost → plan_price.id');
SELECT fk_ok('cat_arc', 'm3protec_cost', 'plan_price', 'id', 'FK m3protec_cost → plan_price.id');
SELECT fk_ok('cat_arc', 'shape', 'cat_arc_shape', 'id', 'FK shape → cat_arc_shape.id');
SELECT fk_ok('cat_arc', 'brand_id', 'cat_brand', 'id', 'FK brand_id → cat_brand.id');
SELECT fk_ok('cat_arc', 'model_id', 'cat_brand_model', 'id', 'FK model_id → cat_brand_model.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
