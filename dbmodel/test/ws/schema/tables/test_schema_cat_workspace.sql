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
SELECT has_table('cat_workspace'::name, 'Table cat_workspace should exist');

-- Check columns
SELECT columns_are(
    'cat_workspace',
    ARRAY[
        'id', 'name', 'descript', 'config', 'private', 'active',
        'iseditable', 'insert_user', 'insert_timestamp', 'lastupdate_user', 'lastupdate_timestamp'
    ],
    'Table cat_workspace should have the correct columns'
);

-- Check column types
SELECT col_type_is('cat_workspace', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('cat_workspace', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('cat_workspace', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_workspace', 'config', 'json', 'Column config should be json');
SELECT col_type_is('cat_workspace', 'private', 'bool', 'Column private should be bool');
SELECT col_type_is('cat_workspace', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_workspace', 'iseditable', 'bool', 'Column iseditable should be bool');
SELECT col_type_is('cat_workspace', 'insert_user', 'text', 'Column insert_user should be text');
SELECT col_type_is('cat_workspace', 'insert_timestamp', 'timestamp without time zone', 'Column insert_timestamp should be timestamp without time zone');
SELECT col_type_is('cat_workspace', 'lastupdate_user', 'text', 'Column lastupdate_user should be text');
SELECT col_type_is('cat_workspace', 'lastupdate_timestamp', 'timestamp without time zone', 'Column lastupdate_timestamp should be timestamp without time zone');

-- Finish
SELECT * FROM finish();

ROLLBACK;
