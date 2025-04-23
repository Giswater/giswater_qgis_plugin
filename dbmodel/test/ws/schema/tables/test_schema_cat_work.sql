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

-- Check table cat_work
SELECT has_table('cat_work'::name, 'Table cat_work should exist');

-- Check columns
SELECT columns_are(
    'cat_work',
    ARRAY[
        'id', 'descript', 'link', 'workid_key1', 'workid_key2', 'builtdate', 'workcost', 'active'
    ],
    'Table cat_work should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_work', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('cat_work', 'id', 'character varying(255)', 'Column id should be varchar(255)');
SELECT col_type_is('cat_work', 'descript', 'character varying(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_work', 'link', 'character varying(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_work', 'workid_key1', 'character varying(30)', 'Column workid_key1 should be varchar(30)');
SELECT col_type_is('cat_work', 'workid_key2', 'character varying(30)', 'Column workid_key2 should be varchar(30)');
SELECT col_type_is('cat_work', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('cat_work', 'workcost', 'double precision', 'Column workcost should be double precision');
SELECT col_type_is('cat_work', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT hasnt_fk('cat_work', 'Table cat_work should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_default_is('cat_work', 'active', true, 'Column active should have default value');
SELECT col_not_null('cat_work', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
