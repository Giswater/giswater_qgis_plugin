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
SELECT has_table('archived_rpt_subcatchwashoff_sum'::name, 'Table archived_rpt_subcatchwashoff_sum should exist');

-- Check columns
SELECT columns_are(
    'archived_rpt_subcatchwashoff_sum',
    ARRAY[
        'id', 'result_id', 'subc_id', 'poll_id', 'value'
    ],
    'Table archived_rpt_subcatchwashoff_sum should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_rpt_subcatchwashoff_sum', 'id', 'Column id should be primary key'); 

-- Check column types
SELECT col_type_is('archived_rpt_subcatchwashoff_sum', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_rpt_subcatchwashoff_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_subcatchwashoff_sum', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('archived_rpt_subcatchwashoff_sum', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('archived_rpt_subcatchwashoff_sum', 'value', 'numeric', 'Column value should be numeric');

-- Check indexes
SELECT has_index('archived_rpt_subcatchwashoff_sum', 'id', 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;