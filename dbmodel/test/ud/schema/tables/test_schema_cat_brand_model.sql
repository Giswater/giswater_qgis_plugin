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
SELECT has_table('cat_brand_model'::name, 'Table cat_brand_model should exist');

-- check columns names 


SELECT columns_are(
    'cat_brand_model',
    ARRAY[
       'id', 'catbrand_id', 'descript', 'link', 'active', 'featurecat_id'
    ],
    'Table cat_brand_model should have the correct columns'
);
-- check columns names
SELECT col_type_is('cat_brand_model', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_brand_model', 'catbrand_id', 'varchar(30)', 'Column catbrand_id should be varchar(30)');
SELECT col_type_is('cat_brand_model', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_brand_model', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_brand_model', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_brand_model', 'featurecat_id', 'text', 'Column featurecat_id should be text');




--check default values



-- check foreign keys
SELECT has_fk('cat_brand_model', 'Table cat_brand_model should have foreign keys');

SELECT fk_ok('cat_brand_model', 'catbrand_id', 'cat_brand', 'id', 'Table should have foreign key from catbrand_id to cat_brand.id');

-- check ind
SELECT has_index('cat_brand_model', 'id', 'Table cat_brand_model should have index on id');

--check trigger 
SELECT has_trigger('cat_brand_model', 'gw_trg_config_control', 'Table cat_brand_model should have trigger gw_trg_config_control');
--check rule 

SELECT * FROM finish();

ROLLBACK;