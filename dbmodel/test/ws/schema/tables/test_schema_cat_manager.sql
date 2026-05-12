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

-- Check table cat_manager
SELECT has_table('cat_manager'::name, 'Table cat_manager should exist');

-- Check columns
SELECT columns_are(
    'cat_manager',
    ARRAY[
        'id', 'idval', 'expl_id', 'rolename', 'active', 'selector_macro_tabs'
    ],
    'Table cat_manager should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_manager', 'id', 'Column id should be primary key');

-- Check indexes

-- Check column types
SELECT col_type_is('cat_manager', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('cat_manager', 'idval', 'text', 'Column idval should be text');
SELECT col_type_is('cat_manager', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('cat_manager', 'rolename', 'text[]', 'Column rolename should be text[]');
SELECT col_type_is('cat_manager', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('cat_manager', 'selector_macro_tabs', 'boolean', 'Column selector_macro_tabs should be boolean');

-- Check foreign keys
SELECT hasnt_fk('cat_manager', 'Table cat_manager should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('cat_manager_id_seq', 'Sequence cat_manager_id_seq should exist');

-- Check constraints
SELECT col_default_is('cat_manager', 'active', true, 'Column active should have default value true');

SELECT * FROM finish();

ROLLBACK;
