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

-- Check view v_rpt_energy_usage
SELECT has_view('v_rpt_energy_usage'::name, 'View v_rpt_energy_usage should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_energy_usage',
    ARRAY[
        'id', 'result_id', 'nodarc_id', 'usage_fact', 'avg_effic', 'kwhr_mgal',
        'avg_kw', 'peak_kw', 'cost_day'
    ],
    'View v_rpt_energy_usage should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_energy_usage', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_energy_usage', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_energy_usage', 'nodarc_id', 'varchar(16)', 'Column nodarc_id should be varchar(16)');
SELECT col_type_is('v_rpt_energy_usage', 'usage_fact', 'numeric', 'Column usage_fact should be numeric');
SELECT col_type_is('v_rpt_energy_usage', 'avg_effic', 'numeric', 'Column avg_effic should be numeric');
SELECT col_type_is('v_rpt_energy_usage', 'kwhr_mgal', 'numeric', 'Column kwhr_mgal should be numeric');
SELECT col_type_is('v_rpt_energy_usage', 'avg_kw', 'numeric', 'Column avg_kw should be numeric');
SELECT col_type_is('v_rpt_energy_usage', 'peak_kw', 'numeric', 'Column peak_kw should be numeric');
SELECT col_type_is('v_rpt_energy_usage', 'cost_day', 'numeric', 'Column cost_day should be numeric');

SELECT * FROM finish();

ROLLBACK;
