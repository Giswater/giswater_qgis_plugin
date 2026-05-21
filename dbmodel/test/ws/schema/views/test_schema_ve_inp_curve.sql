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

-- Check view ve_inp_curve
SELECT has_view('ve_inp_curve'::name, 'View ve_inp_curve should exist');

-- Check view columns
SELECT columns_are(
    've_inp_curve',
    ARRAY[
        'id', 'curve_type', 'descript', 'expl_id', 'log', 'active'
    ],
    'View ve_inp_curve should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_inp_curve', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ve_inp_curve', 'curve_type', 'varchar(20)', 'Column curve_type should be varchar(20)');
SELECT col_type_is('ve_inp_curve', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('ve_inp_curve', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_inp_curve', 'log', 'text', 'Column log should be text');
SELECT col_type_is('ve_inp_curve', 'active', 'bool', 'Column active should be bool');

SELECT * FROM finish();

ROLLBACK;
