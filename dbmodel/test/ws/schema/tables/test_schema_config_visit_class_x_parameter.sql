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

-- Check table config_visit_class_x_parameter
SELECT has_table('config_visit_class_x_parameter'::name, 'Table config_visit_class_x_parameter should exist');

-- Check columns
SELECT columns_are(
    'config_visit_class_x_parameter',
    ARRAY[
        'class_id', 'parameter_id', 'active'
    ],
    'Table config_visit_class_x_parameter should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_visit_class_x_parameter', ARRAY['parameter_id', 'class_id'], 'Columns parameter_id, class_id should be primary key');

-- Check column types
SELECT col_type_is('config_visit_class_x_parameter', 'class_id', 'integer', 'Column class_id should be integer');
SELECT col_type_is('config_visit_class_x_parameter', 'parameter_id', 'varchar(50)', 'Column parameter_id should be varchar(50)');
SELECT col_type_is('config_visit_class_x_parameter', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT has_fk('config_visit_class_x_parameter', 'Table config_visit_class_x_parameter should have foreign keys');
SELECT fk_ok('config_visit_class_x_parameter', 'class_id', 'config_visit_class', 'id', 'FK config_visit_class_x_parameter_class_fkey should exist');
SELECT fk_ok('config_visit_class_x_parameter', 'parameter_id', 'config_visit_parameter', 'id', 'FK config_visit_class_x_parameter_parameter_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_visit_class_x_parameter', 'class_id', 'Column class_id should be NOT NULL');
SELECT col_not_null('config_visit_class_x_parameter', 'parameter_id', 'Column parameter_id should be NOT NULL');
SELECT col_default_is('config_visit_class_x_parameter', 'active', 'true', 'Column active should default to true');

SELECT * FROM finish();

ROLLBACK;
