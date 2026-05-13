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
SELECT has_table('inp_lid'::name, 'Table inp_lid should exist');

-- Check columns
SELECT columns_are(
    'inp_lid',
    ARRAY[
        'lidco_id', 'lidco_type', 'observ', 'log', 'active'
    ],
    'Table inp_lid should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_lid', 'lidco_id', 'varchar(16)', 'Column lidco_id should be varchar(16)');
SELECT col_type_is('inp_lid', 'lidco_type', 'varchar(10)', 'Column lidco_type should be varchar(10)');
SELECT col_type_is('inp_lid', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('inp_lid', 'log', 'text', 'Column log should be text');
SELECT col_type_is('inp_lid', 'active', 'bool', 'Column active should be bool');

-- Finish
SELECT * FROM finish();

ROLLBACK;
