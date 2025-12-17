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
SELECT has_table('cat_element'::name, 'Table cat_element should exist');

-- Check columns
SELECT columns_are(
    'cat_element',
    ARRAY[
        'id', 'code', 'element_type', 'matcat_id', 'geometry', 'descript', 'link', 'brand', 'type', 
        'model', 'svg', 'active', 'geom1', 'geom2', 'isdoublegeom'
    ],
    'Table cat_element should have the correct columns'
);


-- Check primary key
SELECT col_is_pk('cat_element', 'id', 'Column id should be primary key'); 

-- Check column types
SELECT col_type_is('cat_element', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_element', 'element_type', 'varchar(30)', 'Column element_type should be varchar(30)');
SELECT col_type_is('cat_element', 'matcat_id', 'varchar(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('cat_element', 'geometry', 'varchar(30)', 'Column geometry should be varchar(30)');
SELECT col_type_is('cat_element', 'descript', 'varchar(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_element', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_element', 'brand', 'varchar(30)', 'Column brand should be varchar(30)');
SELECT col_type_is('cat_element', 'type', 'varchar(30)', 'Column type should be varchar(30)');
SELECT col_type_is('cat_element', 'model', 'varchar(30)', 'Column model should be varchar(30)');
SELECT col_type_is('cat_element', 'svg', 'varchar(50)', 'Column svg should be varchar(50)');
SELECT col_type_is('cat_element', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_element', 'geom1', 'numeric(12,3)', 'Column geom1 should be numeric(12,3)');
SELECT col_type_is('cat_element', 'geom2', 'numeric(12,3)', 'Column geom2 should be numeric(12,3)');
SELECT col_type_is('cat_element', 'isdoublegeom', 'bool', 'Column isdoublegeom should be bool');
SELECT col_type_is('cat_element', 'code', 'text', 'Column code should be text');

-- Check default values
SELECT col_has_default('cat_element', 'active', 'Column active should have default value');

-- Check foreign keys
SELECT has_fk('cat_element', 'Table cat_element should have foreign keys');


SELECT fk_ok('cat_element', 'brand', 'cat_brand', 'id', 'Table should have foreign key from brand to cat_brand.id');
SELECT fk_ok('cat_element', 'element_type', 'cat_feature_element', 'id', 'Table should have foreign key from element_type to cat_feature_element.id');
SELECT fk_ok('cat_element', 'model', 'cat_brand_model', 'id', 'Table should have foreign key from model to cat_brand_model.id');

-- Check indexes
SELECT has_index('cat_element', 'cat_element_pkey', ARRAY['id'], 'Table should have index on id');

-- Check triggers
SELECT has_trigger('cat_element', 'gw_trg_cat_material_fk_insert', 'Table should have trigger gw_trg_cat_material_fk_insert');
SELECT has_trigger('cat_element', 'gw_trg_cat_material_fk_update', 'Table should have trigger gw_trg_cat_material_fk_update');

-- Finish
SELECT * FROM finish();

ROLLBACK;