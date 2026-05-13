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
SELECT has_table('rpt_warning_summary'::name, 'Table rpt_warning_summary should exist');

-- Check columns
SELECT columns_are(
    'rpt_warning_summary',
    ARRAY[
        'id', 'result_id', 'warning_number', 'text'
    ],
    'Table rpt_warning_summary should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_warning_summary', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_warning_summary', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_warning_summary', 'warning_number', 'varchar(30)', 'Column warning_number should be varchar(30)');
SELECT col_type_is('rpt_warning_summary', 'text', 'text', 'Column text should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
