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

-- Check table ext_cat_period
SELECT has_table('ext_cat_period'::name, 'Table ext_cat_period should exist');

-- Check columns
SELECT columns_are(
    'ext_cat_period',
    ARRAY[
        'id', 'start_date', 'end_date', 'period_seconds', 'comment', 'code', 'period_type', 'period_year', 'period_name', 'expl_id'
    ],
    'Table ext_cat_period should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_cat_period', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_cat_period', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ext_cat_period', 'start_date', 'timestamp(6)', 'Column start_date should be timestamp(6)');
SELECT col_type_is('ext_cat_period', 'end_date', 'timestamp(6)', 'Column end_date should be timestamp(6)');
SELECT col_type_is('ext_cat_period', 'period_seconds', 'integer', 'Column period_seconds should be integer');
SELECT col_type_is('ext_cat_period', 'comment', 'varchar(100)', 'Column comment should be varchar(100)');
SELECT col_type_is('ext_cat_period', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ext_cat_period', 'period_type', 'integer', 'Column period_type should be integer');
SELECT col_type_is('ext_cat_period', 'period_year', 'integer', 'Column period_year should be integer');
SELECT col_type_is('ext_cat_period', 'period_name', 'varchar(16)', 'Column period_name should be varchar(16)');
SELECT col_type_is('ext_cat_period', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');

-- Check foreign keys
SELECT has_fk('ext_cat_period', 'Table ext_cat_period should have foreign keys');
SELECT fk_ok('ext_cat_period', 'period_type', 'ext_cat_period_type', 'id', 'FK ext_cat_period_period_type_fkey should exist');

-- Check triggers
SELECT has_trigger('ext_cat_period', 'gw_trg_calculate_period', 'Table should have gw_trg_calculate_period trigger');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_cat_period', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
