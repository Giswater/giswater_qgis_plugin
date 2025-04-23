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

-- Check table inp_project_id
SELECT has_table('inp_project_id'::name, 'Table inp_project_id should exist');

-- Check columns
SELECT columns_are(
    'inp_project_id',
    ARRAY[
        'title', 'author', 'date'
    ],
    'Table inp_project_id should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_project_id', ARRAY['title'], 'Column title should be primary key');

-- Check column types
SELECT col_type_is('inp_project_id', 'title', 'varchar(254)', 'Column title should be varchar(254)');
SELECT col_type_is('inp_project_id', 'author', 'varchar(50)', 'Column author should be varchar(50)');
SELECT col_type_is('inp_project_id', 'date', 'varchar(12)', 'Column date should be varchar(12)');

-- Check foreign keys

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_project_id', 'title', 'Column title should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 