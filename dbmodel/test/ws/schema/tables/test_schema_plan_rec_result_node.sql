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

-- Check table plan_rec_result_node
SELECT has_table('plan_rec_result_node'::name, 'Table plan_rec_result_node should exist');

-- Check columns
SELECT columns_are(
    'plan_rec_result_node',
    ARRAY[
        'result_id', 'node_id', 'node_type', 'nodecat_id', 'top_elev', 'elev', 'epa_type', 'sector_id',
        'state', 'annotation', 'the_geom', 'cost_unit', 'descript', 'measurement', 'cost', 'budget',
        'expl_id', 'builtcost', 'builtdate', 'age', 'acoeff', 'aperiod', 'arate', 'amortized', 'pending'
    ],
    'Table plan_rec_result_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_rec_result_node', ARRAY['node_id', 'result_id'], 'Columns node_id and result_id should be primary key');

-- Check column types (a representative sample)
SELECT col_type_is('plan_rec_result_node', 'result_id', 'integer', 'Column result_id should be integer');
SELECT col_type_is('plan_rec_result_node', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('plan_rec_result_node', 'node_type', 'character varying(18)', 'Column node_type should be character varying(18)');
SELECT col_type_is('plan_rec_result_node', 'nodecat_id', 'character varying(30)', 'Column nodecat_id should be character varying(30)');
SELECT col_type_is('plan_rec_result_node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('plan_rec_result_node', 'elev', 'numeric(12,3)', 'Column elev should be numeric(12,3)');
SELECT col_type_is('plan_rec_result_node', 'cost', 'numeric(12,3)', 'Column cost should be numeric(12,3)');
SELECT col_type_is('plan_rec_result_node', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('plan_rec_result_node', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('plan_rec_result_node', 'builtcost', 'double precision', 'Column builtcost should be double precision');
SELECT col_type_is('plan_rec_result_node', 'aperiod', 'text', 'Column aperiod should be text');
SELECT col_type_is('plan_rec_result_node', 'pending', 'double precision', 'Column pending should be double precision');

-- Check foreign keys
SELECT has_fk('plan_rec_result_node', 'Table plan_rec_result_node should have foreign keys');
SELECT fk_ok('plan_rec_result_node', 'result_id', 'plan_result_cat', 'result_id', 'FK result_id should reference plan_result_cat.result_id');

-- Check constraints
SELECT col_not_null('plan_rec_result_node', 'result_id', 'Column result_id should be NOT NULL');
SELECT col_not_null('plan_rec_result_node', 'node_id', 'Column node_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;