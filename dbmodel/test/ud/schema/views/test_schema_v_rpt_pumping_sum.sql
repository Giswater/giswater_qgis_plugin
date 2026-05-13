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

-- Check view v_rpt_pumping_sum
SELECT has_view('v_rpt_pumping_sum'::name, 'View v_rpt_pumping_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_pumping_sum',
    ARRAY[
        'id', 'result_id', 'arc_id', 'arc_type', 'arccat_id', 'percent',
        'num_startup', 'min_flow', 'avg_flow', 'max_flow', 'vol_ltr', 'powus_kwh',
        'timoff_min', 'timoff_max', 'sector_id', 'the_geom'
    ],
    'View v_rpt_pumping_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_pumping_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_pumping_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_pumping_sum', 'arc_id', 'varchar(50)', 'Column arc_id should be varchar(50)');
SELECT col_type_is('v_rpt_pumping_sum', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_rpt_pumping_sum', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_rpt_pumping_sum', 'percent', 'numeric(12,4)', 'Column percent should be numeric(12,4)');
SELECT col_type_is('v_rpt_pumping_sum', 'num_startup', 'int4', 'Column num_startup should be int4');
SELECT col_type_is('v_rpt_pumping_sum', 'min_flow', 'numeric(12,4)', 'Column min_flow should be numeric(12,4)');
SELECT col_type_is('v_rpt_pumping_sum', 'avg_flow', 'numeric(12,4)', 'Column avg_flow should be numeric(12,4)');
SELECT col_type_is('v_rpt_pumping_sum', 'max_flow', 'numeric(12,4)', 'Column max_flow should be numeric(12,4)');
SELECT col_type_is('v_rpt_pumping_sum', 'vol_ltr', 'numeric(12,4)', 'Column vol_ltr should be numeric(12,4)');
SELECT col_type_is('v_rpt_pumping_sum', 'powus_kwh', 'numeric(12,4)', 'Column powus_kwh should be numeric(12,4)');
SELECT col_type_is('v_rpt_pumping_sum', 'timoff_min', 'numeric(12,4)', 'Column timoff_min should be numeric(12,4)');
SELECT col_type_is('v_rpt_pumping_sum', 'timoff_max', 'numeric(12,4)', 'Column timoff_max should be numeric(12,4)');
SELECT col_type_is('v_rpt_pumping_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_pumping_sum', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
