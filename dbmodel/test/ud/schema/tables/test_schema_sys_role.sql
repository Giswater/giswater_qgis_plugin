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
SELECT has_table('sys_role'::name, 'Table sys_role should exist');

-- Check columns
SELECT columns_are(
    'sys_role',
    ARRAY[
        'id', 'context', 'descript'
    ],
    'Table sys_role should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_role', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('sys_role', 'context', 'varchar(30)', 'Column context should be varchar(30)');
SELECT col_type_is('sys_role', 'descript', 'text', 'Column descript should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
