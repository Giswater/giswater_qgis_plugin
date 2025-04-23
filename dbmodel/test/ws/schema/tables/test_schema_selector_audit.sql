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

-- Check table selector_audit
SELECT has_table('selector_audit'::name, 'Table selector_audit should exist');

-- Check columns
SELECT columns_are(
    'selector_audit',
    ARRAY[
        'fid', 'cur_user'
    ],
    'Table selector_audit should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('selector_audit', ARRAY['fid', 'cur_user'], 'Columns fid, cur_user should be primary key');

-- Check column types
SELECT col_type_is('selector_audit', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('selector_audit', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_default_is('selector_audit', 'cur_user', 'CURRENT_USER', 'Column cur_user should default to CURRENT_USER');

-- Check constraints
SELECT col_not_null('selector_audit', 'fid', 'Column fid should be NOT NULL');
SELECT col_not_null('selector_audit', 'cur_user', 'Column cur_user should be NOT NULL');

-- Check foreign keys
SELECT has_fk('selector_audit', 'Table selector_audit should have foreign keys');
SELECT fk_ok('selector_audit', 'fid', 'sys_fprocess', 'fid', 'FK fid should reference sys_fprocess.fid');

SELECT * FROM finish();

ROLLBACK; 