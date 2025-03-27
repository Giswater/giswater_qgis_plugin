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

-- Check table om_mincut_cat_type
SELECT has_table('om_mincut_cat_type'::name, 'Table om_mincut_cat_type should exist');

-- Check columns
SELECT columns_are(
    'om_mincut_cat_type',
    ARRAY[
        'id', 'virtual', 'descript'
    ],
    'Table om_mincut_cat_type should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_mincut_cat_type', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_mincut_cat_type', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('om_mincut_cat_type', 'virtual', 'boolean', 'Column virtual should be boolean');
SELECT col_type_is('om_mincut_cat_type', 'descript', 'text', 'Column descript should be text');

-- Check default values
SELECT col_default_is('om_mincut_cat_type', 'virtual', 'true', 'Column virtual should default to true');

-- Check constraints
SELECT col_not_null('om_mincut_cat_type', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_mincut_cat_type', 'virtual', 'Column virtual should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 