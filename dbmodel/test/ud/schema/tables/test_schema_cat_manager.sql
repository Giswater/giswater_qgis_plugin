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

-- Check column types
SELECT col_type_is('cat_manager', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('cat_manager', 'idval', 'text', 'Column idval should be text');
SELECT col_type_is('cat_manager', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('cat_manager', 'rolename', 'text[]', 'Column rolename should be text[]');
SELECT col_type_is('cat_manager', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_manager', 'selector_macro_tabs', 'bool', 'Column selector_macro_tabs should be bool');

-- Check default values
SELECT col_has_default('cat_manager', 'active', 'Column active should have default value');

-- Check indexes
SELECT has_index('cat_manager', 'cat_manager_pkey', ARRAY['id'], 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;