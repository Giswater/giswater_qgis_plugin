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

-- Check table config_table
SELECT has_table('config_table'::name, 'Table config_table should exist');

-- Check columns
SELECT columns_are(
    'config_table',
    ARRAY[
        'id', 'style', 'group_layer'
    ],
    'Table config_table should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_table', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('config_table', 'id', 'text', 'Column id should be text');
SELECT col_type_is('config_table', 'style', 'integer', 'Column style should be integer');
SELECT col_type_is('config_table', 'group_layer', 'text', 'Column group_layer should be text');

-- Check foreign keys
SELECT hasnt_fk('config_table', 'Table config_table should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_table', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('config_table', 'style', 'Column style should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
