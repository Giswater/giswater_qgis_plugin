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
    ARRAY['id', 'code', 'arc_type','matcat_id','shape','geom1','geom2','geom3','geom4','geom5','geom6',
        'geom7','geom8','geom_r','descript','link','brand_id','model_id','svg','z1','z2','width','area',
        'estimated_depth','thickness','cost_unit','cost','m2bottom_cost','m3protec_cost','active','label',
        'tsect_id','curve_id','acoeff','connect_cost','visitability_vdef'
    ],
    'Table cat_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_arc', 'id', 'Column id should be primary key'); 

-- Check check columns

-- Check column types
SELECT col_type_is('cat_arc', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_arc', 'arc_type', 'text', 'Column arc_type should be text');
SELECT col_type_is('cat_arc', 'matcat_id', 'varchar(16)', 'Column matcat_id should be varchar(16)');
SELECT col_type_is('cat_arc', 'shape', 'varchar(16)', 'Column shape should be varchar(16)');
SELECT col_type_is('cat_arc', 'geom1', 'numeric(12,4)', 'Column geom1 should be numeric(12,4)');
SELECT col_type_is('cat_arc', 'geom2', 'numeric(12,4)', 'Column geom2 should be numeric(12,4)');
SELECT col_type_is('cat_arc', 'geom3', 'numeric(12,4)', 'Column geom3 should be numeric(12,4)');
SELECT col_type_is('cat_arc', 'geom4', 'numeric(12,4)', 'Column geom4 should be numeric(12,4)');
SELECT col_type_is('cat_arc', 'geom5', 'numeric(12,4)', 'Column geom5 should be numeric(12,4)');
SELECT col_type_is('cat_arc', 'geom6', 'numeric(12,4)', 'Column geom6 should be numeric(12,4)');
SELECT col_type_is('cat_arc', 'geom7', 'numeric(12,4)', 'Column geom7 should be numeric(12,4)');
SELECT col_type_is('cat_arc', 'geom8', 'numeric(12,4)', 'Column geom8 should be numeric(12,4)');
SELECT col_type_is('cat_arc', 'geom_r', 'varchar(20)', 'Column geom_r should be varchar(20)');
SELECT col_type_is('cat_arc', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('cat_arc', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_arc', 'brand_id', 'varchar(30)', 'Column brand_id should be varchar(30)');
SELECT col_type_is('cat_arc', 'model_id', 'varchar(30)', 'Column model_id should be varchar(30)');
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
SELECT col_type_is('cat_arc', 'tsect_id', 'varchar(16)', 'Column tsect_id should be varchar(16)');
SELECT col_type_is('cat_arc', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('cat_arc', 'acoeff', 'float8', 'Column acoeff should be float8');
SELECT col_type_is('cat_arc', 'connect_cost', 'text', 'Column connect_cost should be text');
SELECT col_type_is('cat_arc', 'visitability_vdef', 'int4', 'Column visitability_vdef should be int4');
SELECT col_type_is('cat_arc', 'code', 'text', 'Column code should be text');

-- Check default values
SELECT col_has_default('cat_arc', 'geom2', 'Column geom2 should have default value');
SELECT col_has_default('cat_arc', 'geom3', 'Column geom3 should have default value');
SELECT col_has_default('cat_arc', 'geom4', 'Column geom4 should have default value');
SELECT col_has_default('cat_arc', 'cost_unit', 'Column cost_unit should have default value');
SELECT col_has_default('cat_arc', 'active', 'Column active should have default value');

-- Check foreign keys
SELECT has_fk('cat_arc', 'Table cat_arc should have foreign keys');

SELECT fk_ok('cat_arc', 'arc_type', 'cat_feature_arc', 'id', 'Table should have foreign key from arc_type to cat_feature_arc.id');
SELECT fk_ok('cat_arc', 'brand_id', 'cat_brand', 'id', 'Table should have foreign key from brand_id to cat_brand.id');
SELECT fk_ok('cat_arc', 'cost', 'plan_price', 'id', 'Table should have foreign key from cost to plan_price.id');
SELECT fk_ok('cat_arc', 'curve_id', 'inp_curve', 'id', 'Table should have foreign key from curve_id to inp_curve.id');
SELECT fk_ok('cat_arc', 'm2bottom_cost', 'plan_price', 'id', 'Table should have foreign key from m2bottom_cost to plan_price.id');
SELECT fk_ok('cat_arc', 'm3protec_cost', 'plan_price', 'id', 'Table should have foreign key from m3protec_cost to plan_price.id');
SELECT fk_ok('cat_arc', 'model_id', 'cat_brand_model', 'id', 'Table should have foreign key from model_id to cat_brand_model.id');
SELECT fk_ok('cat_arc', 'shape', 'cat_arc_shape', 'id', 'Table should have foreign key from shape to cat_arc_shape.id');
SELECT fk_ok('cat_arc', 'tsect_id', 'inp_transects', 'id', 'Table should have foreign key from tsect_id to inp_transects.id');

-- Check indexes
SELECT has_index('cat_arc', 'cat_arc_pkey', ARRAY['id'], 'Table should have index on id');
SELECT has_index('cat_arc', 'cat_arc_cost_idx', ARRAY['cost'], 'Table should have index on cost');
SELECT has_index('cat_arc', 'cat_arc_m2bottom_cost_idx', ARRAY['m2bottom_cost'], 'Table should have index on m2bottom_cost');
SELECT has_index('cat_arc', 'cat_arc_m3protec_cost_idx', ARRAY['m3protec_cost'], 'Table should have index on m3protec_cost');

-- Finish
SELECT * FROM finish();

ROLLBACK;