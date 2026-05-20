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
SELECT has_table('plan_reh_result_node'::name, 'Table plan_reh_result_node should exist');

-- Check columns
SELECT columns_are(
    'plan_reh_result_node',
    ARRAY[
        'result_id', 'node_id', 'node_type', 'nodecat_id', 'sector_id', 'state',
        'expl_id', 'parameter_id', 'work_id', 'pcompost_id', 'cost', 'ymax',
        'measurement', 'budget', 'the_geom'
    ],
    'Table plan_reh_result_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_reh_result_node', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('plan_reh_result_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('plan_reh_result_node', 'node_type', 'varchar(18)', 'Column node_type should be varchar(18)');
SELECT col_type_is('plan_reh_result_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('plan_reh_result_node', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('plan_reh_result_node', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('plan_reh_result_node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('plan_reh_result_node', 'parameter_id', 'varchar(30)', 'Column parameter_id should be varchar(30)');
SELECT col_type_is('plan_reh_result_node', 'work_id', 'varchar(30)', 'Column work_id should be varchar(30)');
SELECT col_type_is('plan_reh_result_node', 'pcompost_id', 'varchar(16)', 'Column pcompost_id should be varchar(16)');
SELECT col_type_is('plan_reh_result_node', 'cost', 'float8', 'Column cost should be float8');
SELECT col_type_is('plan_reh_result_node', 'ymax', 'float8', 'Column ymax should be float8');
SELECT col_type_is('plan_reh_result_node', 'measurement', 'float8', 'Column measurement should be float8');
SELECT col_type_is('plan_reh_result_node', 'budget', 'float8', 'Column budget should be float8');
SELECT col_type_is('plan_reh_result_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

-- Check foreign keys
SELECT has_fk('plan_reh_result_node', 'Table plan_reh_result_node should have foreign keys');

SELECT fk_ok('plan_reh_result_node', 'result_id', 'plan_result_cat', 'result_id', 'FK result_id → plan_result_cat.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
