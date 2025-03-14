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

-- Check table config_visit_parameter_action
SELECT has_table('config_visit_parameter_action'::name, 'Table config_visit_parameter_action should exist');

-- Check columns
SELECT columns_are(
    'config_visit_parameter_action',
    ARRAY[
        'parameter_id1', 'parameter_id2', 'action_type', 'action_value', 'active'
    ],
    'Table config_visit_parameter_action should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_visit_parameter_action', ARRAY['parameter_id1', 'parameter_id2', 'action_type'], 'Columns parameter_id1, parameter_id2, action_type should be primary key');

-- Check column types
SELECT col_type_is('config_visit_parameter_action', 'parameter_id1', 'varchar(50)', 'Column parameter_id1 should be varchar(50)');
SELECT col_type_is('config_visit_parameter_action', 'parameter_id2', 'varchar(50)', 'Column parameter_id2 should be varchar(50)');
SELECT col_type_is('config_visit_parameter_action', 'action_type', 'integer', 'Column action_type should be integer');
SELECT col_type_is('config_visit_parameter_action', 'action_value', 'text', 'Column action_value should be text');
SELECT col_type_is('config_visit_parameter_action', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT has_fk('config_visit_parameter_action', 'Table config_visit_parameter_action should have foreign keys');
SELECT fk_ok('config_visit_parameter_action', 'parameter_id1', 'config_visit_parameter', 'id', 'FK config_visit_parameter_action_parameter_id1_fkey should exist');
SELECT fk_ok('config_visit_parameter_action', 'parameter_id2', 'config_visit_parameter', 'id', 'FK config_visit_parameter_action_parameter_id2_fkey should exist');

-- Check triggers
SELECT has_trigger('config_visit_parameter_action', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('config_visit_parameter_action', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_visit_parameter_action', 'parameter_id1', 'Column parameter_id1 should be NOT NULL');
SELECT col_not_null('config_visit_parameter_action', 'parameter_id2', 'Column parameter_id2 should be NOT NULL');
SELECT col_not_null('config_visit_parameter_action', 'action_type', 'Column action_type should be NOT NULL');
SELECT col_default_is('config_visit_parameter_action', 'active', 'true', 'Column active should default to true');

SELECT * FROM finish();

ROLLBACK;
