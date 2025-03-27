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

-- Check table rpt_energy_usage
SELECT has_table('rpt_energy_usage'::name, 'Table rpt_energy_usage should exist');

-- Check columns
SELECT columns_are(
    'rpt_energy_usage',
    ARRAY[
        'id', 'result_id', 'nodarc_id', 'usage_fact', 'avg_effic', 'kwhr_mgal',
        'avg_kw', 'peak_kw', 'cost_day'
    ],
    'Table rpt_energy_usage should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('rpt_energy_usage', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('rpt_energy_usage', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('rpt_energy_usage', 'result_id', 'character varying(30)', 'Column result_id should be character varying(30)');
SELECT col_type_is('rpt_energy_usage', 'nodarc_id', 'character varying(16)', 'Column nodarc_id should be character varying(16)');
SELECT col_type_is('rpt_energy_usage', 'usage_fact', 'numeric', 'Column usage_fact should be numeric');
SELECT col_type_is('rpt_energy_usage', 'avg_effic', 'numeric', 'Column avg_effic should be numeric');
SELECT col_type_is('rpt_energy_usage', 'kwhr_mgal', 'numeric', 'Column kwhr_mgal should be numeric');
SELECT col_type_is('rpt_energy_usage', 'avg_kw', 'numeric', 'Column avg_kw should be numeric');
SELECT col_type_is('rpt_energy_usage', 'peak_kw', 'numeric', 'Column peak_kw should be numeric');
SELECT col_type_is('rpt_energy_usage', 'cost_day', 'numeric', 'Column cost_day should be numeric');

-- Check default values
SELECT col_has_default('rpt_energy_usage', 'id', 'Column id should have a default value');

-- Check constraints
SELECT col_not_null('rpt_energy_usage', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('rpt_energy_usage', 'result_id', 'Column result_id should be NOT NULL');

-- Check foreign keys
SELECT has_fk('rpt_energy_usage', 'Table rpt_energy_usage should have foreign keys');
SELECT fk_ok('rpt_energy_usage', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id should reference rpt_cat_result.result_id');

SELECT * FROM finish();

ROLLBACK; 