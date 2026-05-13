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

-- Check view v_plan_result_arc
SELECT has_view('v_plan_result_arc'::name, 'View v_plan_result_arc should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_result_arc',
    ARRAY[
        'arc_id', 'node_1', 'node_2', 'arc_type', 'arccat_id', 'epa_type',
        'state', 'sector_id', 'expl_id', 'annotation', 'soilcat_id', 'y1',
        'y2', 'mean_y', 'z1', 'z2', 'thickness', 'width',
        'b', 'bulk', 'geom1', 'area', 'y_param', 'total_y',
        'rec_y', 'geom1_ext', 'calculed_y', 'm3mlexc', 'm2mltrenchl', 'm2mlbottom',
        'm2mlpav', 'm3mlprotec', 'm3mlfill', 'm3mlexcess', 'm3exc_cost', 'm2trenchl_cost',
        'm2bottom_cost', 'm2pav_cost', 'm3protec_cost', 'm3fill_cost', 'm3excess_cost', 'cost_unit',
        'pav_cost', 'exc_cost', 'trenchl_cost', 'base_cost', 'protec_cost', 'fill_cost',
        'excess_cost', 'arc_cost', 'cost', 'length', 'budget', 'other_budget',
        'total_budget', 'the_geom', 'builtcost', 'builtdate', 'age', 'acoeff',
        'aperiod', 'arate', 'amortized', 'pending'
    ],
    'View v_plan_result_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_result_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_plan_result_arc', 'node_1', 'int4', 'Column node_1 should be int4');
