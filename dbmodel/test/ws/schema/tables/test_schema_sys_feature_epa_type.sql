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

-- Check table sys_feature_epa_type
SELECT has_table('sys_feature_epa_type'::name, 'Table sys_feature_epa_type should exist');

-- Check columns
SELECT columns_are(
    'sys_feature_epa_type',
    ARRAY[
        'id', 'feature_type', 'epa_table', 'descript', 'active'
    ],
    'Table sys_feature_epa_type should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_feature_epa_type', ARRAY['id', 'feature_type'], 'Columns id, feature_type should be primary key');

-- Check column types
SELECT col_type_is('sys_feature_epa_type', 'id', 'character varying(30)', 'Column id should be character varying(30)');
SELECT col_type_is('sys_feature_epa_type', 'feature_type', 'character varying(30)', 'Column feature_type should be character varying(30)');
SELECT col_type_is('sys_feature_epa_type', 'epa_table', 'character varying(50)', 'Column epa_table should be character varying(50)');
SELECT col_type_is('sys_feature_epa_type', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('sys_feature_epa_type', 'active', 'boolean', 'Column active should be boolean');

-- Check constraints
SELECT col_not_null('sys_feature_epa_type', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('sys_feature_epa_type', 'feature_type', 'Column feature_type should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;