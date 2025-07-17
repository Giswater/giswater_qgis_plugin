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
SELECT has_table('cat_dwf'::name, 'Table cat_dwf should exist');

-- check columns names 


SELECT columns_are(
    'cat_dwf',
    ARRAY[
       'id', 'idval', 'startdate', 'enddate', 'observ', 'active', 'expl_id', 'log'
    ],
    'Table cat_dwf should have the correct columns'
);
-- check columns names
SELECT col_type_is('cat_dwf', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('cat_dwf', 'idval', 'varchar(30)', 'Column idval should be varchar(30)');
SELECT col_type_is('cat_dwf', 'startdate', 'timestamp', 'Column startdate should be timestamp');
SELECT col_type_is('cat_dwf', 'enddate', 'timestamp', 'Column enddate should be timestamp');
SELECT col_type_is('cat_dwf', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('cat_dwf', 'active', 'bool', 'Column active should be bool');




SELECT col_type_is('cat_dwf', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('cat_dwf', 'log', 'text', 'Column log should be text');


--check default values



-- check foreign keys
SELECT has_fk('cat_dwf', 'Table cat_dwf should have foreign keys');
SELECT fk_ok('cat_dwf', 'expl_id', 'exploitation','expl_id','Table should have foreign key from expl_id to exploitation.expl_id');

-- check ind
SELECT has_index('cat_dwf', 'cat_dwf_scenario_pkey', 'id', 'Table cat_dwf should have index on id');
SELECT has_index('cat_dwf', 'cat_dwf_scenario_unique_idval', 'idval', 'Table cat_dwf should have index on idval');


--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;