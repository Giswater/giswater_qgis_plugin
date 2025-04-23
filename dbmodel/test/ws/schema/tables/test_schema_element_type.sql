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

-- Check table element_type
SELECT has_table('element_type'::name, 'Table element_type should exist');

-- Check columns
SELECT columns_are(
    'element_type',
    ARRAY[
        'id', 'active', 'code_autofill', 'descript', 'link_path'
    ],
    'Table element_type should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('element_type', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('element_type', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('element_type', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('element_type', 'code_autofill', 'boolean', 'Column code_autofill should be boolean');
SELECT col_type_is('element_type', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('element_type', 'link_path', 'varchar(254)', 'Column link_path should be varchar(254)');

-- Check foreign keys
SELECT hasnt_fk('element_type', 'Table element_type should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('element_type', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
