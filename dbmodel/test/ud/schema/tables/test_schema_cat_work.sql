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
SELECT has_table('cat_work'::name, 'Table cat_work should exist');

-- check columns names 


SELECT columns_are(
    'cat_work',
    ARRAY[
      'id', 'descript', 'link', 'workid_key1', 'workid_key2', 'builtdate', 'workcost', 'active'
    ],
    'Table cat_work should have the correct columns'
);
-- check columns names
SELECT col_type_is('cat_work', 'id', 'varchar(255)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_work', 'descript', 'varchar(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_work', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_work', 'workid_key1', 'varchar(30)', 'Column workid_key1 should be varchar(30)');
SELECT col_type_is('cat_work', 'workid_key2', 'varchar(30)', 'Column workid_key2 should be varchar(30)');
SELECT col_type_is('cat_work', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('cat_work', 'workcost', 'float8', 'Column workcost should be float8');
SELECT col_type_is('cat_work', 'active', 'bool', 'Column active should be bool DEFAULT true');


--check default values
SELECT col_has_default('cat_work', 'active', 'Column active should have default value');


-- check foreign keys


-- check indexes
SELECT has_index('cat_work', 'cat_work_pkey', ARRAY['id'], 'Table cat_work should have index on id');

--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;