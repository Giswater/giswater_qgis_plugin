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
SELECT has_table('rpt_hydraulic_status'::name, 'Table rpt_hydraulic_status should exist');

-- Check columns
SELECT columns_are(
    'rpt_hydraulic_status',
    ARRAY[
        'id', 'result_id', 'time', 'text'
    ],
    'Table rpt_hydraulic_status should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_hydraulic_status', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_hydraulic_status', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_hydraulic_status', 'time', 'varchar(20)', 'Column time should be varchar(20)');
SELECT col_type_is('rpt_hydraulic_status', 'text', 'text', 'Column text should be text');

-- Check foreign keys
SELECT has_fk('rpt_hydraulic_status', 'Table rpt_hydraulic_status should have foreign keys');

SELECT fk_ok('rpt_hydraulic_status', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
