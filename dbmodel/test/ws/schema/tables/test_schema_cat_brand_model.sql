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

-- Check table cat_brand_model
SELECT has_table('cat_brand_model'::name, 'Table cat_brand_model should exist');

-- Check columns
SELECT columns_are(
    'cat_brand_model',
    ARRAY[
        'id', 'catbrand_id', 'descript', 'link', 'active', 'featurecat_id'
    ],
    'Table cat_brand_model should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_brand_model', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('cat_brand_model', 'id', 'character varying(50)', 'Column id should be varchar(50)');
SELECT col_type_is('cat_brand_model', 'catbrand_id', 'character varying(30)', 'Column catbrand_id should be varchar(30)');
SELECT col_type_is('cat_brand_model', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_brand_model', 'link', 'character varying(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_brand_model', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('cat_brand_model', 'featurecat_id', '_text', 'Column featurecat_id should be _text');

-- Check foreign keys
SELECT has_fk('cat_brand_model', 'Table cat_brand_model should have foreign keys');
SELECT fk_ok(
    'cat_brand_model', 'catbrand_id',
    'cat_brand', 'id',
    'Column catbrand_id should reference cat_brand(id)'
);

-- Check triggers
SELECT has_trigger('cat_brand_model', 'gw_trg_config_control', 'Table cat_brand_model should have trigger gw_trg_config_control');

-- Check rules

-- Check sequences

SELECT * FROM finish();

ROLLBACK;
