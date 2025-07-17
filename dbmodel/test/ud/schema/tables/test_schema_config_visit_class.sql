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
SELECT has_table('config_visit_class'::name, 'Table config_visit_class should exist');

-- Check columns
SELECT columns_are(
    'config_visit_class',
    ARRAY[
        'id', 'idval', 'descript', 'active', 'ismultifeature', 'ismultievent', 'feature_type', 'sys_role', 'visit_type', 'param_options',
        'formname', 'tablename', 'ui_tablename', 'parent_id', 'inherit_values'
    ],
    'Table config_visit_class should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_visit_class', 'id', 'Column id should be primary key'); 

-- Check column types
SELECT col_type_is('config_visit_class', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('config_visit_class', 'idval', 'varchar(30)', 'Column idval should be varchar(30)');
SELECT col_type_is('config_visit_class', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('config_visit_class', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('config_visit_class', 'ismultifeature', 'bool', 'Column ismultifeature should be bool');
SELECT col_type_is('config_visit_class', 'ismultievent', 'bool', 'Column ismultievent should be bool');
SELECT col_type_is('config_visit_class', 'feature_type', 'text', 'Column feature_type should be text');
SELECT col_type_is('config_visit_class', 'sys_role', 'varchar(30)', 'Column sys_role should be varchar(30)');
SELECT col_type_is('config_visit_class', 'visit_type', 'int4', 'Column visit_type should be int4');
SELECT col_type_is('config_visit_class', 'param_options', 'json', 'Column param_options should be json');
SELECT col_type_is('config_visit_class', 'formname', 'text', 'Column formname should be text');
SELECT col_type_is('config_visit_class', 'tablename', 'text', 'Column tablename should be text');
SELECT col_type_is('config_visit_class', 'ui_tablename', 'text', 'Column ui_tablename should be text');
SELECT col_type_is('config_visit_class', 'parent_id', 'int4', 'Column parent_id should be int4');
SELECT col_type_is('config_visit_class', 'inherit_values', 'json', 'Column inherit_values should be json');

-- Check default values
SELECT col_has_default('config_visit_class', 'id', 'Column id should have default value');
SELECT col_has_default('config_visit_class', 'active', 'Column active should have default value');

-- Check foreign keys
SELECT has_fk('config_visit_class', 'Table config_visit_class should have foreign keys');

SELECT fk_ok('config_visit_class', 'sys_role', 'sys_role', 'id', 'Table should have foreign key from sys_role to sys_role.id');

-- Check indexes
SELECT has_index('config_visit_class', 'config_visit_class_pkey', ARRAY['id'], 'Table should have index on id');

-- Check triggers
SELECT has_trigger('config_visit_class', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('config_visit_class', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');

-- Finish
SELECT * FROM finish();

ROLLBACK;