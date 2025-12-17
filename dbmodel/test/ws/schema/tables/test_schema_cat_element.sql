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

-- Check table cat_element
SELECT has_table('cat_element'::name, 'Table cat_element should exist');

-- Check columns
SELECT columns_are(
    'cat_element',
    ARRAY[
        'id', 'code', 'element_type', 'matcat_id', 'geometry', 'descript', 'link', 'brand', 'type', 'model', 'svg', 'active', 'geom1', 'geom2', 'isdoublegeom'
    ],
    'Table cat_element should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_element', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('cat_element', 'id', 'character varying(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_element', 'element_type', 'character varying(30)', 'Column element_type should be varchar(30)');
SELECT col_type_is('cat_element', 'matcat_id', 'character varying(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('cat_element', 'geometry', 'character varying(30)', 'Column geometry should be varchar(30)');
SELECT col_type_is('cat_element', 'descript', 'character varying(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_element', 'link', 'character varying(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_element', 'brand', 'character varying(30)', 'Column brand should be varchar(30)');
SELECT col_type_is('cat_element', 'type', 'character varying(30)', 'Column type should be varchar(30)');
SELECT col_type_is('cat_element', 'model', 'character varying(30)', 'Column model should be varchar(30)');
SELECT col_type_is('cat_element', 'svg', 'character varying(50)', 'Column svg should be varchar(50)');
SELECT col_type_is('cat_element', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('cat_element', 'geom1', 'numeric(12,3)', 'Column geom1 should be numeric(12,3)');
SELECT col_type_is('cat_element', 'geom2', 'numeric(12,3)', 'Column geom2 should be numeric(12,3)');
SELECT col_type_is('cat_element', 'isdoublegeom', 'boolean', 'Column isdoublegeom should be boolean');
SELECT col_type_is('cat_element', 'code', 'text', 'Column text should be text');

-- Check foreign keys
SELECT has_fk('cat_element', 'Table cat_element should have foreign keys');
SELECT fk_ok(
    'cat_element', 'brand',
    'cat_brand', 'id',
    'Column brand should reference cat_brand(id)'
);
SELECT fk_ok(
    'cat_element', 'element_type',
    'cat_feature_element', 'id',
    'Column element_type should reference cat_feature_element(id)'
);
SELECT fk_ok(
    'cat_element', 'model',
    'cat_brand_model', 'id',
    'Column model should reference cat_brand_model(id)'
);

-- Check triggers
SELECT has_trigger('cat_element', 'gw_trg_cat_material_fk_insert', 'Table cat_element should have trigger gw_trg_cat_material_fk_insert');
SELECT has_trigger('cat_element', 'gw_trg_cat_material_fk_update', 'Table cat_element should have trigger gw_trg_cat_material_fk_update');

-- Check rules

-- Check sequences

SELECT * FROM finish();

ROLLBACK;
