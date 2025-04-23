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

-- Check table plan_rec_result_arc
SELECT has_table('plan_rec_result_arc'::name, 'Table plan_rec_result_arc should exist');

-- Check columns
SELECT columns_are(
    'plan_rec_result_arc',
    ARRAY[
        'result_id', 'arc_id', 'node_1', 'node_2', 'arc_type', 'arccat_id', 'epa_type', 'sector_id', 
        'state', 'annotation', 'soilcat_id', 'y1', 'y2', 'mean_y', 'z1', 'z2', 'thickness', 
        'width', 'b', 'bulk', 'geom1', 'area', 'y_param', 'total_y', 'rec_y', 'geom1_ext', 
        'calculed_y', 'm3mlexc', 'm2mltrenchl', 'm2mlbottom', 'm2mlpav', 'm3mlprotec', 'm3mlfill', 
        'm3mlexcess', 'm3exc_cost', 'm2trenchl_cost', 'm2bottom_cost', 'm2pav_cost', 'm3protec_cost', 
        'm3fill_cost', 'm3excess_cost', 'cost_unit', 'pav_cost', 'exc_cost', 'trenchl_cost', 
        'base_cost', 'protec_cost', 'fill_cost', 'excess_cost', 'arc_cost', 'cost', 'length', 
        'budget', 'other_budget', 'total_budget', 'the_geom', 'expl_id', 'builtcost', 'builtdate', 
        'age', 'acoeff', 'aperiod', 'arate', 'amortized', 'pending'
    ],
    'Table plan_rec_result_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_rec_result_arc', ARRAY['arc_id', 'result_id'], 'Columns arc_id and result_id should be primary key');

-- Check column types (a representative sample)
SELECT col_type_is('plan_rec_result_arc', 'result_id', 'integer', 'Column result_id should be integer');
SELECT col_type_is('plan_rec_result_arc', 'arc_id', 'character varying(16)', 'Column arc_id should be character varying(16)');
SELECT col_type_is('plan_rec_result_arc', 'node_1', 'character varying(16)', 'Column node_1 should be character varying(16)');
SELECT col_type_is('plan_rec_result_arc', 'node_2', 'character varying(16)', 'Column node_2 should be character varying(16)');
SELECT col_type_is('plan_rec_result_arc', 'arc_type', 'character varying(18)', 'Column arc_type should be character varying(18)');
SELECT col_type_is('plan_rec_result_arc', 'arccat_id', 'character varying(30)', 'Column arccat_id should be character varying(30)');
SELECT col_type_is('plan_rec_result_arc', 'cost', 'numeric(12,2)', 'Column cost should be numeric(12,2)');
SELECT col_type_is('plan_rec_result_arc', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('plan_rec_result_arc', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');
SELECT col_type_is('plan_rec_result_arc', 'builtcost', 'double precision', 'Column builtcost should be double precision');
SELECT col_type_is('plan_rec_result_arc', 'aperiod', 'text', 'Column aperiod should be text');
SELECT col_type_is('plan_rec_result_arc', 'pending', 'double precision', 'Column pending should be double precision');

-- Check foreign keys
SELECT has_fk('plan_rec_result_arc', 'Table plan_rec_result_arc should have foreign keys');
SELECT fk_ok('plan_rec_result_arc', 'result_id', 'plan_result_cat', 'result_id', 'FK result_id should reference plan_result_cat.result_id');

-- Check constraints
SELECT col_not_null('plan_rec_result_arc', 'result_id', 'Column result_id should be NOT NULL');
SELECT col_not_null('plan_rec_result_arc', 'arc_id', 'Column arc_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 