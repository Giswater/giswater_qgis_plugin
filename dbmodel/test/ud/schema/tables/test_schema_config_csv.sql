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
SELECT has_table('config_csv'::name, 'Table config_csv should exist');

-- check columns names 


SELECT columns_are(
    'config_csv',
    ARRAY[
      'fid', '"alias"', 'descript', 'functionname','active', 'orderby', 'addparam', 
    ],
    'Table config_csv should have the correct columns'
);
-- check columns names
SELECT col_type_is('config_csv', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('config_csv', 'alias', 'text', 'Column alias should be text');
SELECT col_type_is('config_csv', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('config_csv', 'functionname', 'varchar(50)', 'Column functionname should be varchar(50)');
SELECT col_type_is('config_csv', 'active', 'bool', 'Column active should be bool DEFAULT true');
SELECT col_type_is('config_csv', 'orderby', 'int4', 'Column orderby should be int4');
SELECT col_type_is('config_csv', 'addparam', 'json', 'Column addparam should be json');




--check default values
SELECT col_has_default('config_csv', 'fid', 'Column fid should have default value');
SELECT col_has_default('config_csv', 'active', 'Column active should have default value');


-- check foreign keys


-- check indexes
SELECT has_index('config_csv', 'fid', 'Table config_csv should have index on fid');



--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;