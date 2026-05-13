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
SELECT has_table('rpt_groundwater_cont'::name, 'Table rpt_groundwater_cont should exist');

-- Check columns
SELECT columns_are(
    'rpt_groundwater_cont',
    ARRAY[
        'id', 'result_id', 'init_stor', 'infilt', 'upzone_et', 'lowzone_et',
        'deep_perc', 'groundw_fl', 'final_stor', 'cont_error'
    ],
    'Table rpt_groundwater_cont should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_groundwater_cont', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_groundwater_cont', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_groundwater_cont', 'init_stor', 'numeric(12,4)', 'Column init_stor should be numeric(12,4)');
SELECT col_type_is('rpt_groundwater_cont', 'infilt', 'numeric(12,4)', 'Column infilt should be numeric(12,4)');
SELECT col_type_is('rpt_groundwater_cont', 'upzone_et', 'numeric(12,4)', 'Column upzone_et should be numeric(12,4)');
SELECT col_type_is('rpt_groundwater_cont', 'lowzone_et', 'numeric(12,4)', 'Column lowzone_et should be numeric(12,4)');
SELECT col_type_is('rpt_groundwater_cont', 'deep_perc', 'numeric(12,4)', 'Column deep_perc should be numeric(12,4)');
SELECT col_type_is('rpt_groundwater_cont', 'groundw_fl', 'numeric(12,4)', 'Column groundw_fl should be numeric(12,4)');
SELECT col_type_is('rpt_groundwater_cont', 'final_stor', 'numeric(12,4)', 'Column final_stor should be numeric(12,4)');
SELECT col_type_is('rpt_groundwater_cont', 'cont_error', 'numeric(12,4)', 'Column cont_error should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('rpt_groundwater_cont', 'Table rpt_groundwater_cont should have foreign keys');

SELECT fk_ok('rpt_groundwater_cont', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
