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
SELECT has_table('ext_rtc_dma_period'::name, 'Table ext_rtc_dma_period should exist');

-- Check columns
SELECT columns_are(
    'ext_rtc_dma_period',
    ARRAY[
        'id', 'dma_id', 'cat_period_id', 'effc', 'minc', 'maxc',
        'pattern_id', 'pattern_volume', 'avg_press'
    ],
    'Table ext_rtc_dma_period should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_rtc_dma_period', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('ext_rtc_dma_period', 'dma_id', 'varchar(16)', 'Column dma_id should be varchar(16)');
SELECT col_type_is('ext_rtc_dma_period', 'cat_period_id', 'varchar(16)', 'Column cat_period_id should be varchar(16)');
SELECT col_type_is('ext_rtc_dma_period', 'effc', 'float8', 'Column effc should be float8');
SELECT col_type_is('ext_rtc_dma_period', 'minc', 'float8', 'Column minc should be float8');
SELECT col_type_is('ext_rtc_dma_period', 'maxc', 'float8', 'Column maxc should be float8');
SELECT col_type_is('ext_rtc_dma_period', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('ext_rtc_dma_period', 'pattern_volume', 'float8', 'Column pattern_volume should be float8');
SELECT col_type_is('ext_rtc_dma_period', 'avg_press', 'numeric', 'Column avg_press should be numeric');

-- Check foreign keys
SELECT has_fk('ext_rtc_dma_period', 'Table ext_rtc_dma_period should have foreign keys');

SELECT fk_ok('ext_rtc_dma_period', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id → inp_pattern.pattern_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
