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

-- Check table sys_typevalue
SELECT has_table('sys_typevalue'::name, 'Table sys_typevalue should exist');

-- Check columns
SELECT columns_are(
    'sys_typevalue',
    ARRAY[
        'typevalue_table', 'typevalue_name'
    ],
    'Table sys_typevalue should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_typevalue', ARRAY['typevalue_table', 'typevalue_name'], 'Columns typevalue_table, typevalue_name should be primary key');

-- Check column types
SELECT col_type_is('sys_typevalue', 'typevalue_table', 'varchar(50)', 'Column typevalue_table should be varchar(50)');
SELECT col_type_is('sys_typevalue', 'typevalue_name', 'varchar(50)', 'Column typevalue_name should be varchar(50)');

-- Check constraints
SELECT col_not_null('sys_typevalue', 'typevalue_table', 'Column typevalue_table should be NOT NULL');
SELECT col_not_null('sys_typevalue', 'typevalue_name', 'Column typevalue_name should be NOT NULL');

-- Check trigger
SELECT has_trigger('sys_typevalue', 'gw_trg_typevalue_config_fk', 'Table sys_typevalue should have gw_trg_typevalue_config_fk trigger');

SELECT * FROM finish();

ROLLBACK;