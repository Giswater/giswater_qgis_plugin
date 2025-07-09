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
SELECT col_is_pk('config_table', 'id', 'Column id should be primary key'); 

-- Check column types
SELECT col_type_is('config_table', 'id', 'text', 'Column id should be text');
SELECT col_type_is('config_table', 'style', 'int4', 'Column style should be int4');
SELECT col_type_is('config_table', 'group_layer', 'text', 'Column group_layer should be text');

-- Check indexes
SELECT has_index('config_table', 'id', 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;