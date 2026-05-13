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
SELECT has_table('config_visit_parameter_action'::name, 'Table config_visit_parameter_action should exist');

-- Check columns
SELECT columns_are(
    'config_visit_parameter_action',
    ARRAY[
        'parameter_id1', 'parameter_id2', 'action_type', 'action_value', 'active'
    ],
    'Table config_visit_parameter_action should have the correct columns'
);

-- Check column types
SELECT col_type_is('config_visit_parameter_action', 'parameter_id1', 'varchar(50)', 'Column parameter_id1 should be varchar(50)');
SELECT col_type_is('config_visit_parameter_action', 'parameter_id2', 'varchar(50)', 'Column parameter_id2 should be varchar(50)');
SELECT col_type_is('config_visit_parameter_action', 'action_type', 'int4', 'Column action_type should be int4');
SELECT col_type_is('config_visit_parameter_action', 'action_value', 'text', 'Column action_value should be text');
SELECT col_type_is('config_visit_parameter_action', 'active', 'bool', 'Column active should be bool');

-- Check foreign keys
SELECT has_fk('config_visit_parameter_action', 'Table config_visit_parameter_action should have foreign keys');

SELECT fk_ok('config_visit_parameter_action', 'parameter_id1', 'config_visit_parameter', 'id', 'FK parameter_id1 → config_visit_parameter.id');
SELECT fk_ok('config_visit_parameter_action', 'parameter_id2', 'config_visit_parameter', 'id', 'FK parameter_id2 → config_visit_parameter.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
