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
SELECT has_table('config_form_list'::name, 'Table config_form_list should exist');

-- check columns names 


SELECT columns_are(
    'config_form_list',
    ARRAY[
      'listname', 'query_text', 'device', 'listtype', 'listclass', 'vdefault', 'addparam'
    ],
    'Table config_form_list should have the correct columns'

);
-- check columns names
SELECT col_type_is('config_form_list', 'listname', 'varchar(50)', 'Column listname should be varchar(50)');
SELECT col_type_is('config_form_list', 'query_text', 'text', 'Column query_text should be text');
SELECT col_type_is('config_form_list', 'device', 'int2', 'Column device should be int2');
SELECT col_type_is('config_form_list', 'listtype', 'varchar(30)', 'Column listtype should be varchar(30)');
SELECT col_type_is('config_form_list', 'listclass', 'varchar(30)', 'Column listclass should be varchar(30)');
SELECT col_type_is('config_form_list', 'vdefault', 'json', 'Column vdefault should be json');
SELECT col_type_is('config_form_list', 'addparam', 'json', 'Column addparam should be json');




--check default values


-- check foreign keys


-- check indexes
SELECT has_index('config_form_list', 'listname', 'Table config_form_help should have index on listname');
SELECT has_index('config_form_list', 'listname', 'Table config_form_help should have index on listname');



--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;