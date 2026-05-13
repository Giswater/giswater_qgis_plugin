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
SELECT has_table('rpt_continuity_errors'::name, 'Table rpt_continuity_errors should exist');

-- Check columns
SELECT columns_are(
    'rpt_continuity_errors',
    ARRAY[
        'id', 'result_id', 'text'
    ],
    'Table rpt_continuity_errors should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_continuity_errors', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_continuity_errors', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_continuity_errors', 'text', 'varchar(255)', 'Column text should be varchar(255)');

-- Check foreign keys
SELECT has_fk('rpt_continuity_errors', 'Table rpt_continuity_errors should have foreign keys');

SELECT fk_ok('rpt_continuity_errors', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
