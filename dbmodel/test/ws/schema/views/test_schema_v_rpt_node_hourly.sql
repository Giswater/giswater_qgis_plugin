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

-- Check view v_rpt_node_hourly
SELECT has_view('v_rpt_node_hourly'::name, 'View v_rpt_node_hourly should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_node_hourly',
    ARRAY[
        'id', 'node_id', 'sector_id', 'result_id', 'flow_units', 'elevation',
        'demand', 'head', 'press', 'quality_units', 'quality', 'time',
        'the_geom'
    ],
    'View v_rpt_node_hourly should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_node_hourly', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_node_hourly', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('v_rpt_node_hourly', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_node_hourly', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_node_hourly', 'flow_units', 'text', 'Column flow_units should be text');
SELECT col_type_is('v_rpt_node_hourly', 'elevation', 'numeric', 'Column elevation should be numeric');
SELECT col_type_is('v_rpt_node_hourly', 'demand', 'numeric', 'Column demand should be numeric');
SELECT col_type_is('v_rpt_node_hourly', 'head', 'numeric', 'Column head should be numeric');
SELECT col_type_is('v_rpt_node_hourly', 'press', 'numeric', 'Column press should be numeric');
SELECT col_type_is('v_rpt_node_hourly', 'quality_units', 'text', 'Column quality_units should be text');
SELECT col_type_is('v_rpt_node_hourly', 'quality', 'numeric(12,4)', 'Column quality should be numeric(12,4)');
SELECT col_type_is('v_rpt_node_hourly', 'time', 'varchar(100)', 'Column time should be varchar(100)');
SELECT col_type_is('v_rpt_node_hourly', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
