/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table plan_price_compost
SELECT has_table('plan_price_compost'::name, 'Table plan_price_compost should exist');

-- Check columns
SELECT columns_are(
    'plan_price_compost',
    ARRAY[
        'id', 'compost_id', 'simple_id', 'value'
    ],
    'Table plan_price_compost should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_price_compost', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('plan_price_compost', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('plan_price_compost', 'compost_id', 'character varying(16)', 'Column compost_id should be character varying(16)');
SELECT col_type_is('plan_price_compost', 'simple_id', 'character varying(16)', 'Column simple_id should be character varying(16)');
SELECT col_type_is('plan_price_compost', 'value', 'numeric(16,4)', 'Column value should be numeric(16,4)');

-- Check foreign keys
SELECT has_fk('plan_price_compost', 'Table plan_price_compost should have foreign keys');
SELECT fk_ok('plan_price_compost', 'compost_id', 'plan_price', 'id', 'FK compost_id should reference plan_price.id');
SELECT fk_ok('plan_price_compost', 'simple_id', 'plan_price', 'id', 'FK simple_id should reference plan_price.id');

-- Check constraints
SELECT col_not_null('plan_price_compost', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('plan_price_compost', 'compost_id', 'Column compost_id should be NOT NULL');
SELECT col_not_null('plan_price_compost', 'simple_id', 'Column simple_id should be NOT NULL');

-- Check default values
SELECT col_has_default('plan_price_compost', 'id', 'Column id should have a default value');

-- Check indexes
SELECT has_index('plan_price_compost', 'plan_price_compost_compost_id', 'Table should have index on compost_id');

SELECT * FROM finish();

ROLLBACK; 