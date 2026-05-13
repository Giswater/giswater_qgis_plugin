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

-- Check view v_plan_node
SELECT has_view('v_plan_node'::name, 'View v_plan_node should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_node',
    ARRAY[
        'node_id', 'nodecat_id', 'node_type', 'top_elev', 'elev', 'epa_type',
        'state', 'sector_id', 'expl_id', 'annotation', 'cost_unit', 'descript',
        'cost', 'measurement', 'budget', 'the_geom'
    ],
    'View v_plan_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('v_plan_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_plan_node', 'node_type', 'text', 'Column node_type should be text');
SELECT col_type_is('v_plan_node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('v_plan_node', 'elev', 'numeric(12,3)', 'Column elev should be numeric(12,3)');
SELECT col_type_is('v_plan_node', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('v_plan_node', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('v_plan_node', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_plan_node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_plan_node', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('v_plan_node', 'cost_unit', 'varchar(3)', 'Column cost_unit should be varchar(3)');
SELECT col_type_is('v_plan_node', 'descript', 'varchar(100)', 'Column descript should be varchar(100)');
SELECT col_type_is('v_plan_node', 'cost', 'numeric(14,2)', 'Column cost should be numeric(14,2)');
SELECT col_type_is('v_plan_node', 'measurement', 'numeric(12,2)', 'Column measurement should be numeric(12,2)');
SELECT col_type_is('v_plan_node', 'budget', 'numeric(12,2)', 'Column budget should be numeric(12,2)');
SELECT col_type_is('v_plan_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
