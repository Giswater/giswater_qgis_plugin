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
SELECT has_table('sys_addfields'::name, 'Table sys_addfields should exist');

-- Check columns
SELECT columns_are(
    'sys_addfields',
    ARRAY[
        'id', 'param_name', 'cat_feature_id', 'is_mandatory', 'datatype_id', 'orderby',
        'active', 'iseditable', 'feature_type'
    ],
    'Table sys_addfields should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_addfields', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('sys_addfields', 'param_name', 'varchar(50)', 'Column param_name should be varchar(50)');
SELECT col_type_is('sys_addfields', 'cat_feature_id', 'varchar(30)', 'Column cat_feature_id should be varchar(30)');
SELECT col_type_is('sys_addfields', 'is_mandatory', 'bool', 'Column is_mandatory should be bool');
SELECT col_type_is('sys_addfields', 'datatype_id', 'text', 'Column datatype_id should be text');
SELECT col_type_is('sys_addfields', 'orderby', 'int4', 'Column orderby should be int4');
SELECT col_type_is('sys_addfields', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('sys_addfields', 'iseditable', 'bool', 'Column iseditable should be bool');
SELECT col_type_is('sys_addfields', 'feature_type', 'text', 'Column feature_type should be text');

-- Check foreign keys
SELECT has_fk('sys_addfields', 'Table sys_addfields should have foreign keys');

SELECT fk_ok('sys_addfields', 'cat_feature_id', 'cat_feature', 'id', 'FK cat_feature_id → cat_feature.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
