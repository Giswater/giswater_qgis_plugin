/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table config_function
SELECT has_table('config_function'::name, 'Table config_function should exist');

-- Check columns
SELECT columns_are(
    'config_function',
    ARRAY[
        'id', 'function_name', 'style', 'layermanager', 'actions'
    ],
    'Table config_function should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_function', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('config_function', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('config_function', 'function_name', 'text', 'Column function_name should be text');
SELECT col_type_is('config_function', 'style', 'json', 'Column style should be json');
SELECT col_type_is('config_function', 'layermanager', 'json', 'Column layermanager should be json');
SELECT col_type_is('config_function', 'actions', 'json', 'Column actions should be json');

-- Check foreign keys
SELECT hasnt_fk('config_function', 'Table config_function should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_function', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('config_function', 'function_name', 'Column function_name should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
