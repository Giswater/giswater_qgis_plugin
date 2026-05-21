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
SELECT has_table('inp_tags'::name, 'Table inp_tags should exist');

-- Check columns
SELECT columns_are(
    'inp_tags',
    ARRAY[
        'feature_type', 'feature_id', 'tag'
    ],
    'Table inp_tags should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_tags', 'feature_type', 'varchar(18)', 'Column feature_type should be varchar(18)');
SELECT col_type_is('inp_tags', 'feature_id', 'varchar(16)', 'Column feature_id should be varchar(16)');
SELECT col_type_is('inp_tags', 'tag', 'varchar(50)', 'Column tag should be varchar(50)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
