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
SELECT has_table('cat_brand'::name, 'Table cat_brand should exist');

-- check columns names 


SELECT columns_are(
    'cat_brand',
    ARRAY[
       'id', 'descript', 'link', 'active', 'featurecat_id'
    ],
    'Table cat_brand should have the correct columns'
);
-- check columns names
SELECT col_type_is('cat_brand', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_brand', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_brand', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_brand', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_brand', 'featurecat_id', 'text', 'Column featurecat_id should be text');




--check default values



-- check foreign keys


-- check ind
SELECT has_index('cat_brand', 'id', 'Table cat_brand should have index on id');

--check trigger 
SELECT has_trigger('cat_brand', 'gw_trg_config_control', 'Table cat_brand should have trigger gw_trg_config_control');
--check rule 

SELECT * FROM finish();

ROLLBACK;