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
SELECT has_table('cat_users'::name, 'Table cat_users should exist');

-- Check columns
SELECT columns_are(
    'cat_users',
    ARRAY[
        'id', 'name', 'context', 'sys_role', 'active', 'external'
    ],
    'Table cat_users should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_users', 'id', 'Column id should be primary key'); 

-- Check column types
SELECT col_type_is('cat_users', 'id', 'varchar(50)', 'Column id should be varchar(50)');
SELECT col_type_is('cat_users', 'name', 'varchar(150)', 'Column name should be varchar(150)');
SELECT col_type_is('cat_users', 'context', 'varchar(50)', 'Column context should be varchar(50)');
SELECT col_type_is('cat_users', 'sys_role', 'varchar(30)', 'Column sys_role should be varchar(30)');
SELECT col_type_is('cat_users', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_users', 'external', 'bool', 'Column external should be bool');

-- Check default values
SELECT col_has_default('cat_users', 'active', 'Column active should have default value');

-- Check foreign keys
SELECT has_fk('cat_users', 'Table cat_users should have foreign keys');

SELECT fk_ok('cat_users', 'sys_role', 'sys_role', 'id', 'Table should have foreign key from sys_role to sys_role.id');

-- Check indexes
SELECT has_index('cat_users', 'cat_users_pkey', ARRAY['id'], 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;