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

-- Check view v_rpt_nodedepth_sum
SELECT has_view('v_rpt_nodedepth_sum'::name, 'View v_rpt_nodedepth_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_nodedepth_sum',
    ARRAY[
        'id', 'result_id', 'node_id', 'node_type', 'nodecat_id', 'swnod_type',
        'aver_depth', 'max_depth', 'max_hgl', 'time_days', 'time_hour', 'sector_id',
        'the_geom'
    ],
    'View v_rpt_nodedepth_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_nodedepth_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_nodedepth_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_nodedepth_sum', 'node_id', 'varchar(50)', 'Column node_id should be varchar(50)');
SELECT col_type_is('v_rpt_nodedepth_sum', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('v_rpt_nodedepth_sum', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_rpt_nodedepth_sum', 'swnod_type', 'varchar(18)', 'Column swnod_type should be varchar(18)');
SELECT col_type_is('v_rpt_nodedepth_sum', 'aver_depth', 'numeric(12,4)', 'Column aver_depth should be numeric(12,4)');
SELECT col_type_is('v_rpt_nodedepth_sum', 'max_depth', 'numeric(12,4)', 'Column max_depth should be numeric(12,4)');
SELECT col_type_is('v_rpt_nodedepth_sum', 'max_hgl', 'numeric(12,4)', 'Column max_hgl should be numeric(12,4)');
SELECT col_type_is('v_rpt_nodedepth_sum', 'time_days', 'varchar(10)', 'Column time_days should be varchar(10)');
SELECT col_type_is('v_rpt_nodedepth_sum', 'time_hour', 'varchar(10)', 'Column time_hour should be varchar(10)');
SELECT col_type_is('v_rpt_nodedepth_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_nodedepth_sum', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
