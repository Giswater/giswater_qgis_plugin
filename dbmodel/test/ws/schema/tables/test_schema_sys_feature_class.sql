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

-- Check table sys_feature_class
SELECT has_table('sys_feature_class'::name, 'Table sys_feature_class should exist');

-- Check columns
SELECT columns_are(
    'sys_feature_class',
    ARRAY[
        'id', 'type', 'epa_default', 'man_table'
    ],
    'Table sys_feature_class should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_feature_class', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('sys_feature_class', 'id', 'character varying(30)', 'Column id should be character varying(30)');
SELECT col_type_is('sys_feature_class', 'type', 'character varying(30)', 'Column type should be character varying(30)');
SELECT col_type_is('sys_feature_class', 'epa_default', 'character varying(16)', 'Column epa_default should be character varying(16)');
SELECT col_type_is('sys_feature_class', 'man_table', 'character varying(30)', 'Column man_table should be character varying(30)');

-- Check constraints
SELECT col_not_null('sys_feature_class', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('sys_feature_class', 'man_table', 'Column man_table should be NOT NULL');
SELECT col_has_check('sys_feature_class', 'id', 'Table sys_feature_class should have check constraint on id');
SELECT col_is_unique('sys_feature_class', ARRAY['id', 'type'], 'Columns id, type should be unique');

-- Check foreign keys
SELECT has_fk('sys_feature_class', 'Table sys_feature_class should have foreign keys');
SELECT fk_ok('sys_feature_class', 'type', 'sys_feature_type', 'id', 'FK type should reference sys_feature_type.id');

SELECT * FROM finish();

ROLLBACK;