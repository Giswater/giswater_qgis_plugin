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
        'id', 'observ', 'code', 'pattern_id'
    ],
    'Table ext_hydrometer_category should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_hydrometer_category', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ext_hydrometer_category', 'observ', 'varchar(100)', 'Column observ should be varchar(100)');
SELECT col_type_is('ext_hydrometer_category', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ext_hydrometer_category', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');

-- Check foreign keys
SELECT has_fk('ext_hydrometer_category', 'Table ext_hydrometer_category should have foreign keys');

SELECT fk_ok('ext_hydrometer_category', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id → inp_pattern.pattern_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
