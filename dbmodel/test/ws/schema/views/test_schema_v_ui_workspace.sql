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

-- Check view v_ui_workspace
SELECT has_view('v_ui_workspace'::name, 'View v_ui_workspace should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_workspace',
    ARRAY[
        'id', 'name', 'private', 'descript', 'config', 'insert_user',
        'insert_timestamp', 'lastupdate_user', 'lastupdate_timestamp'
    ],
    'View v_ui_workspace should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_workspace', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_ui_workspace', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('v_ui_workspace', 'private', 'bool', 'Column private should be bool');
SELECT col_type_is('v_ui_workspace', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('v_ui_workspace', 'config', 'json', 'Column config should be json');
SELECT col_type_is('v_ui_workspace', 'insert_user', 'text', 'Column insert_user should be text');
SELECT col_type_is('v_ui_workspace', 'insert_timestamp', 'timestamp without time zone', 'Column insert_timestamp should be timestamp without time zone');
SELECT col_type_is('v_ui_workspace', 'lastupdate_user', 'text', 'Column lastupdate_user should be text');
SELECT col_type_is('v_ui_workspace', 'lastupdate_timestamp', 'timestamp without time zone', 'Column lastupdate_timestamp should be timestamp without time zone');

SELECT * FROM finish();

ROLLBACK;
