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
SELECT has_table('config_style'::name, 'Table config_style should exist');

-- check columns names 


SELECT columns_are(
    'config_style',
    ARRAY[
     'id', 'idval', 'descript', 'sys_role', 'addparam', 'is_templayer', 'active'
    ],
    'Table config_style should have the correct columns'

);
-- check columns names

SELECT col_type_is('config_style', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('config_style', 'idval', 'text', 'Column idval should be text');
SELECT col_type_is('config_style', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('config_style', 'sys_role', 'varchar(30)', 'Column sys_role should be varchar(30)');
SELECT col_type_is('config_style', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('config_style', 'is_templayer', 'bool', 'Column is_templayer should be bool');
SELECT col_type_is('config_style', 'active', 'bool', 'Column active should be bool');


--check default values


-- check foreign keys


-- check indexes
SELECT has_index('config_style', 'config_style_pkey', ARRAY['id'], 'Table config_style should have index on id');
SELECT has_index('config_style', 'idval_chk', ARRAY['idval'], 'Table config_style should have index on idval');




--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;