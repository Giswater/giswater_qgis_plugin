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

-- Check table cat_node
SELECT has_table('cat_node'::name, 'Table cat_node should exist');

-- Check columns
SELECT columns_are(
    'cat_node',
    ARRAY[
        'id', 'code', 'node_type', 'matcat_id', 'pnom', 'dnom', 'dint', 'dext', 'shape', 'descript', 'link', 'brand_id', 'model_id', 'svg', 'estimated_depth', 'cost_unit', 'cost', 'active', 'label', 'ischange', 'acoeff'
    ],
    'Table cat_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_node', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('cat_node', 'id', 'character varying(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_node', 'node_type', 'character varying(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('cat_node', 'matcat_id', 'character varying(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('cat_node', 'pnom', 'character varying(16)', 'Column pnom should be varchar(16)');
SELECT col_type_is('cat_node', 'dnom', 'character varying(16)', 'Column dnom should be varchar(16)');
SELECT col_type_is('cat_node', 'dint', 'numeric(12,5)', 'Column dint should be numeric(12,5)');
SELECT col_type_is('cat_node', 'dext', 'numeric(12,5)', 'Column dext should be numeric(12,5)');
SELECT col_type_is('cat_node', 'shape', 'character varying(50)', 'Column shape should be varchar(50)');
SELECT col_type_is('cat_node', 'descript', 'character varying(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_node', 'link', 'character varying(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_node', 'brand_id', 'character varying(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('cat_node', 'model_id', 'character varying(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('cat_node', 'svg', 'character varying(50)', 'Column svg should be varchar(50)');
SELECT col_type_is('cat_node', 'estimated_depth', 'numeric(12,2)', 'Column estimated_depth should be numeric(12,2)');
SELECT col_type_is('cat_node', 'cost_unit', 'character varying(3)', 'Column cost_unit should be varchar(3)');
SELECT col_type_is('cat_node', 'cost', 'character varying(16)', 'Column cost should be varchar(16)');
SELECT col_type_is('cat_node', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('cat_node', 'label', 'character varying(255)', 'Column label should be varchar(255)');
SELECT col_type_is('cat_node', 'ischange', 'smallint', 'Column ischange should be smallint');
SELECT col_type_is('cat_node', 'acoeff', 'double precision', 'Column acoeff should be double precision');
SELECT col_type_is('cat_node', 'code', 'double precision', 'Column code should be double text');

-- Check foreign keys
SELECT has_fk('cat_node', 'Table cat_node should have foreign keys');
SELECT fk_ok('cat_node', 'brand_id', 'cat_brand', 'id', 'Column brand_id should reference cat_brand(id)');
SELECT fk_ok('cat_node', 'cost', 'plan_price', 'id', 'Column cost should reference plan_price(id)');
SELECT fk_ok('cat_node', 'model_id', 'cat_brand_model', 'id', 'Column model_id should reference cat_brand_model(id)');
SELECT fk_ok('cat_node', 'node_type', 'cat_feature_node', 'id', 'Column node_type should reference cat_feature_node(id)');

-- Check triggers
SELECT has_trigger('cat_node', 'gw_trg_cat_material_fk_insert', 'Table cat_node should have trigger gw_trg_cat_material_fk_insert');
SELECT has_trigger('cat_node', 'gw_trg_cat_material_fk_update', 'Table cat_node should have trigger gw_trg_cat_material_fk_update');
SELECT has_trigger('cat_node', 'gw_trg_edit_cat_node', 'Table cat_node should have trigger gw_trg_edit_cat_node');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_default_is('cat_node', 'cost_unit', 'u'::character varying, 'Column cost_unit should have default value');
SELECT col_default_is('cat_node', 'active', true, 'Column active should have default value');
SELECT col_default_is('cat_node', 'ischange', 2, 'Column ischange should have default value');
SELECT col_has_check('cat_node', 'ischange', 'Column ischange should have check constraint');
SELECT col_not_null('cat_node', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('cat_node', 'node_type', 'Column node_type should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
