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

-- Check table cat_pavement
SELECT has_table('cat_pavement'::name, 'Table cat_pavement should exist');

-- Check columns
SELECT columns_are(
    'cat_pavement',
    ARRAY[
        'id', 'code', 'descript', 'link', 'thickness', 'm2_cost', 'active'
    ],
    'Table cat_pavement should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_pavement', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('cat_pavement', 'id', 'character varying(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_pavement', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_pavement', 'link', 'character varying(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_pavement', 'thickness', 'numeric(12,2)', 'Column thickness should be numeric(12,2)');
SELECT col_type_is('cat_pavement', 'm2_cost', 'character varying(16)', 'Column m2_cost should be varchar(16)');
SELECT col_type_is('cat_pavement', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('cat_pavement', 'code', 'text', 'Column code should be text');

-- Check foreign keys
SELECT has_fk('cat_pavement', 'Table cat_pavement should have foreign keys');
SELECT fk_ok('cat_pavement', 'm2_cost', 'plan_price', 'id', 'Column m2_cost should reference plan_price(id)');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_default_is('cat_pavement', 'thickness', 0.00, 'Column thickness should have default value');
SELECT col_default_is('cat_pavement', 'active', true, 'Column active should have default value');
SELECT col_not_null('cat_pavement', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
