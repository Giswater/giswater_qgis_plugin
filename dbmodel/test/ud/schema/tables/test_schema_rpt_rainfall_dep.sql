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
SELECT has_table('rpt_rainfall_dep'::name, 'Table rpt_rainfall_dep should exist');

-- Check columns
SELECT columns_are(
    'rpt_rainfall_dep',
    ARRAY[
        'id', 'result_id', 'sewer_rain', 'rdiip_prod', 'rdiir_rat'
    ],
    'Table rpt_rainfall_dep should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_rainfall_dep', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_rainfall_dep', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_rainfall_dep', 'sewer_rain', 'numeric(12,4)', 'Column sewer_rain should be numeric(12,4)');
SELECT col_type_is('rpt_rainfall_dep', 'rdiip_prod', 'numeric(12,4)', 'Column rdiip_prod should be numeric(12,4)');
SELECT col_type_is('rpt_rainfall_dep', 'rdiir_rat', 'numeric(12,4)', 'Column rdiir_rat should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('rpt_rainfall_dep', 'Table rpt_rainfall_dep should have foreign keys');

SELECT fk_ok('rpt_rainfall_dep', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
