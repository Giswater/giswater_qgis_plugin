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
SELECT has_table('ext_hydrometer_category'::name, 'Table ext_hydrometer_category should exist');

-- Check columns
SELECT columns_are(
    'ext_hydrometer_category',
    ARRAY[
        'id', 'observ', 'code'
    ],
    'Table ext_hydrometer_category should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_hydrometer_category', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ext_hydrometer_category', 'observ', 'varchar(100)', 'Column observ should be varchar(100)');
SELECT col_type_is('ext_hydrometer_category', 'code', 'text', 'Column code should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
