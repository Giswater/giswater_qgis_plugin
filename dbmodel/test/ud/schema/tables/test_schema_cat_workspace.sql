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
SELECT has_table('cat_workspace'::name, 'Table cat_workspace should exist');

-- check columns names 


SELECT columns_are(
    'cat_workspace',
    ARRAY[
      'id', '"name"', 'descript', 'config', 'private','active', 'iseditable', 'insert_user', 'insert_timestamp', 'lastupdate_user','lastupdate_timestamp'
    ],
    'Table cat_workspace should have the correct columns'
);
-- check columns names
SELECT col_type_is('cat_workspace', 'id', 'serial14', 'Column id should be serial14');
SELECT col_type_is('cat_workspace', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('cat_workspace', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_workspace', 'config', 'json', 'Column config should be json');
SELECT col_type_is('cat_workspace', 'private', 'bool', 'Column private should be bool');
SELECT col_type_is('cat_workspace', 'active', 'bool', 'Column active should be bool DEFAULT true');
SELECT col_type_is('cat_workspace', 'iseditable', 'bool', 'Column iseditable should be bool DEFAULT true');
SELECT col_type_is('cat_workspace', 'insert_user', 'text', 'Column insert_user should be text');
SELECT col_type_is('cat_workspace', 'insert_timestamp', 'timestamp', 'Column insert_timestamp should be timestamp');
SELECT col_type_is('cat_workspace', 'lastupdate_user', 'text', 'Column lastupdate_user should be text');
SELECT col_type_is('cat_workspace', 'lastupdate_timestamp', 'timestamp', 'Column lastupdate_timestamp should be timestamp');



--check default values
SELECT col_has_default('cat_workspace', 'active', 'Column active should have default value');
SELECT col_has_default('cat_workspace', 'iseditable', 'Column iseditable should have default value');
SELECT col_has_default('cat_workspace', 'insert_user', 'Column insert_user should have default value');
SELECT col_has_default('cat_workspace', 'insert_timestamp', 'Column insert_timestamp should have default value');
SELECT col_has_default('cat_workspace', 'lastupdate_user', 'Column lastupdate_user should have default value');
SELECT col_has_default('cat_workspace', 'lastupdate_timestamp', 'Column lastupdate_timestamp should have default value');

-- check foreign keys


-- check indexes
SELECT has_index('cat_workspace', 'id', 'Table cat_workspace should have index on id');
SELECT has_index('cat_workspace', 'name', 'Table cat_workspace should have index on name');


--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;