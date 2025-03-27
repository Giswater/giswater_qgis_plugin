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

-- Check table inp_energy
SELECT has_table('inp_energy'::name, 'Table inp_energy should exist');

-- Check columns
SELECT columns_are(
    'inp_energy',
    ARRAY[
        'id', 'descript'
    ],
    'Table inp_energy should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_energy', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('inp_energy', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('inp_energy', 'descript', 'text', 'Column descript should be text');

-- Check foreign keys

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_energy', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;