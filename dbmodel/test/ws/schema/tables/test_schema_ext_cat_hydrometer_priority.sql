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

-- Check table ext_cat_hydrometer_priority
SELECT has_table('ext_cat_hydrometer_priority'::name, 'Table ext_cat_hydrometer_priority should exist');

-- Check columns
SELECT columns_are(
    'ext_cat_hydrometer_priority',
    ARRAY[
        'id', 'code', 'observ'
    ],
    'Table ext_cat_hydrometer_priority should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_cat_hydrometer_priority', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_cat_hydrometer_priority', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('ext_cat_hydrometer_priority', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ext_cat_hydrometer_priority', 'observ', 'varchar(100)', 'Column observ should be varchar(100)');

-- Check foreign keys
SELECT hasnt_fk('ext_cat_hydrometer_priority', 'Table ext_cat_hydrometer_priority should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_cat_hydrometer_priority', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('ext_cat_hydrometer_priority', 'code', 'Column code should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
