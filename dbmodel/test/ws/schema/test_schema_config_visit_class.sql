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

-- Check table config_visit_class
SELECT has_table('config_visit_class'::name, 'Table config_visit_class should exist');

-- Check columns
SELECT columns_are(
    'config_visit_class',
    ARRAY[
        'id', 'idval', 'descript', 'active', 'ismultifeature', 'ismultievent', 'feature_type', 'sys_role', 'visit_type',
        'param_options', 'formname', 'tablename', 'ui_tablename', 'parent_id', 'inherit_values'
    ],
    'Table config_visit_class should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_visit_class', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('config_visit_class', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('config_visit_class', 'idval', 'varchar(30)', 'Column idval should be varchar(30)');
SELECT col_type_is('config_visit_class', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('config_visit_class', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('config_visit_class', 'ismultifeature', 'boolean', 'Column ismultifeature should be boolean');
SELECT col_type_is('config_visit_class', 'ismultievent', 'boolean', 'Column ismultievent should be boolean');
SELECT col_type_is('config_visit_class', 'feature_type', 'text', 'Column feature_type should be text');
SELECT col_type_is('config_visit_class', 'sys_role', 'varchar(30)', 'Column sys_role should be varchar(30)');
SELECT col_type_is('config_visit_class', 'visit_type', 'integer', 'Column visit_type should be integer');
SELECT col_type_is('config_visit_class', 'param_options', 'json', 'Column param_options should be json');
SELECT col_type_is('config_visit_class', 'formname', 'text', 'Column formname should be text');
SELECT col_type_is('config_visit_class', 'tablename', 'text', 'Column tablename should be text');
SELECT col_type_is('config_visit_class', 'ui_tablename', 'text', 'Column ui_tablename should be text');
SELECT col_type_is('config_visit_class', 'parent_id', 'integer', 'Column parent_id should be integer');
SELECT col_type_is('config_visit_class', 'inherit_values', 'json', 'Column inherit_values should be json');

-- Check foreign keys
SELECT has_fk('config_visit_class', 'Table config_visit_class should have foreign keys');
SELECT fk_ok('config_visit_class', 'sys_role', 'sys_role', 'id', 'FK config_visit_class_sys_role_fkey should exist');

-- Check triggers
SELECT has_trigger('config_visit_class', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('config_visit_class', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check rules

-- Check sequences
SELECT has_sequence('om_visit_class_id_seq', 'Sequence om_visit_class_id_seq should exist');

-- Check constraints
SELECT col_not_null('config_visit_class', 'id', 'Column id should be NOT NULL');
SELECT col_default_is('config_visit_class', 'active', 'true', 'Column active should default to true');
SELECT col_default_is('config_visit_class', 'id', 'nextval(''om_visit_class_id_seq''::regclass)', 'Column id should default to nextval');

SELECT * FROM finish();

ROLLBACK;
