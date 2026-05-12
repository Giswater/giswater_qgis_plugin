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

-- Check table cat_arc
SELECT has_table('cat_arc'::name, 'Table cat_arc should exist');

-- Check columns
SELECT columns_are(
    'cat_arc',
    ARRAY[
        'id', 'code', 'arc_type', 'matcat_id', 'pnom', 'dnom', 'dint', 'dext', 'descript', 'link', 'brand_id', 'model_id', 'svg', 'z1', 'z2', 'width', 'area', 'estimated_depth', 'thickness', 'cost_unit', 'cost', 'm2bottom_cost', 'm3protec_cost', 'active', 'label', 'shape', 'acoeff', 'connect_cost', 'dr'
    ],
    'Table cat_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_arc', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('cat_arc', 'id', 'character varying(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_arc', 'arc_type', 'character varying(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('cat_arc', 'matcat_id', 'character varying(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('cat_arc', 'pnom', 'character varying(16)', 'Column pnom should be varchar(16)');
SELECT col_type_is('cat_arc', 'dnom', 'character varying(16)', 'Column dnom should be varchar(16)');
SELECT col_type_is('cat_arc', 'dint', 'numeric(12,5)', 'Column dint should be numeric(12,5)');
SELECT col_type_is('cat_arc', 'dext', 'numeric(12,5)', 'Column dext should be numeric(12,5)');
SELECT col_type_is('cat_arc', 'descript', 'character varying(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_arc', 'link', 'character varying(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_arc', 'brand_id', 'character varying(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('cat_arc', 'model_id', 'character varying(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('cat_arc', 'svg', 'character varying(50)', 'Column svg should be varchar(50)');
SELECT col_type_is('cat_arc', 'z1', 'numeric(12,2)', 'Column z1 should be numeric(12,2)');
SELECT col_type_is('cat_arc', 'z2', 'numeric(12,2)', 'Column z2 should be numeric(12,2)');
SELECT col_type_is('cat_arc', 'width', 'numeric(12,2)', 'Column width should be numeric(12,2)');
SELECT col_type_is('cat_arc', 'area', 'numeric(12,4)', 'Column area should be numeric(12,4)');
SELECT col_type_is('cat_arc', 'estimated_depth', 'numeric(12,2)', 'Column estimated_depth should be numeric(12,2)');
SELECT col_type_is('cat_arc', 'thickness', 'numeric(12,2)', 'Column thickness should be numeric(12,2)');
SELECT col_type_is('cat_arc', 'cost_unit', 'character varying(3)', 'Column cost_unit should be varchar(3)');
SELECT col_type_is('cat_arc', 'cost', 'character varying(16)', 'Column cost should be varchar(16)');
SELECT col_type_is('cat_arc', 'm2bottom_cost', 'character varying(16)', 'Column m2bottom_cost should be varchar(16)');
SELECT col_type_is('cat_arc', 'm3protec_cost', 'character varying(16)', 'Column m3protec_cost should be varchar(16)');
SELECT col_type_is('cat_arc', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('cat_arc', 'label', 'character varying(255)', 'Column label should be varchar(255)');
SELECT col_type_is('cat_arc', 'shape', 'character varying(30)', 'Column shape should be varchar(30)');
SELECT col_type_is('cat_arc', 'acoeff', 'double precision', 'Column acoeff should be double precision');
SELECT col_type_is('cat_arc', 'connect_cost', 'text', 'Column connect_cost should be text');
SELECT col_type_is('cat_arc', 'dr', 'integer', 'Column dr should be integer');
SELECT col_type_is('cat_arc', 'code', 'text', 'Column dr should be text');

-- Check foreign keys
SELECT has_fk('cat_arc', 'Table cat_arc should have foreign keys');
SELECT fk_ok('cat_arc', 'arc_type', 'cat_feature_arc', 'id');
SELECT fk_ok('cat_arc', 'brand_id', 'cat_brand', 'id');
SELECT fk_ok('cat_arc', 'cost', 'plan_price', 'id');
SELECT fk_ok('cat_arc', 'm2bottom_cost', 'plan_price', 'id');
SELECT fk_ok('cat_arc', 'm3protec_cost', 'plan_price', 'id');
SELECT fk_ok('cat_arc', 'model_id', 'cat_brand_model', 'id');
SELECT fk_ok('cat_arc', 'shape', 'cat_arc_shape', 'id');

-- Check triggers
SELECT has_trigger('cat_arc', 'gw_trg_cat_material_fk_insert');
SELECT has_trigger('cat_arc', 'gw_trg_cat_material_fk_update');

-- Check indexes
SELECT has_index('cat_arc', 'cat_arc_cost_pkey', ARRAY['cost']);
SELECT has_index('cat_arc', 'cat_arc_m2bottom_cost_pkey', ARRAY['m2bottom_cost']);
SELECT has_index('cat_arc', 'cat_arc_m3protec_cost_pkey', ARRAY['m3protec_cost']);

-- Check rules

-- Check sequences

SELECT * FROM finish();

ROLLBACK;
