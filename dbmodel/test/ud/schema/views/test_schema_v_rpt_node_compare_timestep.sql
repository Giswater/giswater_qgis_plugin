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

-- Check view v_rpt_node_compare_timestep
SELECT has_view('v_rpt_node_compare_timestep'::name, 'View v_rpt_node_compare_timestep should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_node_compare_timestep',
    ARRAY[
        'id', 'node_id', 'result_id', 'node_type', 'nodecat_id', 'resultdate',
        'resulttime', 'flooding', 'depth', 'head', 'the_geom'
    ],
    'View v_rpt_node_compare_timestep should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_node_compare_timestep', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('v_rpt_node_compare_timestep', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('v_rpt_node_compare_timestep', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_node_compare_timestep', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('v_rpt_node_compare_timestep', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_rpt_node_compare_timestep', 'resultdate', 'varchar(16)', 'Column resultdate should be varchar(16)');
SELECT col_type_is('v_rpt_node_compare_timestep', 'resulttime', 'varchar(12)', 'Column resulttime should be varchar(12)');
SELECT col_type_is('v_rpt_node_compare_timestep', 'flooding', 'float8', 'Column flooding should be float8');
SELECT col_type_is('v_rpt_node_compare_timestep', 'depth', 'float8', 'Column depth should be float8');
SELECT col_type_is('v_rpt_node_compare_timestep', 'head', 'float8', 'Column head should be float8');
SELECT col_type_is('v_rpt_node_compare_timestep', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
