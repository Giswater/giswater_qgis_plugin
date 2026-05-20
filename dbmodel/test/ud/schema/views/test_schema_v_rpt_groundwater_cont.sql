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

-- Check view v_rpt_groundwater_cont
SELECT has_view('v_rpt_groundwater_cont'::name, 'View v_rpt_groundwater_cont should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_groundwater_cont',
    ARRAY[
        'id', 'result_id', 'init_stor', 'infilt', 'upzone_et', 'lowzone_et',
        'deep_perc', 'groundw_fl', 'final_stor', 'cont_error'
    ],
    'View v_rpt_groundwater_cont should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_groundwater_cont', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_groundwater_cont', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_groundwater_cont', 'init_stor', 'numeric(12,4)', 'Column init_stor should be numeric(12,4)');
SELECT col_type_is('v_rpt_groundwater_cont', 'infilt', 'numeric(12,4)', 'Column infilt should be numeric(12,4)');
SELECT col_type_is('v_rpt_groundwater_cont', 'upzone_et', 'numeric(12,4)', 'Column upzone_et should be numeric(12,4)');
SELECT col_type_is('v_rpt_groundwater_cont', 'lowzone_et', 'numeric(12,4)', 'Column lowzone_et should be numeric(12,4)');
SELECT col_type_is('v_rpt_groundwater_cont', 'deep_perc', 'numeric(12,4)', 'Column deep_perc should be numeric(12,4)');
SELECT col_type_is('v_rpt_groundwater_cont', 'groundw_fl', 'numeric(12,4)', 'Column groundw_fl should be numeric(12,4)');
SELECT col_type_is('v_rpt_groundwater_cont', 'final_stor', 'numeric(12,4)', 'Column final_stor should be numeric(12,4)');
SELECT col_type_is('v_rpt_groundwater_cont', 'cont_error', 'numeric(12,4)', 'Column cont_error should be numeric(12,4)');

SELECT * FROM finish();

ROLLBACK;
