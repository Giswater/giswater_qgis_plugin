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
SELECT has_table('archived_rpt_arc'::name, 'Table archived_rpt_arc should exist');

-- Check columns
SELECT columns_are(
    'archived_rpt_arc',
    ARRAY[
        'id', 'result_id', 'arc_id', 'resultdate', 'resulttime', 'flow',
        'velocity', 'fullpercent'
    ],
    'Table archived_rpt_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('archived_rpt_arc', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('archived_rpt_arc', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('archived_rpt_arc', 'resultdate', 'varchar(16)', 'Column resultdate should be varchar(16)');
SELECT col_type_is('archived_rpt_arc', 'resulttime', 'varchar(12)', 'Column resulttime should be varchar(12)');
SELECT col_type_is('archived_rpt_arc', 'flow', 'float8', 'Column flow should be float8');
SELECT col_type_is('archived_rpt_arc', 'velocity', 'float8', 'Column velocity should be float8');
SELECT col_type_is('archived_rpt_arc', 'fullpercent', 'float8', 'Column fullpercent should be float8');

-- Finish
SELECT * FROM finish();

ROLLBACK;
