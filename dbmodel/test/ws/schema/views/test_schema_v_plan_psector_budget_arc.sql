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

-- Check view v_plan_psector_budget_arc
SELECT has_view('v_plan_psector_budget_arc'::name, 'View v_plan_psector_budget_arc should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_psector_budget_arc',
    ARRAY[
        'rid', 'psector_id', 'psector_type', 'arc_id', 'arccat_id', 'cost_unit',
        'cost', 'length', 'budget', 'other_budget', 'total_budget', 'state',
        'expl_id', 'atlas_id', 'doable', 'priority', 'the_geom'
    ],
    'View v_plan_psector_budget_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_psector_budget_arc', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('v_plan_psector_budget_arc', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('v_plan_psector_budget_arc', 'psector_type', 'int4', 'Column psector_type should be int4');
SELECT col_type_is('v_plan_psector_budget_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_plan_psector_budget_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_plan_psector_budget_arc', 'cost_unit', 'varchar(3)', 'Column cost_unit should be varchar(3)');
SELECT col_type_is('v_plan_psector_budget_arc', 'cost', 'numeric(14,2)', 'Column cost should be numeric(14,2)');
SELECT col_type_is('v_plan_psector_budget_arc', 'length', 'numeric(12,2)', 'Column length should be numeric(12,2)');
SELECT col_type_is('v_plan_psector_budget_arc', 'budget', 'numeric(14,2)', 'Column budget should be numeric(14,2)');
SELECT col_type_is('v_plan_psector_budget_arc', 'other_budget', 'numeric(12,2)', 'Column other_budget should be numeric(12,2)');
SELECT col_type_is('v_plan_psector_budget_arc', 'total_budget', 'numeric(14,2)', 'Column total_budget should be numeric(14,2)');
SELECT col_type_is('v_plan_psector_budget_arc', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('v_plan_psector_budget_arc', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_plan_psector_budget_arc', 'atlas_id', 'int4', 'Column atlas_id should be int4');
SELECT col_type_is('v_plan_psector_budget_arc', 'doable', 'bool', 'Column doable should be bool');
SELECT col_type_is('v_plan_psector_budget_arc', 'priority', 'varchar(16)', 'Column priority should be varchar(16)');
SELECT col_type_is('v_plan_psector_budget_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
