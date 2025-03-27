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

-- Check table sys_foreignkey
SELECT has_table('sys_foreignkey'::name, 'Table sys_foreignkey should exist');

-- Check columns
SELECT columns_are(
    'sys_foreignkey',
    ARRAY[
        'typevalue_table', 'typevalue_name', 'target_table', 'target_field', 'parameter_id', 'active'
    ],
    'Table sys_foreignkey should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_foreignkey', ARRAY['typevalue_table', 'typevalue_name', 'target_table', 'target_field'], 
    'Columns typevalue_table, typevalue_name, target_table, target_field should be primary key');

-- Check column types
SELECT col_type_is('sys_foreignkey', 'typevalue_table', 'character varying(50)', 'Column typevalue_table should be character varying(50)');
SELECT col_type_is('sys_foreignkey', 'typevalue_name', 'character varying(50)', 'Column typevalue_name should be character varying(50)');
SELECT col_type_is('sys_foreignkey', 'target_table', 'character varying(50)', 'Column target_table should be character varying(50)');
SELECT col_type_is('sys_foreignkey', 'target_field', 'character varying(50)', 'Column target_field should be character varying(50)');
SELECT col_type_is('sys_foreignkey', 'parameter_id', 'integer', 'Column parameter_id should be integer');
SELECT col_type_is('sys_foreignkey', 'active', 'boolean', 'Column active should be boolean');

-- Check default values
SELECT col_default_is('sys_foreignkey', 'active', 'true', 'Column active should default to true');

-- Check constraints
SELECT col_not_null('sys_foreignkey', 'typevalue_table', 'Column typevalue_table should be NOT NULL');
SELECT col_not_null('sys_foreignkey', 'typevalue_name', 'Column typevalue_name should be NOT NULL');
SELECT col_not_null('sys_foreignkey', 'target_table', 'Column target_table should be NOT NULL');
SELECT col_not_null('sys_foreignkey', 'target_field', 'Column target_field should be NOT NULL');

-- Check triggers
SELECT has_trigger('sys_foreignkey', 'gw_trg_typevalue_config_fk', 'Table sys_foreignkey should have gw_trg_typevalue_config_fk trigger');

SELECT * FROM finish();

ROLLBACK; 