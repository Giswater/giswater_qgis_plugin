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
SELECT has_table('man_type_function'::name, 'Table man_type_function should exist');

-- Check columns
SELECT columns_are(
    'man_type_function',
    ARRAY[
        'function_type', 'feature_type', 'featurecat_id', 'observ', 'active'
    ],
    'Table man_type_function should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_type_function', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('man_type_function', 'feature_type', 'text[]', 'Column feature_type should be text[]');
SELECT col_type_is('man_type_function', 'featurecat_id', 'text[]', 'Column featurecat_id should be text[]');
SELECT col_type_is('man_type_function', 'observ', 'varchar(150)', 'Column observ should be varchar(150)');
SELECT col_type_is('man_type_function', 'active', 'bool', 'Column active should be bool');

-- Finish
SELECT * FROM finish();

ROLLBACK;
