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
SELECT has_table('plan_reh_result_arc'::name, 'Table plan_reh_result_arc should exist');

-- Check columns
SELECT columns_are(
    'plan_reh_result_arc',
    ARRAY[
        'result_id', 'arc_id', 'node_1', 'node_2', 'arc_type', 'arccat_id',
        'sector_id', 'state', 'expl_id', 'parameter_id', 'work_id', 'init_condition',
        'end_condition', 'loc_condition', 'pcompost_id', 'cost', 'ymax', 'length',
        'measurement', 'budget', 'the_geom'
    ],
    'Table plan_reh_result_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_reh_result_arc', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('plan_reh_result_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('plan_reh_result_arc', 'node_1', 'int4', 'Column node_1 should be int4');
SELECT col_type_is('plan_reh_result_arc', 'node_2', 'int4', 'Column node_2 should be int4');
SELECT col_type_is('plan_reh_result_arc', 'arc_type', 'varchar(18)', 'Column arc_type should be varchar(18)');
SELECT col_type_is('plan_reh_result_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('plan_reh_result_arc', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('plan_reh_result_arc', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('plan_reh_result_arc', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('plan_reh_result_arc', 'parameter_id', 'varchar(30)', 'Column parameter_id should be varchar(30)');
SELECT col_type_is('plan_reh_result_arc', 'work_id', 'varchar(30)', 'Column work_id should be varchar(30)');
SELECT col_type_is('plan_reh_result_arc', 'init_condition', 'float8', 'Column init_condition should be float8');
SELECT col_type_is('plan_reh_result_arc', 'end_condition', 'float8', 'Column end_condition should be float8');
SELECT col_type_is('plan_reh_result_arc', 'loc_condition', 'text', 'Column loc_condition should be text');
SELECT col_type_is('plan_reh_result_arc', 'pcompost_id', 'varchar(16)', 'Column pcompost_id should be varchar(16)');
SELECT col_type_is('plan_reh_result_arc', 'cost', 'float8', 'Column cost should be float8');
SELECT col_type_is('plan_reh_result_arc', 'ymax', 'float8', 'Column ymax should be float8');
SELECT col_type_is('plan_reh_result_arc', 'length', 'float8', 'Column length should be float8');
SELECT col_type_is('plan_reh_result_arc', 'measurement', 'float8', 'Column measurement should be float8');
SELECT col_type_is('plan_reh_result_arc', 'budget', 'float8', 'Column budget should be float8');
SELECT col_type_is('plan_reh_result_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

-- Check foreign keys
SELECT has_fk('plan_reh_result_arc', 'Table plan_reh_result_arc should have foreign keys');

SELECT fk_ok('plan_reh_result_arc', 'result_id', 'plan_result_cat', 'result_id', 'FK result_id → plan_result_cat.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
