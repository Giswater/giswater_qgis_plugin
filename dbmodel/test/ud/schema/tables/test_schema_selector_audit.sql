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
SELECT has_table('selector_audit'::name, 'Table selector_audit should exist');

-- Check columns
SELECT columns_are(
    'selector_audit',
    ARRAY[
        'fid', 'cur_user'
    ],
    'Table selector_audit should have the correct columns'
);

-- Check column types
SELECT col_type_is('selector_audit', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('selector_audit', 'cur_user', 'text', 'Column cur_user should be text');

-- Check foreign keys
SELECT has_fk('selector_audit', 'Table selector_audit should have foreign keys');

SELECT fk_ok('selector_audit', 'fid', 'sys_fprocess', 'fid', 'FK fid → sys_fprocess.fid');

-- Finish
SELECT * FROM finish();

ROLLBACK;
