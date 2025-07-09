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
SELECT has_table('config_form_tableview'::name, 'Table config_form_tableview should exist');

-- check columns names 


SELECT columns_are(
    'config_form_tableview',
    ARRAY[
      'location_type', 'project_type', 'objectname', 'columnname', 'columnindex', 'visible', 'width', 'alias', 'style', 'addparam'
    ],
    'Table config_form_tableview should have the correct columns'

);
-- check columns names
SELECT col_type_is('config_form_tableview', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('config_form_tableview', 'project_type', 'varchar(50)', 'Column project_type should be varchar(50)');
SELECT col_type_is('config_form_tableview', 'objectname', 'varchar(50)', 'Column objectname should be varchar(50)');
SELECT col_type_is('config_form_tableview', 'columnname', 'varchar(50)', 'Column columnname should be varchar(50)');
SELECT col_type_is('config_form_tableview', 'columnindex', 'int2', 'Column columnindex should be int2');
SELECT col_type_is('config_form_tableview', 'visible', 'bool', 'Column visible should be bool');
SELECT col_type_is('config_form_tableview', 'width', 'int4', 'Column width should be int4');
SELECT col_type_is('config_form_tableview', 'alias', 'varchar(50)', 'Column alias should be varchar(50)');
SELECT col_type_is('config_form_tableview', 'style', 'json', 'Column style should be json');
SELECT col_type_is('config_form_list', 'addparam', 'json', 'Column addparam should be json');



--check default values


-- check foreign keys


-- check indexes
SELECT has_index('config_form_tableview', 'columnname', 'Table config_form_tableview should have index on columnname');
SELECT has_index('config_form_tableview', 'objectname', 'Table config_form_tableview should have index on objectname');



--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;