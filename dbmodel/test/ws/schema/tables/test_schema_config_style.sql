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

-- Check table config_style
SELECT has_table('config_style'::name, 'Table config_style should exist');

-- Check columns
SELECT columns_are(
    'config_style',
    ARRAY[
        'id', 'idval', 'descript', 'sys_role', 'addparam', 'is_templayer', 'active'
    ],
    'Table config_style should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_style', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('config_style', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('config_style', 'idval', 'text', 'Column idval should be text');
SELECT col_type_is('config_style', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('config_style', 'sys_role', 'varchar(30)', 'Column sys_role should be varchar(30)');
SELECT col_type_is('config_style', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('config_style', 'is_templayer', 'boolean', 'Column is_templayer should be boolean');
SELECT col_type_is('config_style', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT hasnt_fk('config_style', 'Table config_style should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_style', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('config_style', 'idval', 'Column idval should be NOT NULL');
SELECT col_default_is('config_style', 'is_templayer', 'false', 'Column is_templayer should default to false');
SELECT col_default_is('config_style', 'active', 'true', 'Column active should default to true');

SELECT * FROM finish();

ROLLBACK;
