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
SELECT has_table('cat_hydrology'::name, 'Table cat_hydrology should exist');

-- check columns names 


SELECT columns_are(
    'cat_hydrology',
    ARRAY[
       'hydrology_id', '"name"', 'infiltration', '"text"', 'active', 'expl_id', 'log'
    ],
    'Table cat_hydrology should have the correct columns'
);
-- check columns names
SELECT col_type_is('cat_hydrology', 'hydrology_id', 'serial14', 'Column hydrology_id should be serial14');
SELECT col_type_is('cat_hydrology', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('cat_hydrology', 'infiltration', 'varchar(20)', 'Column infiltration should be varchar(20)');
SELECT col_type_is('cat_hydrology', 'text', 'varchar(255)', 'Column text should be varchar(255)');
SELECT col_type_is('cat_hydrology', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_hydrology', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('cat_hydrology', 'log', 'text', 'Column log should be text');



--check default values



-- check foreign keys
SELECT has_fk('cat_hydrology', 'Table cat_hydrology should have foreign keys');

SELECT fk_ok('cat_hydrology','expl_id','exploitation','expl_id','Table should have foreign key from expl_id to exploitation.expl_id');

-- check ind
SELECT has_index('cat_hydrology', 'hydrology_id', 'Table cat_hydrology should have index on hydrology_id');
SELECT has_index('cat_hydrology', 'name', 'Table cat_hydrology should have index on name');


--check trigger 
SELECT has_trigger('cat_hydrology', 'gw_trg_typevalue_fk_insert', 'Table cat_hydrology should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('cat_hydrology', 'gw_trg_typevalue_fk_update', 'Table cat_hydrology should have trigger gw_trg_typevalue_fk_update');

--check rule 

SELECT * FROM finish();

ROLLBACK;