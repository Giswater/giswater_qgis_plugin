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

-- Check table config_param_user
SELECT has_table('config_param_user'::name, 'Table config_param_user should exist');

-- Check columns
SELECT columns_are(
    'config_param_user',
    ARRAY[
        'parameter', 'value', 'cur_user'
    ],
    'Table config_param_user should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_param_user', ARRAY['parameter', 'cur_user'], 'Columns parameter, cur_user should be primary key');

-- Check column types
SELECT col_type_is('config_param_user', 'parameter', 'varchar(50)', 'Column parameter should be varchar(50)');
SELECT col_type_is('config_param_user', 'value', 'text', 'Column value should be text');
SELECT col_type_is('config_param_user', 'cur_user', 'varchar(50)', 'Column cur_user should be varchar(50)');

-- Check indexes
SELECT has_index('config_param_user', 'config_param_user_cur_user', 'Should have index on cur_user');
SELECT has_index('config_param_user', 'config_param_user_value', 'Should have index on value');

-- Check foreign keys
SELECT hasnt_fk('config_param_user', 'Table config_param_user should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_param_user', 'parameter', 'Column parameter should be NOT NULL');
SELECT col_not_null('config_param_user', 'cur_user', 'Column cur_user should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
