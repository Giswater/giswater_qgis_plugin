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
SELECT has_table('rpt_arcpollutant_sum'::name, 'Table rpt_arcpollutant_sum should exist');

-- Check columns
SELECT columns_are(
    'rpt_arcpollutant_sum',
    ARRAY[
        'id', 'result_id', 'poll_id', 'arc_id', 'value'
    ],
    'Table rpt_arcpollutant_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_arcpollutant_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_arcpollutant_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_arcpollutant_sum', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('rpt_arcpollutant_sum', 'arc_id', 'varchar(50)', 'Column arc_id should be varchar(50)');
SELECT col_type_is('rpt_arcpollutant_sum', 'value', 'numeric(12,4)', 'Column value should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('rpt_arcpollutant_sum', 'Table rpt_arcpollutant_sum should have foreign keys');

SELECT fk_ok('rpt_arcpollutant_sum', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
