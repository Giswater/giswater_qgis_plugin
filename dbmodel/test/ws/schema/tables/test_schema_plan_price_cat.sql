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

-- Check table plan_price_cat
SELECT has_table('plan_price_cat'::name, 'Table plan_price_cat should exist');

-- Check columns
SELECT columns_are(
    'plan_price_cat',
    ARRAY[
        'id', 'descript', 'tstamp', 'cur_user'
    ],
    'Table plan_price_cat should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_price_cat', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('plan_price_cat', 'id', 'character varying(30)', 'Column id should be character varying(30)');
SELECT col_type_is('plan_price_cat', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('plan_price_cat', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('plan_price_cat', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_has_default('plan_price_cat', 'tstamp', 'Column tstamp should have a default value');
SELECT col_default_is('plan_price_cat', 'cur_user', '"current_user"()', 'Default value for cur_user should be "current_user"()');

-- Check constraints
SELECT col_not_null('plan_price_cat', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;