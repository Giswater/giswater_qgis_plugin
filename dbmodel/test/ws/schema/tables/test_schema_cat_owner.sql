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

-- Check table cat_owner
SELECT has_table('cat_owner'::name, 'Table cat_owner should exist');

-- Check columns
SELECT columns_are(
    'cat_owner',
    ARRAY[
        'id', 'descript', 'link', 'active'
    ],
    'Table cat_owner should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_owner', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('cat_owner', 'id', 'character varying(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_owner', 'descript', 'character varying(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_owner', 'link', 'character varying(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_owner', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT hasnt_fk('cat_owner', 'Table cat_owner should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_default_is('cat_owner', 'active', true, 'Column active should have default value');
SELECT col_not_null('cat_owner', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
