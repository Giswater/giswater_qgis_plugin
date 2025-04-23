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

-- Check table plan_reh_result_arc
SELECT has_table('plan_reh_result_arc'::name, 'Table plan_reh_result_arc should exist');

-- Check columns
SELECT columns_are(
    'plan_reh_result_arc',
    ARRAY[
        'result_id', 'arc_id', 'node_1', 'node_2', 'arc_type', 'arccat_id', 'sector_id', 'state', 'expl_id',
        'parameter_id', 'work_id', 'init_condition', 'end_condition', 'loc_condition', 'pcompost_id',
        'cost', 'ymax', 'length', 'measurement', 'budget', 'the_geom'
    ],
    'Table plan_reh_result_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_reh_result_arc', ARRAY['arc_id', 'result_id'], 'Columns arc_id and result_id should be primary key');

-- Check column types
SELECT col_type_is('plan_reh_result_arc', 'result_id', 'integer', 'Column result_id should be integer');
SELECT col_type_is('plan_reh_result_arc', 'arc_id', 'character varying(16)', 'Column arc_id should be character varying(16)');
SELECT col_type_is('plan_reh_result_arc', 'node_1', 'character varying(16)', 'Column node_1 should be character varying(16)');
SELECT col_type_is('plan_reh_result_arc', 'node_2', 'character varying(16)', 'Column node_2 should be character varying(16)');
SELECT col_type_is('plan_reh_result_arc', 'arc_type', 'character varying(18)', 'Column arc_type should be character varying(18)');
SELECT col_type_is('plan_reh_result_arc', 'arccat_id', 'character varying(30)', 'Column arccat_id should be character varying(30)');
SELECT col_type_is('plan_reh_result_arc', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('plan_reh_result_arc', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('plan_reh_result_arc', 'cost', 'double precision', 'Column cost should be double precision');
SELECT col_type_is('plan_reh_result_arc', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');

-- Check foreign keys
SELECT has_fk('plan_reh_result_arc', 'Table plan_reh_result_arc should have foreign keys');
SELECT fk_ok('plan_reh_result_arc', 'result_id', 'plan_result_cat', 'result_id', 'FK result_id should reference plan_result_cat.result_id');

-- Check constraints
SELECT col_not_null('plan_reh_result_arc', 'result_id', 'Column result_id should be NOT NULL');
SELECT col_not_null('plan_reh_result_arc', 'arc_id', 'Column arc_id should be NOT NULL');
SELECT col_not_null('plan_reh_result_arc', 'arc_type', 'Column arc_type should be NOT NULL');
SELECT col_not_null('plan_reh_result_arc', 'arccat_id', 'Column arccat_id should be NOT NULL');
SELECT col_not_null('plan_reh_result_arc', 'sector_id', 'Column sector_id should be NOT NULL');
SELECT col_not_null('plan_reh_result_arc', 'state', 'Column state should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 