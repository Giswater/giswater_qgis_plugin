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

-- Check table plan_price
SELECT has_table('plan_price'::name, 'Table plan_price should exist');

-- Check columns
SELECT columns_are(
    'plan_price',
    ARRAY[
        'id', 'unit', 'descript', 'text', 'price', 'pricecat_id'
    ],
    'Table plan_price should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_price', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('plan_price', 'id', 'character varying(16)', 'Column id should be character varying(16)');
SELECT col_type_is('plan_price', 'unit', 'character varying(5)', 'Column unit should be character varying(5)');
SELECT col_type_is('plan_price', 'descript', 'character varying(100)', 'Column descript should be character varying(100)');
SELECT col_type_is('plan_price', 'text', 'text', 'Column text should be text');
SELECT col_type_is('plan_price', 'price', 'numeric(12,4)', 'Column price should be numeric(12,4)');
SELECT col_type_is('plan_price', 'pricecat_id', 'character varying(16)', 'Column pricecat_id should be character varying(16)');

-- Check foreign keys
SELECT has_fk('plan_price', 'Table plan_price should have foreign keys');
SELECT fk_ok('plan_price', 'pricecat_id', 'plan_price_cat', 'id', 'FK pricecat_id should reference plan_price_cat.id');

-- Check constraints
SELECT col_not_null('plan_price', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('plan_price', 'unit', 'Column unit should be NOT NULL');
SELECT col_not_null('plan_price', 'descript', 'Column descript should be NOT NULL');

-- Check triggers
SELECT has_trigger('plan_price', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('plan_price', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');

SELECT * FROM finish();

ROLLBACK; 