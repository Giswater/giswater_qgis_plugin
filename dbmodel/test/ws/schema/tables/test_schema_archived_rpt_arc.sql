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
        'id', 'result_id', 'arc_id', 'length', 'diameter', 'flow',
        'vel', 'headloss', 'setting', 'reaction', 'ffactor', 'other',
        'time', 'status'
    ],
    'Table archived_rpt_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('archived_rpt_arc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('archived_rpt_arc', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_arc', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('archived_rpt_arc', 'length', 'numeric', 'Column length should be numeric');
SELECT col_type_is('archived_rpt_arc', 'diameter', 'numeric', 'Column diameter should be numeric');
SELECT col_type_is('archived_rpt_arc', 'flow', 'numeric', 'Column flow should be numeric');
SELECT col_type_is('archived_rpt_arc', 'vel', 'numeric', 'Column vel should be numeric');
SELECT col_type_is('archived_rpt_arc', 'headloss', 'numeric', 'Column headloss should be numeric');
SELECT col_type_is('archived_rpt_arc', 'setting', 'numeric', 'Column setting should be numeric');
SELECT col_type_is('archived_rpt_arc', 'reaction', 'numeric', 'Column reaction should be numeric');
SELECT col_type_is('archived_rpt_arc', 'ffactor', 'numeric', 'Column ffactor should be numeric');
SELECT col_type_is('archived_rpt_arc', 'other', 'varchar(100)', 'Column other should be varchar(100)');
SELECT col_type_is('archived_rpt_arc', 'time', 'varchar(100)', 'Column time should be varchar(100)');
SELECT col_type_is('archived_rpt_arc', 'status', 'varchar(16)', 'Column status should be varchar(16)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
