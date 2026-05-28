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
SELECT has_table('ext_cat_hydrometer_category_x_pattern'::name, 'Table ext_cat_hydrometer_category_x_pattern should exist');

-- Check columns
SELECT columns_are(
    'ext_cat_hydrometer_category_x_pattern',
    ARRAY[
        'category_id', 'period_type', 'pattern_id', 'observ'
    ],
    'Table ext_cat_hydrometer_category_x_pattern should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_cat_hydrometer_category_x_pattern', 'category_id', 'varchar(16)', 'Column category_id should be varchar(16)');
SELECT col_type_is('ext_cat_hydrometer_category_x_pattern', 'period_type', 'int4', 'Column period_type should be int4');
SELECT col_type_is('ext_cat_hydrometer_category_x_pattern', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('ext_cat_hydrometer_category_x_pattern', 'observ', 'text', 'Column observ should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
