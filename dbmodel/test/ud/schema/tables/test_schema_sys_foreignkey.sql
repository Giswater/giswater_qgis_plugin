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
SELECT has_table('sys_foreignkey'::name, 'Table sys_foreignkey should exist');

-- Check columns
SELECT columns_are(
    'sys_foreignkey',
    ARRAY[
        'typevalue_table', 'typevalue_name', 'target_table', 'target_field', 'parameter_id', 'active'
    ],
    'Table sys_foreignkey should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_foreignkey', 'typevalue_table', 'varchar(50)', 'Column typevalue_table should be varchar(50)');
SELECT col_type_is('sys_foreignkey', 'typevalue_name', 'varchar(50)', 'Column typevalue_name should be varchar(50)');
SELECT col_type_is('sys_foreignkey', 'target_table', 'varchar(50)', 'Column target_table should be varchar(50)');
SELECT col_type_is('sys_foreignkey', 'target_field', 'varchar(50)', 'Column target_field should be varchar(50)');
SELECT col_type_is('sys_foreignkey', 'parameter_id', 'int4', 'Column parameter_id should be int4');
SELECT col_type_is('sys_foreignkey', 'active', 'bool', 'Column active should be bool');

-- Finish
SELECT * FROM finish();

ROLLBACK;
