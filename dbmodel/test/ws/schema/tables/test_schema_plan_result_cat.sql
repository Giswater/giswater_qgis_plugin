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

-- Check table plan_result_cat
SELECT has_table('plan_result_cat'::name, 'Table plan_result_cat should exist');

-- Check columns
SELECT columns_are(
    'plan_result_cat',
    ARRAY[
        'result_id', 'name', 'result_type', 'coefficient', 'tstamp', 'cur_user', 'descript', 'pricecat_id'
    ],
    'Table plan_result_cat should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_result_cat', ARRAY['result_id'], 'Column result_id should be primary key');

-- Check column types
SELECT col_type_is('plan_result_cat', 'result_id', 'integer', 'Column result_id should be integer');
SELECT col_type_is('plan_result_cat', 'name', 'character varying(30)', 'Column name should be character varying(30)');
SELECT col_type_is('plan_result_cat', 'result_type', 'integer', 'Column result_type should be integer');
SELECT col_type_is('plan_result_cat', 'coefficient', 'double precision', 'Column coefficient should be double precision');
SELECT col_type_is('plan_result_cat', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('plan_result_cat', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('plan_result_cat', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('plan_result_cat', 'pricecat_id', 'character varying(30)', 'Column pricecat_id should be character varying(30)');

-- Check default values
SELECT col_has_default('plan_result_cat', 'result_id', 'Column result_id should have a default value');
SELECT col_has_default('plan_result_cat', 'tstamp', 'Column tstamp should have a default value');

-- Check unique constraints
SELECT col_is_unique('plan_result_cat', ARRAY['name'], 'Column name should be unique');

-- Check triggers
SELECT has_trigger('plan_result_cat', 'gw_trg_typevalue_fk', 'Table should have trigger gw_trg_typevalue_fk');

SELECT * FROM finish();

ROLLBACK;