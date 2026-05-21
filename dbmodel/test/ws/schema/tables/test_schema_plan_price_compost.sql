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
SELECT has_table('plan_price_compost'::name, 'Table plan_price_compost should exist');

-- Check columns
SELECT columns_are(
    'plan_price_compost',
    ARRAY[
        'id', 'compost_id', 'simple_id', 'value'
    ],
    'Table plan_price_compost should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_price_compost', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('plan_price_compost', 'compost_id', 'varchar(16)', 'Column compost_id should be varchar(16)');
SELECT col_type_is('plan_price_compost', 'simple_id', 'varchar(16)', 'Column simple_id should be varchar(16)');
SELECT col_type_is('plan_price_compost', 'value', 'numeric(16,4)', 'Column value should be numeric(16,4)');

-- Check foreign keys
SELECT has_fk('plan_price_compost', 'Table plan_price_compost should have foreign keys');

SELECT fk_ok('plan_price_compost', 'compost_id', 'plan_price', 'id', 'FK compost_id → plan_price.id');
SELECT fk_ok('plan_price_compost', 'simple_id', 'plan_price', 'id', 'FK simple_id → plan_price.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
