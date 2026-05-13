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

-- Check view v_anl_node
SELECT has_view('v_anl_node'::name, 'View v_anl_node should exist');

-- Check view columns
SELECT columns_are(
    'v_anl_node',
    ARRAY[
        'id', 'node_id', 'nodecat_id', 'state', 'node_id_aux', 'state_aux',
        'num_arcs', 'fprocesscat_id', 'expl_name', 'the_geom', 'result_id', 'descript'
    ],
    'View v_anl_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_anl_node', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_anl_node', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('v_anl_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_anl_node', 'state', 'int4', 'Column state should be int4');
SELECT col_type_is('v_anl_node', 'node_id_aux', 'varchar(16)', 'Column node_id_aux should be varchar(16)');
SELECT col_type_is('v_anl_node', 'state_aux', 'varchar(30)', 'Column state_aux should be varchar(30)');
SELECT col_type_is('v_anl_node', 'num_arcs', 'int4', 'Column num_arcs should be int4');
SELECT col_type_is('v_anl_node', 'fprocesscat_id', 'int4', 'Column fprocesscat_id should be int4');
SELECT col_type_is('v_anl_node', 'expl_name', 'varchar(100)', 'Column expl_name should be varchar(100)');
SELECT col_type_is('v_anl_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('v_anl_node', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('v_anl_node', 'descript', 'text', 'Column descript should be text');

SELECT * FROM finish();

ROLLBACK;
