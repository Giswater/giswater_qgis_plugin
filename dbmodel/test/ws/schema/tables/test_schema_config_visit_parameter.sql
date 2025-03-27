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

-- Check table config_visit_parameter
SELECT has_table('config_visit_parameter'::name, 'Table config_visit_parameter should exist');

-- Check columns
SELECT columns_are(
    'config_visit_parameter',
    ARRAY[
        'id', 'code', 'parameter_type', 'feature_type', 'data_type', 'criticity', 'descript',
        'form_type', 'vdefault', 'ismultifeature', 'short_descript', 'active'
    ],
    'Table config_visit_parameter should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_visit_parameter', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('config_visit_parameter', 'id', 'varchar(50)', 'Column id should be varchar(50)');
SELECT col_type_is('config_visit_parameter', 'code', 'text', 'Column code should be text');
SELECT col_type_is('config_visit_parameter', 'parameter_type', 'varchar(30)', 'Column parameter_type should be varchar(30)');
SELECT col_type_is('config_visit_parameter', 'feature_type', 'varchar(30)', 'Column feature_type should be varchar(30)');
SELECT col_type_is('config_visit_parameter', 'data_type', 'varchar(16)', 'Column data_type should be varchar(16)');
SELECT col_type_is('config_visit_parameter', 'criticity', 'smallint', 'Column criticity should be smallint');
SELECT col_type_is('config_visit_parameter', 'descript', 'varchar(100)', 'Column descript should be varchar(100)');
SELECT col_type_is('config_visit_parameter', 'form_type', 'varchar(30)', 'Column form_type should be varchar(30)');
SELECT col_type_is('config_visit_parameter', 'vdefault', 'text', 'Column vdefault should be text');
SELECT col_type_is('config_visit_parameter', 'ismultifeature', 'boolean', 'Column ismultifeature should be boolean');
SELECT col_type_is('config_visit_parameter', 'short_descript', 'varchar(30)', 'Column short_descript should be varchar(30)');
SELECT col_type_is('config_visit_parameter', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT hasnt_fk('config_visit_parameter', 'Table config_visit_parameter should have no foreign keys');

-- Check triggers
SELECT has_trigger('config_visit_parameter', 'gw_trg_typevalue_fk_insert', 'Table should have insert trigger');
SELECT has_trigger('config_visit_parameter', 'gw_trg_typevalue_fk_update', 'Table should have update trigger');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_visit_parameter', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('config_visit_parameter', 'parameter_type', 'Column parameter_type should be NOT NULL');
SELECT col_not_null('config_visit_parameter', 'form_type', 'Column form_type should be NOT NULL');
SELECT col_not_null('config_visit_parameter', 'active', 'Column active should be NOT NULL');
SELECT col_default_is('config_visit_parameter', 'active', 'true', 'Column active should default to true');

-- Check feature_type constraint
SELECT col_has_check('config_visit_parameter', 'feature_type', 'Column feature_type should have check constraint');

SELECT * FROM finish();

ROLLBACK;
