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

-- Check view v_rpt_nodeflooding_sum
SELECT has_view('v_rpt_nodeflooding_sum'::name, 'View v_rpt_nodeflooding_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_nodeflooding_sum',
    ARRAY[
        'id', 'node_id', 'result_id', 'node_type', 'nodecat_id', 'hour_flood',
        'max_rate', 'time_days', 'time_hour', 'tot_flood', 'max_ponded', 'sector_id',
        'the_geom'
    ],
    'View v_rpt_nodeflooding_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_nodeflooding_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'node_id', 'varchar(50)', 'Column node_id should be varchar(50)');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'hour_flood', 'numeric(12,4)', 'Column hour_flood should be numeric(12,4)');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'max_rate', 'numeric(12,4)', 'Column max_rate should be numeric(12,4)');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'time_days', 'varchar(10)', 'Column time_days should be varchar(10)');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'time_hour', 'varchar(10)', 'Column time_hour should be varchar(10)');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'tot_flood', 'numeric(12,4)', 'Column tot_flood should be numeric(12,4)');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'max_ponded', 'numeric(12,4)', 'Column max_ponded should be numeric(12,4)');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_nodeflooding_sum', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