SELECT col_type_is('v_plan_result_arc', 'node_2', 'int4', 'Column node_2 should be int4');
SELECT col_type_is('v_plan_result_arc', 'arc_type', 'text', 'Column arc_type should be text');
SELECT col_type_is('v_plan_result_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_plan_result_arc', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('v_plan_result_arc', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('v_plan_result_arc', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_plan_result_arc', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_plan_result_arc', 'annotation', 'varchar', 'Column annotation should be varchar');
SELECT col_type_is('v_plan_result_arc', 'soilcat_id', 'varchar(30)', 'Column soilcat_id should be varchar(30)');
SELECT col_type_is('v_plan_result_arc', 'y1', 'numeric', 'Column y1 should be numeric');
SELECT col_type_is('v_plan_result_arc', 'y2', 'numeric', 'Column y2 should be numeric');
SELECT col_type_is('v_plan_result_arc', 'mean_y', 'numeric(12,2)', 'Column mean_y should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'z1', 'numeric(12,2)', 'Column z1 should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'z2', 'numeric(12,2)', 'Column z2 should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'thickness', 'numeric(12,2)', 'Column thickness should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'width', 'numeric(12,2)', 'Column width should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'b', 'numeric', 'Column b should be numeric');
SELECT col_type_is('v_plan_result_arc', 'bulk', 'numeric(12,2)', 'Column bulk should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'geom1', 'numeric', 'Column geom1 should be numeric');
SELECT col_type_is('v_plan_result_arc', 'area', 'numeric', 'Column area should be numeric');
SELECT col_type_is('v_plan_result_arc', 'y_param', 'numeric', 'Column y_param should be numeric');
SELECT col_type_is('v_plan_result_arc', 'total_y', 'numeric(12,2)', 'Column total_y should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'rec_y', 'numeric(12,2)', 'Column rec_y should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'geom1_ext', 'numeric(12,2)', 'Column geom1_ext should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'calculed_y', 'numeric', 'Column calculed_y should be numeric');
SELECT col_type_is('v_plan_result_arc', 'm3mlexc', 'numeric', 'Column m3mlexc should be numeric');
SELECT col_type_is('v_plan_result_arc', 'm2mltrenchl', 'numeric', 'Column m2mltrenchl should be numeric');
SELECT col_type_is('v_plan_result_arc', 'm2mlbottom', 'numeric', 'Column m2mlbottom should be numeric');
SELECT col_type_is('v_plan_result_arc', 'm2mlpav', 'numeric', 'Column m2mlpav should be numeric');
SELECT col_type_is('v_plan_result_arc', 'm3mlprotec', 'numeric', 'Column m3mlprotec should be numeric');
SELECT col_type_is('v_plan_result_arc', 'm3mlfill', 'numeric', 'Column m3mlfill should be numeric');
SELECT col_type_is('v_plan_result_arc', 'm3mlexcess', 'numeric', 'Column m3mlexcess should be numeric');
SELECT col_type_is('v_plan_result_arc', 'm3exc_cost', 'numeric(12,2)', 'Column m3exc_cost should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'm2trenchl_cost', 'numeric(12,2)', 'Column m2trenchl_cost should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'm2bottom_cost', 'numeric(12,2)', 'Column m2bottom_cost should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'm2pav_cost', 'numeric(12,2)', 'Column m2pav_cost should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'm3protec_cost', 'numeric(12,2)', 'Column m3protec_cost should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'm3fill_cost', 'numeric(12,2)', 'Column m3fill_cost should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'm3excess_cost', 'numeric(12,2)', 'Column m3excess_cost should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'cost_unit', 'varchar', 'Column cost_unit should be varchar');
SELECT col_type_is('v_plan_result_arc', 'pav_cost', 'numeric', 'Column pav_cost should be numeric');
SELECT col_type_is('v_plan_result_arc', 'exc_cost', 'numeric', 'Column exc_cost should be numeric');
SELECT col_type_is('v_plan_result_arc', 'trenchl_cost', 'numeric', 'Column trenchl_cost should be numeric');
SELECT col_type_is('v_plan_result_arc', 'base_cost', 'numeric', 'Column base_cost should be numeric');
SELECT col_type_is('v_plan_result_arc', 'protec_cost', 'numeric', 'Column protec_cost should be numeric');
SELECT col_type_is('v_plan_result_arc', 'fill_cost', 'numeric', 'Column fill_cost should be numeric');
SELECT col_type_is('v_plan_result_arc', 'excess_cost', 'numeric', 'Column excess_cost should be numeric');
SELECT col_type_is('v_plan_result_arc', 'arc_cost', 'numeric', 'Column arc_cost should be numeric');
SELECT col_type_is('v_plan_result_arc', 'cost', 'numeric(12,2)', 'Column cost should be numeric(12,2)');
SELECT col_type_is('v_plan_result_arc', 'length', 'numeric', 'Column length should be numeric');
SELECT col_type_is('v_plan_result_arc', 'budget', 'numeric', 'Column budget should be numeric');
SELECT col_type_is('v_plan_result_arc', 'other_budget', 'numeric', 'Column other_budget should be numeric');
SELECT col_type_is('v_plan_result_arc', 'total_budget', 'numeric', 'Column total_budget should be numeric');
SELECT col_type_is('v_plan_result_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('v_plan_result_arc', 'builtcost', 'float8', 'Column builtcost should be float8');
SELECT col_type_is('v_plan_result_arc', 'builtdate', 'timestamp without time zone', 'Column builtdate should be timestamp without time zone');
SELECT col_type_is('v_plan_result_arc', 'age', 'float8', 'Column age should be float8');
SELECT col_type_is('v_plan_result_arc', 'acoeff', 'float8', 'Column acoeff should be float8');
SELECT col_type_is('v_plan_result_arc', 'aperiod', 'text', 'Column aperiod should be text');
SELECT col_type_is('v_plan_result_arc', 'arate', 'float8', 'Column arate should be float8');
SELECT col_type_is('v_plan_result_arc', 'amortized', 'float8', 'Column amortized should be float8');
SELECT col_type_is('v_plan_result_arc', 'pending', 'float8', 'Column pending should be float8');

SELECT * FROM finish();

ROLLBACK;
