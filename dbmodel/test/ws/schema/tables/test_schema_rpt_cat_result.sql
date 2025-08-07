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

-- Check table rpt_cat_result
SELECT has_table('rpt_cat_result'::name, 'Table rpt_cat_result should exist');

-- Check columns
SELECT columns_are(
    'rpt_cat_result',
    ARRAY[
        'result_id', 'exec_date', 'q_timestep', 'q_tolerance', 'cur_user', 'inp_options',
        'rpt_stats', 'export_options', 'network_stats', 'status', 'iscorporate',
        'addparam', 'expl_id', 'network_type', 'sector_id', 'descript', 'inp_file', 'dma_id', 'flow_units', 'quality_units'
    ],
    'Table rpt_cat_result should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('rpt_cat_result', ARRAY['result_id'], 'Column result_id should be primary key');

-- Check column types
SELECT col_type_is('rpt_cat_result', 'result_id', 'character varying(50)', 'Column result_id should be character varying(50)');
SELECT col_type_is('rpt_cat_result', 'exec_date', 'timestamp(6) without time zone', 'Column exec_date should be timestamp(6) without time zone');
SELECT col_type_is('rpt_cat_result', 'q_timestep', 'character varying(16)', 'Column q_timestep should be character varying(16)');
SELECT col_type_is('rpt_cat_result', 'q_tolerance', 'character varying(16)', 'Column q_tolerance should be character varying(16)');
SELECT col_type_is('rpt_cat_result', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('rpt_cat_result', 'inp_options', 'json', 'Column inp_options should be json');
SELECT col_type_is('rpt_cat_result', 'rpt_stats', 'json', 'Column rpt_stats should be json');
SELECT col_type_is('rpt_cat_result', 'export_options', 'json', 'Column export_options should be json');
SELECT col_type_is('rpt_cat_result', 'network_stats', 'json', 'Column network_stats should be json');
SELECT col_type_is('rpt_cat_result', 'status', 'smallint', 'Column status should be smallint');
SELECT col_type_is('rpt_cat_result', 'iscorporate', 'boolean', 'Column iscorporate should be boolean');
SELECT col_type_is('rpt_cat_result', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('rpt_cat_result', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('rpt_cat_result', 'network_type', 'text', 'Column network_type should be text');
SELECT col_type_is('rpt_cat_result', 'sector_id', 'integer[]', 'Column sector_id should be integer[]');
SELECT col_type_is('rpt_cat_result', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('rpt_cat_result', 'inp_file', 'bytea', 'Column inp_file should be bytea');
SELECT col_type_is('rpt_cat_result', 'dma_id', 'integer[]', 'Column dma_id should be integer[]');
SELECT col_type_is('rpt_cat_result', 'flow_units', 'text', 'Column flow_units should be text');
SELECT col_type_is('rpt_cat_result', 'quality_units', 'text', 'Column quality_units should be text');

-- Check default values
SELECT col_has_default('rpt_cat_result', 'exec_date', 'Column exec_date should have a default value');
SELECT col_default_is('rpt_cat_result', 'cur_user', 'CURRENT_USER', 'Default value for cur_user should be CURRENT_USER');
SELECT col_default_is('rpt_cat_result', 'iscorporate', 'false', 'Default value for iscorporate should be false');

-- Check constraints
SELECT col_not_null('rpt_cat_result', 'result_id', 'Column result_id should be NOT NULL');
SELECT col_not_null('rpt_cat_result', 'iscorporate', 'Column iscorporate should be NOT NULL');
SELECT col_has_check('rpt_cat_result', 'status', 'Column status should have a check constraint on status');

SELECT * FROM finish();

ROLLBACK;