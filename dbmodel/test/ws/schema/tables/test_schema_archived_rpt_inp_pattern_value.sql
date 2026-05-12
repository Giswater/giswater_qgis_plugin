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

-- Check table archived_rpt_inp_pattern_value
SELECT has_table('archived_rpt_inp_pattern_value'::name, 'Table archived_rpt_inp_pattern_value should exist');

-- Check columns
SELECT columns_are(
    'archived_rpt_inp_pattern_value',
    ARRAY[
        'id', 'result_id', 'dma_id', 'pattern_id', 'idrow', 'factor_1', 'factor_2', 'factor_3', 'factor_4', 'factor_5',
        'factor_6', 'factor_7', 'factor_8', 'factor_9', 'factor_10', 'factor_11', 'factor_12', 'factor_13', 'factor_14',
        'factor_15', 'factor_16', 'factor_17', 'factor_18', 'user_name'
    ],
    'Table archived_rpt_inp_pattern_value should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_rpt_inp_pattern_value', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_rpt_inp_pattern_value', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'result_id', 'character varying(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'pattern_id', 'character varying(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'idrow', 'integer', 'Column idrow should be integer');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_1', 'numeric(12,4)', 'Column factor_1 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_2', 'numeric(12,4)', 'Column factor_2 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_3', 'numeric(12,4)', 'Column factor_3 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_4', 'numeric(12,4)', 'Column factor_4 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_5', 'numeric(12,4)', 'Column factor_5 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_6', 'numeric(12,4)', 'Column factor_6 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_7', 'numeric(12,4)', 'Column factor_7 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_8', 'numeric(12,4)', 'Column factor_8 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_9', 'numeric(12,4)', 'Column factor_9 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_10', 'numeric(12,4)', 'Column factor_10 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_11', 'numeric(12,4)', 'Column factor_11 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_12', 'numeric(12,4)', 'Column factor_12 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_13', 'numeric(12,4)', 'Column factor_13 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_14', 'numeric(12,4)', 'Column factor_14 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_15', 'numeric(12,4)', 'Column factor_15 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_16', 'numeric(12,4)', 'Column factor_16 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_17', 'numeric(12,4)', 'Column factor_17 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'factor_18', 'numeric(12,4)', 'Column factor_18 should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_pattern_value', 'user_name', 'text', 'Column user_name should be text');

-- Check foreign keys
SELECT hasnt_fk('archived_rpt_inp_pattern_value', 'Table archived_rpt_inp_pattern_value should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_rpt_inp_pattern_value_id_seq', 'Sequence archived_rpt_inp_pattern_value_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
