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

-- Check table plan_reh_result_node
SELECT has_table('plan_reh_result_node'::name, 'Table plan_reh_result_node should exist');

-- Check columns
SELECT columns_are(
    'plan_reh_result_node',
    ARRAY[
        'result_id', 'node_id', 'node_type', 'nodecat_id', 'sector_id', 'state', 'expl_id',
        'parameter_id', 'work_id', 'pcompost_id', 'cost', 'ymax', 'measurement', 'budget', 'the_geom'
    ],
    'Table plan_reh_result_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_reh_result_node', ARRAY['node_id', 'result_id'], 'Columns node_id and result_id should be primary key');

-- Check column types
SELECT col_type_is('plan_reh_result_node', 'result_id', 'integer', 'Column result_id should be integer');
SELECT col_type_is('plan_reh_result_node', 'node_id', 'character varying(16)', 'Column node_id should be character varying(16)');
SELECT col_type_is('plan_reh_result_node', 'node_type', 'character varying(18)', 'Column node_type should be character varying(18)');
SELECT col_type_is('plan_reh_result_node', 'nodecat_id', 'character varying(30)', 'Column nodecat_id should be character varying(30)');
SELECT col_type_is('plan_reh_result_node', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('plan_reh_result_node', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('plan_reh_result_node', 'cost', 'double precision', 'Column cost should be double precision');
SELECT col_type_is('plan_reh_result_node', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');

-- Check foreign keys
SELECT has_fk('plan_reh_result_node', 'Table plan_reh_result_node should have foreign keys');
SELECT fk_ok('plan_reh_result_node', 'result_id', 'plan_result_cat', 'result_id', 'FK result_id should reference plan_result_cat.result_id');

-- Check constraints
SELECT col_not_null('plan_reh_result_node', 'result_id', 'Column result_id should be NOT NULL');
SELECT col_not_null('plan_reh_result_node', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_not_null('plan_reh_result_node', 'node_type', 'Column node_type should be NOT NULL');
SELECT col_not_null('plan_reh_result_node', 'nodecat_id', 'Column nodecat_id should be NOT NULL');
SELECT col_not_null('plan_reh_result_node', 'sector_id', 'Column sector_id should be NOT NULL');
SELECT col_not_null('plan_reh_result_node', 'state', 'Column state should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 