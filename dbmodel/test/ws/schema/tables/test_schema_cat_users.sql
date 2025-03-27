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

-- Check table cat_users
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
SELECT col_type_is('cat_users', 'id', 'character varying(50)', 'Column id should be varchar(50)');
SELECT col_type_is('cat_users', 'name', 'character varying(150)', 'Column name should be varchar(150)');
SELECT col_type_is('cat_users', 'context', 'character varying(50)', 'Column context should be varchar(50)');
SELECT col_type_is('cat_users', 'sys_role', 'character varying(30)', 'Column sys_role should be varchar(30)');
SELECT col_type_is('cat_users', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('cat_users', 'external', 'boolean', 'Column external should be boolean');

-- Check foreign keys
SELECT has_fk('cat_users', 'Table cat_users should have foreign keys');
SELECT fk_ok('cat_users', 'sys_role', 'sys_role', 'id', 'Column sys_role should reference sys_role(id)');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_default_is('cat_users', 'active', true, 'Column active should have default value');
SELECT col_not_null('cat_users', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
