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
SELECT has_table('inp_family'::name, 'Table inp_family should exist');

-- Check columns
SELECT columns_are(
    'inp_family',
    ARRAY[
        'family_id', 'descript', 'age'
    ],
    'Table inp_family should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_family', 'family_id', 'varchar(100)', 'Column family_id should be varchar(100)');
SELECT col_type_is('inp_family', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('inp_family', 'age', 'int4', 'Column age should be int4');

-- Finish
SELECT * FROM finish();

ROLLBACK;
