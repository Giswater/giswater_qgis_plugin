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

-- Check view v_plan_result_node
SELECT has_view('v_plan_result_node'::name, 'View v_plan_result_node should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_result_node',
    ARRAY[
        'node_id', 'nodecat_id', 'node_type', 'top_elev', 'elev', 'epa_type',
        'state', 'sector_id', 'expl_id', 'cost_unit', 'descript', 'measurement',
        'cost', 'budget', 'the_geom', 'builtcost', 'builtdate', 'age',
        'acoeff', 'aperiod', 'arate', 'amortized', 'pending'
    ],
    'View v_plan_result_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_result_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('v_plan_result_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_plan_result_node', 'node_type', 'varchar', 'Column node_type should be varchar');
SELECT col_type_is('v_plan_result_node', 'top_elev', 'numeric', 'Column top_elev should be numeric');
SELECT col_type_is('v_plan_result_node', 'elev', 'numeric', 'Column elev should be numeric');
SELECT col_type_is('v_plan_result_node', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('v_plan_result_node', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('v_plan_result_node', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_plan_result_node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_plan_result_node', 'cost_unit', 'varchar(3)', 'Column cost_unit should be varchar(3)');
SELECT col_type_is('v_plan_result_node', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('v_plan_result_node', 'measurement', 'numeric(12,2)', 'Column measurement should be numeric(12,2)');
SELECT col_type_is('v_plan_result_node', 'cost', 'numeric', 'Column cost should be numeric');
SELECT col_type_is('v_plan_result_node', 'budget', 'numeric(12,2)', 'Column budget should be numeric(12,2)');
SELECT col_type_is('v_plan_result_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('v_plan_result_node', 'builtcost', 'float8', 'Column builtcost should be float8');
SELECT col_type_is('v_plan_result_node', 'builtdate', 'timestamp without time zone', 'Column builtdate should be timestamp without time zone');
SELECT col_type_is('v_plan_result_node', 'age', 'float8', 'Column age should be float8');
SELECT col_type_is('v_plan_result_node', 'acoeff', 'float8', 'Column acoeff should be float8');
SELECT col_type_is('v_plan_result_node', 'aperiod', 'text', 'Column aperiod should be text');
SELECT col_type_is('v_plan_result_node', 'arate', 'float8', 'Column arate should be float8');
SELECT col_type_is('v_plan_result_node', 'amortized', 'float8', 'Column amortized should be float8');
SELECT col_type_is('v_plan_result_node', 'pending', 'float8', 'Column pending should be float8');

SELECT * FROM finish();

ROLLBACK;
