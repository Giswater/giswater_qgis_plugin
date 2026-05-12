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

-- Check table archived_rpt_energy_usage
SELECT has_table('archived_rpt_energy_usage'::name, 'Table archived_rpt_energy_usage should exist');

-- Check columns
SELECT columns_are(
    'archived_rpt_energy_usage',
    ARRAY[
        'id', 'result_id', 'nodarc_id', 'usage_fact', 'avg_effic', 'kwhr_mgal', 'avg_kw', 'peak_kw', 'cost_day'
    ],
    'Table archived_rpt_energy_usage should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_rpt_energy_usage', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_rpt_energy_usage', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_rpt_energy_usage', 'result_id', 'character varying(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_energy_usage', 'nodarc_id', 'character varying(16)', 'Column nodarc_id should be varchar(16)');
SELECT col_type_is('archived_rpt_energy_usage', 'usage_fact', 'numeric', 'Column usage_fact should be numeric');
SELECT col_type_is('archived_rpt_energy_usage', 'avg_effic', 'numeric', 'Column avg_effic should be numeric');
SELECT col_type_is('archived_rpt_energy_usage', 'kwhr_mgal', 'numeric', 'Column kwhr_mgal should be numeric');
SELECT col_type_is('archived_rpt_energy_usage', 'avg_kw', 'numeric', 'Column avg_kw should be numeric');
SELECT col_type_is('archived_rpt_energy_usage', 'peak_kw', 'numeric', 'Column peak_kw should be numeric');
SELECT col_type_is('archived_rpt_energy_usage', 'cost_day', 'numeric', 'Column cost_day should be numeric');

-- Check foreign keys
SELECT hasnt_fk('archived_rpt_energy_usage', 'Table archived_rpt_energy_usage should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_rpt_energy_usage_id_seq', 'Sequence archived_rpt_energy_usage_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
