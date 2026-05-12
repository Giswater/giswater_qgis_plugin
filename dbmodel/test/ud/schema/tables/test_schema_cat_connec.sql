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
SELECT has_table('cat_connec'::name, 'Table cat_connec should exist');

-- check columns names 


SELECT columns_are(
    'cat_connec',
    ARRAY[
       'id', 'code', 'connec_type', 'matcat_id', 'shape', 'geom1', 'geom2', 'geom3', 'geom4', 'geom_r', 'descript', 'link', 'brand_id', 'model_id', 'svg', 'active', 'label', 'estimated_depth'
    ],
    'Table cat_connec should have the correct columns'
);
-- check columns names
SELECT col_type_is('cat_connec', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_connec', 'connec_type', 'text', 'Column connec_type should be text');
SELECT col_type_is('cat_connec', 'matcat_id', 'varchar(16)', 'Column matcat_id should be varchar(16)');
SELECT col_type_is('cat_connec', 'shape', 'varchar(16)', 'Column shape should be varchar(16)');
SELECT col_type_is('cat_connec', 'geom1', 'numeric(12, 4)', 'Column geom1 should be numeric(12, 4)');
SELECT col_type_is('cat_connec', 'geom2', 'numeric(12, 4)', 'Column geom2 should be numeric(12, 4)');
SELECT col_type_is('cat_connec', 'geom3', 'numeric(12, 4)', 'Column geom3 should be numeric(12, 4)');
SELECT col_type_is('cat_connec', 'geom4', 'numeric(12, 4)', 'Column geom4 should be numeric(12, 4)');
SELECT col_type_is('cat_connec', 'geom_r', 'varchar(20)', 'Column geom_r should be varchar(20)');
SELECT col_type_is('cat_connec', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('cat_connec', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_connec', 'brand_id', 'varchar(30)', 'Column brand_id should be varchar(30)');
SELECT col_type_is('cat_connec', 'model_id', 'varchar(30)', 'Column model_id should be varchar(30)');
SELECT col_type_is('cat_connec', 'svg', 'varchar(50)', 'Column svg should be varchar(50)');
SELECT col_type_is('cat_connec', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_connec', 'label', 'varchar(255)', 'Column label should be varchar(255)');
SELECT col_type_is('cat_connec', 'estimated_depth', 'numeric(12, 3)', 'Column estimated_depth should be numeric(12, 3)');
SELECT col_type_is('cat_connec', 'code', 'text', 'Column code should be text');




--check default values
SELECT col_has_default('cat_connec', 'geom1', 'Column geom1 should have default value'); 
SELECT col_has_default('cat_connec', 'geom2', 'Column geom2 should have default value'); 
SELECT col_has_default('cat_connec', 'geom3', 'Column geom3 should have default value'); 
SELECT col_has_default('cat_connec', 'geom4', 'Column geom4 should have default value');


-- check foreign keys
SELECT has_fk('cat_connec', 'Table cat_connec should have foreign keys');

SELECT fk_ok('cat_connec','brand_id','cat_brand','id','Table should have foreign key from brand_id to cat_brand.id');
SELECT fk_ok('cat_connec', 'connec_type', 'cat_feature_connec', 'id', 'Table should have foreign key from connec_type to cat_feature_connec.id');
SELECT fk_ok('cat_connec', 'model_id', 'cat_brand_model', 'id', 'Table should have foreign key from model_id to cat_brand_model.id');
-- check ind
SELECT has_index('cat_connec', 'cat_connec_pkey', ARRAY['id'], 'Table cat_connec should have index on id');

--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;