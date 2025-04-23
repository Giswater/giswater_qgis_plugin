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

-- Check table sys_style
SELECT has_table('sys_style'::name, 'Table sys_style should exist');

-- Check columns
SELECT columns_are(
    'sys_style',
    ARRAY[
        'layername', 'styleconfig_id', 'styletype', 'stylevalue', 'active'
    ],
    'Table sys_style should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_style', ARRAY['layername', 'styleconfig_id'], 'Columns layername, styleconfig_id should be primary key');

-- Check column types
SELECT col_type_is('sys_style', 'layername', 'text', 'Column layername should be text');
SELECT col_type_is('sys_style', 'styleconfig_id', 'integer', 'Column styleconfig_id should be integer');
SELECT col_type_is('sys_style', 'styletype', 'character varying(30)', 'Column styletype should be character varying(30)');
SELECT col_type_is('sys_style', 'stylevalue', 'text', 'Column stylevalue should be text');
SELECT col_type_is('sys_style', 'active', 'boolean', 'Column active should be boolean');

-- Check default values
SELECT col_default_is('sys_style', 'active', 'true', 'Column active should default to true');

-- Check constraints
SELECT col_not_null('sys_style', 'layername', 'Column layername should be NOT NULL');
SELECT col_not_null('sys_style', 'styleconfig_id', 'Column styleconfig_id should be NOT NULL');

-- Check foreign keys
SELECT has_fk('sys_style', 'Table sys_style should have foreign keys');
SELECT fk_ok('sys_style', 'styleconfig_id', 'config_style', 'id', 'FK styleconfig_id should reference config_style.id');

SELECT * FROM finish();

ROLLBACK; 