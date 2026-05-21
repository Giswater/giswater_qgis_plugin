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

-- Check table
SELECT has_table('config_param_user'::name, 'Table config_param_user should exist');

-- Check columns
SELECT columns_are(
    'config_param_user',
    ARRAY[
        'parameter', 'value', 'cur_user'
    ],
    'Table config_param_user should have the correct columns'
);

-- Check column types
SELECT col_type_is('config_param_user', 'parameter', 'varchar(50)', 'Column parameter should be varchar(50)');
SELECT col_type_is('config_param_user', 'value', 'text', 'Column value should be text');
SELECT col_type_is('config_param_user', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
