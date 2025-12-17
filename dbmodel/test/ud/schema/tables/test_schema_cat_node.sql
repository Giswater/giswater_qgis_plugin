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

--check if table exists
SELECT has_table('cat_node'::name, 'Table cat_node should exist');

-- check columns names 


SELECT columns_are(
    'cat_node',
    ARRAY[
        'id', 'code', 'node_type', 'matcat_id', 'shape', 'geom1', 'geom2', 'geom3', 'descript', 'link', 'brand_id', 'model_id', 'svg', 
        'estimated_y', 'cost_unit', 'cost', 'active', 'label', 'acoeff'
    ],
    'Table cat_node should have the correct columns'
);
-- check columns names
SELECT col_type_is('cat_node', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_node', 'node_type', 'text', 'Column node_type should be text');
SELECT col_type_is('cat_node', 'matcat_id', 'varchar(16)', 'Column matcat_id should be varchar(16)');
SELECT col_type_is('cat_node', 'shape', 'varchar(50)', 'Column shape should be varchar(50)');
SELECT col_type_is('cat_node', 'geom1', 'numeric(12, 2)', 'Column geom1 should be numeric(12, 2) DEFAULT 0');
SELECT col_type_is('cat_node', 'geom2', 'numeric(12, 2)', 'Column geom2 should be numeric(12, 2) DEFAULT 0');
SELECT col_type_is('cat_node', 'geom3', 'numeric(12, 2)', 'Column geom3 should be numeric(12, 2) DEFAULT 0');
SELECT col_type_is('cat_node', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('cat_node', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_node', 'brand_id', 'varchar(30)', 'Column brand_id should be varchar(30)');
SELECT col_type_is('cat_node', 'model_id', 'varchar(30)', 'Column model_id should be varchar(30)');
SELECT col_type_is('cat_node', 'svg', 'varchar(50)', 'Column svg should be varchar(50)');
SELECT col_type_is('cat_node', 'estimated_y', 'numeric(12, 2)', 'Column estimated_y should be numeric(12, 2)');
SELECT col_type_is('cat_node', 'cost_unit', 'varchar(3)', 'Column cost_unit should be varchar(3) DEFAULT ''u''');
SELECT col_type_is('cat_node', 'cost', 'varchar(16)', 'Column cost should be varchar(16)');
SELECT col_type_is('cat_node', 'active', 'bool', 'Column active should be bool DEFAULT true');
SELECT col_type_is('cat_node', 'label', 'varchar(255)', 'Column label should be varchar(255)');
SELECT col_type_is('cat_node', 'acoeff', 'float8', 'Column acoeff should be float8');
SELECT col_type_is('cat_node', 'code', 'text', 'Column code should be text');


--check default values
SELECT col_has_default('cat_node', 'geom1', 'Column geom1 should have default value');
SELECT col_has_default('cat_node', 'geom2', 'Column geom2 should have default value');
SELECT col_has_default('cat_node', 'geom3', 'Column geom3 should have default value');
SELECT col_has_default('cat_node', 'cost_unit', 'Column cost_unit should have default value');
SELECT col_has_default('cat_node', 'active', 'Column active should have default value');

-- check foreign keys
SELECT has_fk('cat_hydrology', 'Table cat_hydrology should have foreign keys');

SELECT fk_ok('cat_node','brand_id','cat_brand','id','Table should have foreign key from brand_id to cat_brand.id');
SELECT fk_ok('cat_node','model_id','cat_brand_model','id','Table should have foreign key from model_id to cat_brand_model.id');
SELECT fk_ok('cat_node','cost','plan_price','id','Table should have foreign key from cost to plan_price.id');
SELECT fk_ok('cat_node','node_type','cat_feature_node','id','Table should have foreign key from node_type to cat_feature_node.id');
SELECT fk_ok('cat_node','shape','cat_node_shape','id','Table should have foreign key from shape to cat_node_shape.id');

-- check ind
SELECT has_index('cat_node', 'cat_node_pkey', ARRAY['id'], 'Table cat_node should have index on id');
SELECT has_index('cat_node', 'cat_node_cost_idx', ARRAY['cost'], 'Table cat_node should have index on cost');


--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;