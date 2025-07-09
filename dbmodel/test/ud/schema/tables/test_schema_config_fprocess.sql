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
SELECT has_table('config_fprocess'::name, 'Table config_fprocess should exist');

-- check columns names 


SELECT columns_are(
    'config_fprocess',
    ARRAY[
      'fid', 'tablename', 'target', 'querytext', 'orderby', 'addparam', 'active'
    ],
    'Table config_fprocess should have the correct columns'

);
-- check columns names
SELECT col_type_is('config_fprocess', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('config_fprocess', 'tablename', 'text', 'Column tablename should be text');
SELECT col_type_is('config_fprocess', 'target', 'text', 'Column target should be text');
SELECT col_type_is('config_fprocess', 'querytext', 'text', 'Column querytext should be text');
SELECT col_type_is('config_fprocess', 'orderby', 'int4', 'Column orderby should be int4');
SELECT col_type_is('config_fprocess', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('config_fprocess', 'active', 'bool', 'Column active should be bool');

	,

--check default values


-- check foreign keys


-- check indexes
SELECT has_index('config_fprocess', 'fid', 'Table config_fprocess should have index on fid');
SELECT has_index('config_fprocess', 'tablename', 'Table config_fprocess should have index on tablename');
SELECT has_index('config_fprocess', 'target', 'Table config_fprocess should have index on target');





--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;