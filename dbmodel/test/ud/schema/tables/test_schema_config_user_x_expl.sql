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
SELECT has_table('config_user_x_expl'::name, 'Table config_user_x_expl should exist');

-- check columns names 


SELECT columns_are(
    'config_user_x_expl',
    ARRAY[
     'expl_id', 'username'
    ],
    'Table config_user_x_expl should have the correct columns'

);
-- check columns names

SELECT col_type_is('config_user_x_expl', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('config_user_x_expl', 'username', 'varchar(50)', 'Column username should be varchar(50)');


--check default values


-- check foreign keys
SELECT has_fk('config_user_x_expl', 'Table config_user_x_expl should have foreign keys');
SELECT fk_ok('config_user_x_expl','expl_id','exploitation','expl_id','Table should have foreign key from expl_id to exploitation.expl_id');

-- check indexes
SELECT has_index('config_user_x_expl', 'config_user_x_expl_pkey', ARRAY['expl_id','username'], 'Table config_user_x_expl should have index on expl_id, username');

--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;