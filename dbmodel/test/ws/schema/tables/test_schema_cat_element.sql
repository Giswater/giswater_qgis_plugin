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
        'id', 'element_type', 'matcat_id', 'geometry', 'descript', 'link',
        'brand', 'type', 'model', 'svg', 'active', 'geom1',
        'geom2', 'isdoublegeom', 'code'
    ],
    'Table cat_element should have the correct columns'
);

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

-- Check foreign keys
SELECT has_fk('cat_element', 'Table cat_element should have foreign keys');

SELECT fk_ok('cat_element', 'brand', 'cat_brand', 'id', 'FK brand → cat_brand.id');
SELECT fk_ok('cat_element', 'model', 'cat_brand_model', 'id', 'FK model → cat_brand_model.id');
SELECT fk_ok('cat_element', 'element_type', 'cat_feature_element', 'id', 'FK element_type → cat_feature_element.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
