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
SELECT has_table('sys_feature_class'::name, 'Table sys_feature_class should exist');

-- Check columns
SELECT columns_are(
    'sys_feature_class',
    ARRAY[
        'id', 'type', 'epa_default', 'man_table'
    ],
    'Table sys_feature_class should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_feature_class', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('sys_feature_class', 'type', 'varchar(30)', 'Column type should be varchar(30)');
SELECT col_type_is('sys_feature_class', 'epa_default', 'varchar(16)', 'Column epa_default should be varchar(16)');
SELECT col_type_is('sys_feature_class', 'man_table', 'varchar(30)', 'Column man_table should be varchar(30)');

-- Check foreign keys
SELECT has_fk('sys_feature_class', 'Table sys_feature_class should have foreign keys');

SELECT fk_ok('sys_feature_class', 'type', 'sys_feature_type', 'id', 'FK type → sys_feature_type.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
