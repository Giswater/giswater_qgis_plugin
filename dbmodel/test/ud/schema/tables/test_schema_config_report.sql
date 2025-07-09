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
SELECT has_table('config_report'::name, 'Table config_report should exist');

-- check columns names 


SELECT columns_are(
    'config_report',
    ARRAY[
     'id', 'alias', 'query_text', 'addparam', 'filterparam', 'sys_role', 'descript', 'active', 'device'
    ],
    'Table config_report should have the correct columns'

);
-- check columns names

SELECT col_type_is('config_report', 'id', 'serial4', 'Column id should be serial4');
SELECT col_type_is('config_report', 'alias', 'text', 'Column alias should be text');
SELECT col_type_is('config_report', 'query_text', 'text', 'Column query_text should be text');
SELECT col_type_is('config_report', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('config_report', 'filterparam', 'json', 'Column filterparam should be json');
SELECT col_type_is('config_report', 'sys_role', 'text', 'Column sys_role should be text');
SELECT col_type_is('config_report', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('config_report', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('config_report', 'device', '_int4', 'Column device should be _int4');


--check default values


-- check foreign keys
SELECT fk_ok('config_report','sys_role', 'sys_role','id','Table should have foreign key from sys_role to sys_role.id');

-- check indexes
SELECT has_index('config_report', 'id', 'Table config_report should have index on id');





--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;