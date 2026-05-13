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

-- Check table
SELECT has_table('plan_rec_result_node'::name, 'Table plan_rec_result_node should exist');

-- Check columns
SELECT columns_are(
    'plan_rec_result_node',
    ARRAY[
        'result_id', 'node_id', 'node_type', 'nodecat_id', 'top_elev', 'elev',
        'epa_type', 'sector_id', 'state', 'annotation', 'the_geom', 'cost_unit',
        'descript', 'measurement', 'cost', 'budget', 'expl_id', 'builtcost',
        'builtdate', 'age', 'acoeff', 'aperiod', 'arate', 'amortized',
        'pending'
    ],
    'Table plan_rec_result_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_rec_result_node', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('plan_rec_result_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('plan_rec_result_node', 'node_type', 'varchar(18)', 'Column node_type should be varchar(18)');
SELECT col_type_is('plan_rec_result_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('plan_rec_result_node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('plan_rec_result_node', 'elev', 'numeric(12,3)', 'Column elev should be numeric(12,3)');
SELECT col_type_is('plan_rec_result_node', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('plan_rec_result_node', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('plan_rec_result_node', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('plan_rec_result_node', 'annotation', 'varchar(254)', 'Column annotation should be varchar(254)');
SELECT col_type_is('plan_rec_result_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('plan_rec_result_node', 'cost_unit', 'varchar(3)', 'Column cost_unit should be varchar(3)');
SELECT col_type_is('plan_rec_result_node', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('plan_rec_result_node', 'measurement', 'numeric(12,2)', 'Column measurement should be numeric(12,2)');
SELECT col_type_is('plan_rec_result_node', 'cost', 'numeric(12,3)', 'Column cost should be numeric(12,3)');
SELECT col_type_is('plan_rec_result_node', 'budget', 'numeric(12,2)', 'Column budget should be numeric(12,2)');
SELECT col_type_is('plan_rec_result_node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('plan_rec_result_node', 'builtcost', 'float8', 'Column builtcost should be float8');
SELECT col_type_is('plan_rec_result_node', 'builtdate', 'timestamp without time zone', 'Column builtdate should be timestamp without time zone');
SELECT col_type_is('plan_rec_result_node', 'age', 'float8', 'Column age should be float8');
SELECT col_type_is('plan_rec_result_node', 'acoeff', 'float8', 'Column acoeff should be float8');
SELECT col_type_is('plan_rec_result_node', 'aperiod', 'text', 'Column aperiod should be text');
SELECT col_type_is('plan_rec_result_node', 'arate', 'float8', 'Column arate should be float8');
SELECT col_type_is('plan_rec_result_node', 'amortized', 'float8', 'Column amortized should be float8');
SELECT col_type_is('plan_rec_result_node', 'pending', 'float8', 'Column pending should be float8');

-- Check foreign keys
SELECT has_fk('plan_rec_result_node', 'Table plan_rec_result_node should have foreign keys');

SELECT fk_ok('plan_rec_result_node', 'result_id', 'plan_result_cat', 'result_id', 'FK result_id → plan_result_cat.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
