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

-- Check view v_plan_psector_budget_node
SELECT has_view('v_plan_psector_budget_node'::name, 'View v_plan_psector_budget_node should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_psector_budget_node',
    ARRAY[
        'rid', 'psector_id', 'psector_type', 'node_id', 'nodecat_id', 'cost',
        'measurement', 'total_budget', 'state', 'expl_id', 'atlas_id', 'doable',
        'priority', 'the_geom'
    ],
    'View v_plan_psector_budget_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_psector_budget_node', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('v_plan_psector_budget_node', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('v_plan_psector_budget_node', 'psector_type', 'int4', 'Column psector_type should be int4');
SELECT col_type_is('v_plan_psector_budget_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('v_plan_psector_budget_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_plan_psector_budget_node', 'cost', 'numeric(12,2)', 'Column cost should be numeric(12,2)');
SELECT col_type_is('v_plan_psector_budget_node', 'measurement', 'numeric(12,2)', 'Column measurement should be numeric(12,2)');
SELECT col_type_is('v_plan_psector_budget_node', 'total_budget', 'numeric(12,2)', 'Column total_budget should be numeric(12,2)');
SELECT col_type_is('v_plan_psector_budget_node', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('v_plan_psector_budget_node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_plan_psector_budget_node', 'atlas_id', 'int4', 'Column atlas_id should be int4');
SELECT col_type_is('v_plan_psector_budget_node', 'doable', 'bool', 'Column doable should be bool');
SELECT col_type_is('v_plan_psector_budget_node', 'priority', 'varchar(16)', 'Column priority should be varchar(16)');
SELECT col_type_is('v_plan_psector_budget_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
