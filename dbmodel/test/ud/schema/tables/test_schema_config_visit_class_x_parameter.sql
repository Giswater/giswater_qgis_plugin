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

-- Check primary key
SELECT col_is_pk('config_visit_class_x_parameter', ARRAY['parameter_id','class_id'], 'Columns parameter_id and class_id should be primary key'); 

-- Check column types
SELECT col_type_is('config_visit_class_x_parameter', 'class_id', 'int4', 'Column class_id should be int4');
SELECT col_type_is('config_visit_class_x_parameter', 'parameter_id', 'varchar(50)', 'Column parameter_id should be varchar(50)');
SELECT col_type_is('config_visit_class_x_parameter', 'active', 'bool', 'Column active should be bool');

-- Check default values
SELECT col_has_default('config_visit_class_x_parameter', 'active', 'Column active should have default value');

-- Check foreign keys
SELECT has_fk('config_visit_class_x_parameter', 'Table config_visit_class_x_parameter should have foreign keys');

SELECT fk_ok('config_visit_class_x_parameter', 'class_id', 'config_visit_class', 'id', 'Table should have foreign key from class_id to config_visit_class.id');
SELECT fk_ok('config_visit_class_x_parameter', 'parameter_id', 'config_visit_parameter', 'id', 'Table should have foreign key from parameter_id to config_visit_parameter.id');

-- Check indexes
SELECT has_index('config_visit_class_x_parameter', 'config_visit_class_x_parameter_pkey', ARRAY['parameter_id','class_id'], 'Table should have index on parameter_id, class_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;