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
SELECT has_table('config_function'::name, 'Table config_function should exist');

-- check columns names 


SELECT columns_are(
    'config_function',
    ARRAY[
      'id', 'function_name', 'style', 'layermanager', 'actions'
    ],
    'Table config_function should have the correct columns'

);
-- check columns names
SELECT col_type_is('config_function', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('config_function', 'function_name', 'text', 'Column function_name should be text');
SELECT col_type_is('config_function', 'style', 'json', 'Column style should be json');
SELECT col_type_is('config_function', 'layermanager', 'json', 'Column layermanager should be json');
SELECT col_type_is('config_function', 'actions', 'json', 'Column actions should be json');
;



--check default values


-- check foreign keys


-- check indexes
SELECT has_index('config_function', 'id', 'Table config_function should have index on id');






--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;