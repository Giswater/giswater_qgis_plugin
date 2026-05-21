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
SELECT has_table('config_visit_class_x_parameter'::name, 'Table config_visit_class_x_parameter should exist');

-- Check columns
SELECT columns_are(
    'config_visit_class_x_parameter',
    ARRAY[
        'class_id', 'parameter_id', 'active'
    ],
    'Table config_visit_class_x_parameter should have the correct columns'
);

-- Check column types
SELECT col_type_is('config_visit_class_x_parameter', 'class_id', 'int4', 'Column class_id should be int4');
SELECT col_type_is('config_visit_class_x_parameter', 'parameter_id', 'varchar(50)', 'Column parameter_id should be varchar(50)');
SELECT col_type_is('config_visit_class_x_parameter', 'active', 'bool', 'Column active should be bool');

-- Check foreign keys
SELECT has_fk('config_visit_class_x_parameter', 'Table config_visit_class_x_parameter should have foreign keys');

SELECT fk_ok('config_visit_class_x_parameter', 'class_id', 'config_visit_class', 'id', 'FK class_id → config_visit_class.id');
SELECT fk_ok('config_visit_class_x_parameter', 'parameter_id', 'config_visit_parameter', 'id', 'FK parameter_id → config_visit_parameter.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
