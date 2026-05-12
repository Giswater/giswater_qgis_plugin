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

-- Check table cat_workspace
SELECT has_table('cat_workspace'::name, 'Table cat_workspace should exist');

-- Check columns
SELECT columns_are(
    'cat_workspace',
    ARRAY[
        'id', 'name', 'descript', 'config', 'private', 'active', 'iseditable', 'insert_user', 'insert_timestamp', 'lastupdate_user', 'lastupdate_timestamp'
    ],
    'Table cat_workspace should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_workspace', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('cat_workspace', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('cat_workspace', 'name', 'character varying(50)', 'Column name should be varchar(50)');
SELECT col_type_is('cat_workspace', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_workspace', 'config', 'json', 'Column config should be json');
SELECT col_type_is('cat_workspace', 'private', 'boolean', 'Column private should be boolean');
SELECT col_type_is('cat_workspace', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('cat_workspace', 'iseditable', 'boolean', 'Column iseditable should be boolean');
SELECT col_type_is('cat_workspace', 'insert_user', 'text', 'Column insert_user should be text');
SELECT col_type_is('cat_workspace', 'insert_timestamp', 'timestamp without time zone', 'Column insert_timestamp should be timestamp');
SELECT col_type_is('cat_workspace', 'lastupdate_user', 'text', 'Column lastupdate_user should be text');
SELECT col_type_is('cat_workspace', 'lastupdate_timestamp', 'timestamp without time zone', 'Column lastupdate_timestamp should be timestamp');

-- Check foreign keys
SELECT hasnt_fk('cat_workspace', 'Table cat_workspace should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('cat_workspace_id_seq', 'Sequence cat_workspace_id_seq should exist');

-- Check constraints
SELECT col_default_is('cat_workspace', 'active', true, 'Column active should have default value');
SELECT col_default_is('cat_workspace', 'iseditable', true, 'Column iseditable should have default value');
SELECT col_default_is('cat_workspace', 'insert_user', 'CURRENT_USER', 'Column insert_user should have default value');
SELECT col_default_is('cat_workspace', 'insert_timestamp', 'now()', 'Column insert_timestamp should have default value');
SELECT col_default_is('cat_workspace', 'lastupdate_user', 'CURRENT_USER', 'Column lastupdate_user should have default value');
SELECT col_default_is('cat_workspace', 'lastupdate_timestamp', 'now()', 'Column lastupdate_timestamp should have default value');
SELECT col_not_null('cat_workspace', 'id', 'Column id should be NOT NULL');
SELECT col_is_unique('cat_workspace', 'name', 'Column name should be unique');

SELECT * FROM finish();

ROLLBACK;
