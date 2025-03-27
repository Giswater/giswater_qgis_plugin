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

-- Check table ext_type_street
SELECT has_table('ext_type_street'::name, 'Table ext_type_street should exist');

-- Check columns
SELECT columns_are(
    'ext_type_street',
    ARRAY[
        'id', 'observ'
    ],
    'Table ext_type_street should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_type_street', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_type_street', 'id', 'varchar(20)', 'Column id should be varchar(20)');
SELECT col_type_is('ext_type_street', 'observ', 'varchar(50)', 'Column observ should be varchar(50)');

-- Check foreign keys
SELECT hasnt_fk('ext_type_street', 'Table ext_type_street should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_type_street', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
