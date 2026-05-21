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
SELECT has_table('rpt_summary_raingage'::name, 'Table rpt_summary_raingage should exist');

-- Check columns
SELECT columns_are(
    'rpt_summary_raingage',
    ARRAY[
        'id', 'result_id', 'rg_id', 'data_source', 'data_type', 'interval'
    ],
    'Table rpt_summary_raingage should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_summary_raingage', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_summary_raingage', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_summary_raingage', 'rg_id', 'varchar(16)', 'Column rg_id should be varchar(16)');
SELECT col_type_is('rpt_summary_raingage', 'data_source', 'varchar(16)', 'Column data_source should be varchar(16)');
SELECT col_type_is('rpt_summary_raingage', 'data_type', 'varchar(16)', 'Column data_type should be varchar(16)');
SELECT col_type_is('rpt_summary_raingage', 'interval', 'varchar(16)', 'Column interval should be varchar(16)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
