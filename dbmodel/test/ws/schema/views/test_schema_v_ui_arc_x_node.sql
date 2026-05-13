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

-- Check view v_ui_arc_x_node
SELECT has_view('v_ui_arc_x_node'::name, 'View v_ui_arc_x_node should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_arc_x_node',
    ARRAY[
        'arc_id', 'node_1', 'x1', 'y1', 'node_2', 'x2',
        'y2'
    ],
    'View v_ui_arc_x_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_arc_x_node', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_ui_arc_x_node', 'node_1', 'int4', 'Column node_1 should be int4');
SELECT col_type_is('v_ui_arc_x_node', 'x1', 'float8', 'Column x1 should be float8');
SELECT col_type_is('v_ui_arc_x_node', 'y1', 'float8', 'Column y1 should be float8');
SELECT col_type_is('v_ui_arc_x_node', 'node_2', 'int4', 'Column node_2 should be int4');
SELECT col_type_is('v_ui_arc_x_node', 'x2', 'float8', 'Column x2 should be float8');
SELECT col_type_is('v_ui_arc_x_node', 'y2', 'float8', 'Column y2 should be float8');

SELECT * FROM finish();

ROLLBACK;
