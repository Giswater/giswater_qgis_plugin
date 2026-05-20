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
SELECT has_table('ext_cat_hydrometer_priority'::name, 'Table ext_cat_hydrometer_priority should exist');

-- Check columns
SELECT columns_are(
    'ext_cat_hydrometer_priority',
    ARRAY[
        'id', 'code', 'observ'
    ],
    'Table ext_cat_hydrometer_priority should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_cat_hydrometer_priority', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('ext_cat_hydrometer_priority', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ext_cat_hydrometer_priority', 'observ', 'varchar(100)', 'Column observ should be varchar(100)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
