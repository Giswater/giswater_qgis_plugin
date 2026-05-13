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
SELECT has_table('sys_style'::name, 'Table sys_style should exist');

-- Check columns
SELECT columns_are(
    'sys_style',
    ARRAY[
        'layername', 'styleconfig_id', 'styletype', 'stylevalue', 'active'
    ],
    'Table sys_style should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_style', 'layername', 'text', 'Column layername should be text');
SELECT col_type_is('sys_style', 'styleconfig_id', 'int4', 'Column styleconfig_id should be int4');
SELECT col_type_is('sys_style', 'styletype', 'varchar(30)', 'Column styletype should be varchar(30)');
SELECT col_type_is('sys_style', 'stylevalue', 'text', 'Column stylevalue should be text');
SELECT col_type_is('sys_style', 'active', 'bool', 'Column active should be bool');

-- Check foreign keys
SELECT has_fk('sys_style', 'Table sys_style should have foreign keys');

SELECT fk_ok('sys_style', 'styleconfig_id', 'config_style', 'id', 'FK styleconfig_id → config_style.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
