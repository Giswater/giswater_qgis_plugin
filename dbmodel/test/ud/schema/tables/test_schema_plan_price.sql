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
SELECT has_table('plan_price'::name, 'Table plan_price should exist');

-- Check columns
SELECT columns_are(
    'plan_price',
    ARRAY[
        'id', 'unit', 'descript', 'text', 'price', 'pricecat_id'
    ],
    'Table plan_price should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_price', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('plan_price', 'unit', 'varchar(5)', 'Column unit should be varchar(5)');
SELECT col_type_is('plan_price', 'descript', 'varchar(100)', 'Column descript should be varchar(100)');
SELECT col_type_is('plan_price', 'text', 'text', 'Column text should be text');
SELECT col_type_is('plan_price', 'price', 'numeric(12,4)', 'Column price should be numeric(12,4)');
SELECT col_type_is('plan_price', 'pricecat_id', 'varchar(16)', 'Column pricecat_id should be varchar(16)');

-- Check foreign keys
SELECT has_fk('plan_price', 'Table plan_price should have foreign keys');

SELECT fk_ok('plan_price', 'pricecat_id', 'plan_price_cat', 'id', 'FK pricecat_id → plan_price_cat.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
