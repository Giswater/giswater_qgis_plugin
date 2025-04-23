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

-- Check table sys_addfields
SELECT has_table('sys_addfields'::name, 'Table sys_addfields should exist');

-- Check columns
SELECT columns_are(
    'sys_addfields',
    ARRAY[
        'id', 'param_name', 'cat_feature_id', 'is_mandatory', 'datatype_id', 'orderby', 'active', 'iseditable', 'feature_type'
    ],
    'Table sys_addfields should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_addfields', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('sys_addfields', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('sys_addfields', 'param_name', 'character varying(50)', 'Column param_name should be character varying(50)');
SELECT col_type_is('sys_addfields', 'cat_feature_id', 'character varying(30)', 'Column cat_feature_id should be character varying(30)');
SELECT col_type_is('sys_addfields', 'is_mandatory', 'boolean', 'Column is_mandatory should be boolean');
SELECT col_type_is('sys_addfields', 'datatype_id', 'text', 'Column datatype_id should be text');
SELECT col_type_is('sys_addfields', 'orderby', 'integer', 'Column orderby should be integer');
SELECT col_type_is('sys_addfields', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('sys_addfields', 'iseditable', 'boolean', 'Column iseditable should be boolean');
SELECT col_type_is('sys_addfields', 'feature_type', 'text', 'Column feature_type should be text');

-- Check default values
SELECT col_default_is('sys_addfields', 'active', 'true', 'Column active should default to true');

-- Check constraints
SELECT col_not_null('sys_addfields', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('sys_addfields', 'param_name', 'Column param_name should be NOT NULL');
SELECT col_not_null('sys_addfields', 'is_mandatory', 'Column is_mandatory should be NOT NULL');
SELECT col_not_null('sys_addfields', 'datatype_id', 'Column datatype_id should be NOT NULL');
SELECT col_is_unique('sys_addfields', ARRAY['param_name', 'cat_feature_id'], 'Columns param_name, cat_feature_id should be unique');
SELECT col_has_check('sys_addfields', 'feature_type', 'Table sys_addfields should have check constraint on feature_type');

-- Check foreign keys
SELECT has_fk('sys_addfields', 'Table sys_addfields should have foreign keys');
SELECT fk_ok('sys_addfields', 'cat_feature_id', 'cat_feature', 'id', 'FK cat_feature_id should reference cat_feature.id');

-- Check triggers
SELECT has_trigger('sys_addfields', 'gw_trg_sysaddfields', 'Table sys_addfields should have gw_trg_sysaddfields trigger');
SELECT has_trigger('sys_addfields', 'gw_trg_typevalue_fk_insert', 'Table sys_addfields should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('sys_addfields', 'gw_trg_typevalue_fk_update', 'Table sys_addfields should have gw_trg_typevalue_fk_update trigger');

-- Check indexes
SELECT has_index('sys_addfields', 'man_addfields_parameter_cat_feature_id_index', 'Index man_addfields_parameter_cat_feature_id_index should exist');

SELECT * FROM finish();

ROLLBACK;