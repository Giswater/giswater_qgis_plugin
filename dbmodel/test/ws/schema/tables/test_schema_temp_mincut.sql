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
SELECT has_table('temp_mincut'::name, 'Table temp_mincut should exist');

-- Check columns
SELECT columns_are(
    'temp_mincut',
    ARRAY[
        'id', 'source', 'target', 'cost', 'reverse_cost'
    ],
    'Table temp_mincut should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_mincut', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('temp_mincut', 'source', 'int8', 'Column source should be int8');
SELECT col_type_is('temp_mincut', 'target', 'int8', 'Column target should be int8');
SELECT col_type_is('temp_mincut', 'cost', 'int2', 'Column cost should be int2');
SELECT col_type_is('temp_mincut', 'reverse_cost', 'int2', 'Column reverse_cost should be int2');

-- Finish
SELECT * FROM finish();

ROLLBACK;
