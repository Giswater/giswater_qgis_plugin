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

-- Check table ext_rtc_dma_period
SELECT has_table('ext_rtc_dma_period'::name, 'Table ext_rtc_dma_period should exist');

-- Check columns
SELECT columns_are(
    'ext_rtc_dma_period',
    ARRAY[
        'id', 'dma_id', 'cat_period_id', 'effc', 'minc', 'maxc', 'pattern_id', 'pattern_volume', 'avg_press'
    ],
    'Table ext_rtc_dma_period should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_rtc_dma_period', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_rtc_dma_period', 'id', 'bigint', 'Column id should be bigint');
SELECT col_type_is('ext_rtc_dma_period', 'dma_id', 'varchar(16)', 'Column dma_id should be varchar(16)');
SELECT col_type_is('ext_rtc_dma_period', 'cat_period_id', 'varchar(16)', 'Column cat_period_id should be varchar(16)');
SELECT col_type_is('ext_rtc_dma_period', 'effc', 'double precision', 'Column effc should be double precision');
SELECT col_type_is('ext_rtc_dma_period', 'minc', 'double precision', 'Column minc should be double precision');
SELECT col_type_is('ext_rtc_dma_period', 'maxc', 'double precision', 'Column maxc should be double precision');
SELECT col_type_is('ext_rtc_dma_period', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('ext_rtc_dma_period', 'pattern_volume', 'double precision', 'Column pattern_volume should be double precision');
SELECT col_type_is('ext_rtc_dma_period', 'avg_press', 'numeric', 'Column avg_press should be numeric');

-- Check foreign keys
SELECT has_fk('ext_rtc_dma_period', 'Table ext_rtc_dma_period should have foreign keys');
SELECT fk_ok('ext_rtc_dma_period', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK ext_rtc_dma_period_pattern_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('ext_rtc_scada_dma_period_seq', 'Sequence ext_rtc_scada_dma_period_seq should exist');

-- Check constraints
SELECT col_not_null('ext_rtc_dma_period', 'id', 'Column id should be NOT NULL');
SELECT col_has_default('ext_rtc_dma_period', 'id', 'Column id should have default value');

SELECT * FROM finish();

ROLLBACK;
