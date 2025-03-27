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

-- Check table sys_role
SELECT has_table('sys_role'::name, 'Table sys_role should exist');

-- Check columns
SELECT columns_are(
    'sys_role',
    ARRAY[
        'id', 'context', 'descript'
    ],
    'Table sys_role should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_role', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('sys_role', 'id', 'character varying(30)', 'Column id should be character varying(30)');
SELECT col_type_is('sys_role', 'context', 'character varying(30)', 'Column context should be character varying(30)');
SELECT col_type_is('sys_role', 'descript', 'text', 'Column descript should be text');

-- Check constraints
SELECT col_not_null('sys_role', 'id', 'Column id should be NOT NULL');
SELECT col_has_check('sys_role', 'id', 'Table sys_role should have check constraint on id');
SELECT col_is_unique('sys_role', ARRAY['context'], 'Column context should be unique');

SELECT * FROM finish();

ROLLBACK;