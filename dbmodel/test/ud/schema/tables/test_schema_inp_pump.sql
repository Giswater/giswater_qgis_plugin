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
SELECT has_table('inp_pump'::name, 'Table inp_pump should exist');

-- Check columns
SELECT columns_are(
    'inp_pump',
    ARRAY[
        'arc_id', 'curve_id', 'status', 'startup', 'shutoff'
    ],
    'Table inp_pump should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_pump', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('inp_pump', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('inp_pump', 'status', 'varchar(3)', 'Column status should be varchar(3)');
SELECT col_type_is('inp_pump', 'startup', 'numeric(12,4)', 'Column startup should be numeric(12,4)');
SELECT col_type_is('inp_pump', 'shutoff', 'numeric(12,4)', 'Column shutoff should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('inp_pump', 'Table inp_pump should have foreign keys');

SELECT fk_ok('inp_pump', 'curve_id', 'inp_curve', 'id', 'FK curve_id → inp_curve.id');
SELECT fk_ok('inp_pump', 'arc_id', 'arc', 'arc_id', 'FK arc_id → arc.arc_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
