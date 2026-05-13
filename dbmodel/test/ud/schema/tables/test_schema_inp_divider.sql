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
SELECT has_table('inp_divider'::name, 'Table inp_divider should exist');

-- Check columns
SELECT columns_are(
    'inp_divider',
    ARRAY[
        'node_id', 'divider_type', 'arc_id', 'curve_id', 'qmin', 'ht',
        'cd', 'y0', 'ysur', 'apond'
    ],
    'Table inp_divider should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_divider', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('inp_divider', 'divider_type', 'varchar(18)', 'Column divider_type should be varchar(18)');
SELECT col_type_is('inp_divider', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('inp_divider', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('inp_divider', 'qmin', 'numeric(16,6)', 'Column qmin should be numeric(16,6)');
SELECT col_type_is('inp_divider', 'ht', 'numeric(12,4)', 'Column ht should be numeric(12,4)');
SELECT col_type_is('inp_divider', 'cd', 'numeric(12,4)', 'Column cd should be numeric(12,4)');
SELECT col_type_is('inp_divider', 'y0', 'numeric(12,4)', 'Column y0 should be numeric(12,4)');
SELECT col_type_is('inp_divider', 'ysur', 'numeric(12,4)', 'Column ysur should be numeric(12,4)');
SELECT col_type_is('inp_divider', 'apond', 'numeric(12,4)', 'Column apond should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('inp_divider', 'Table inp_divider should have foreign keys');

SELECT fk_ok('inp_divider', 'curve_id', 'inp_curve', 'id', 'FK curve_id → inp_curve.id');
SELECT fk_ok('inp_divider', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');
SELECT fk_ok('inp_divider', 'arc_id', 'arc', 'arc_id', 'FK arc_id → arc.arc_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
