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

-- Check view v_rpt_flowclass_sum
SELECT has_view('v_rpt_flowclass_sum'::name, 'View v_rpt_flowclass_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_flowclass_sum',
    ARRAY[
        'id', 'result_id', 'arc_id', 'arc_type', 'arccat_id', 'length',
        'dry', 'up_dry', 'down_dry', 'sub_crit', 'sub_crit_1', 'up_crit',
        'sector_id', 'the_geom'
    ],
    'View v_rpt_flowclass_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_flowclass_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_flowclass_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_flowclass_sum', 'arc_id', 'varchar(50)', 'Column arc_id should be varchar(50)');
SELECT col_type_is('v_rpt_flowclass_sum', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_rpt_flowclass_sum', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_rpt_flowclass_sum', 'length', 'numeric(12,4)', 'Column length should be numeric(12,4)');
SELECT col_type_is('v_rpt_flowclass_sum', 'dry', 'numeric(12,4)', 'Column dry should be numeric(12,4)');
SELECT col_type_is('v_rpt_flowclass_sum', 'up_dry', 'numeric(12,4)', 'Column up_dry should be numeric(12,4)');
SELECT col_type_is('v_rpt_flowclass_sum', 'down_dry', 'numeric(12,4)', 'Column down_dry should be numeric(12,4)');
SELECT col_type_is('v_rpt_flowclass_sum', 'sub_crit', 'numeric(12,4)', 'Column sub_crit should be numeric(12,4)');
SELECT col_type_is('v_rpt_flowclass_sum', 'sub_crit_1', 'numeric(12,4)', 'Column sub_crit_1 should be numeric(12,4)');
SELECT col_type_is('v_rpt_flowclass_sum', 'up_crit', 'numeric(12,4)', 'Column up_crit should be numeric(12,4)');
SELECT col_type_is('v_rpt_flowclass_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_flowclass_sum', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
