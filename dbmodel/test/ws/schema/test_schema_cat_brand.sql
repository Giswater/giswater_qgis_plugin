/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table cat_brand
SELECT has_table('cat_brand'::name, 'Table cat_brand should exist');

-- Check columns
SELECT columns_are(
    'cat_brand',
    ARRAY[
        'id', 'descript', 'link', 'active', 'featurecat_id'
    ],
    'Table cat_brand should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_brand', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('cat_brand', 'id', 'character varying(50)', 'Column id should be varchar(50)');
SELECT col_type_is('cat_brand', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_brand', 'link', 'character varying(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_brand', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('cat_brand', 'featurecat_id', '_text', 'Column featurecat_id should be _text');

-- Check foreign keys
SELECT hasnt_fk('cat_brand', 'Table cat_brand should have no foreign keys');

-- Check triggers
SELECT has_trigger('cat_brand', 'gw_trg_config_control', 'Table cat_brand should have trigger gw_trg_config_control');

-- Check rules

-- Check sequences

SELECT * FROM finish();

ROLLBACK;
