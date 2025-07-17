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
SELECT has_table('config_form_help'::name, 'Table config_form_help should exist');

-- check columns names 


SELECT columns_are(
    'config_form_help',
    ARRAY[
      'fortype', 'formname', 'tabname', 'path'
    ],
    'Table config_form_help should have the correct columns'
);
-- check columns names
SELECT col_type_is('config_form_help', 'formname', 'varchar(50)', 'Column formname should be varchar(50)');
SELECT col_type_is('config_form_help', 'formtype', 'varchar(50)', 'Column formtype should be varchar(50)');
SELECT col_type_is('config_form_help', 'tabname', 'varchar(30)', 'Column tabname should be varchar(30)');
SELECT col_type_is('config_form_help', 'path', 'text', 'Column path should be text');




--check default values
SELECT col_has_default('config_form_help', 'formtype', 'Column formtype should have default value');


-- check foreign keys


-- check indexes
SELECT has_index('config_form_help', 'formname', 'Table config_form_help should have index on formname');
SELECT has_index('config_form_help', 'formtype', 'Table config_form_help should have index on formtype');
SELECT has_index('config_form_help', 'tabname', 'Table config_form_help should have index on tabname');


--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;