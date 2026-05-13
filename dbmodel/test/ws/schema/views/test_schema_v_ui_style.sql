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

-- Check view v_ui_style
SELECT has_view('v_ui_style'::name, 'View v_ui_style should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_style',
    ARRAY[
        'layername', 'category', 'styletype', 'active'
    ],
    'View v_ui_style should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_style', 'layername', 'text', 'Column layername should be text');
SELECT col_type_is('v_ui_style', 'category', 'text', 'Column category should be text');
SELECT col_type_is('v_ui_style', 'styletype', 'varchar(30)', 'Column styletype should be varchar(30)');
SELECT col_type_is('v_ui_style', 'active', 'bool', 'Column active should be bool');

SELECT * FROM finish();

ROLLBACK;
