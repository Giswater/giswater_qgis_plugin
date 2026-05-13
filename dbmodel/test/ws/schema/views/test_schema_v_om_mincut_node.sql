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

-- Check view v_om_mincut_node
SELECT has_view('v_om_mincut_node'::name, 'View v_om_mincut_node should exist');

-- Check view columns
SELECT columns_are(
    'v_om_mincut_node',
    ARRAY[
        'id', 'result_id', 'work_order', 'node_id', 'node_type', 'result_type',
        'the_geom'
    ],
    'View v_om_mincut_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_om_mincut_node', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_om_mincut_node', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('v_om_mincut_node', 'work_order', 'varchar(50)', 'Column work_order should be varchar(50)');
SELECT col_type_is('v_om_mincut_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('v_om_mincut_node', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('v_om_mincut_node', 'result_type', 'text', 'Column result_type should be text');
SELECT col_type_is('v_om_mincut_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
