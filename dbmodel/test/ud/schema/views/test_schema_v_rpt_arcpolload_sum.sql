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

-- Check view v_rpt_arcpolload_sum
SELECT has_view('v_rpt_arcpolload_sum'::name, 'View v_rpt_arcpolload_sum should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_arcpolload_sum',
    ARRAY[
        'id', 'arc_id', 'result_id', 'arc_type', 'arccat_id', 'sector_id',
        'the_geom', 'poll_id'
    ],
    'View v_rpt_arcpolload_sum should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_arcpolload_sum', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_arcpolload_sum', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('v_rpt_arcpolload_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_arcpolload_sum', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_rpt_arcpolload_sum', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_rpt_arcpolload_sum', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_arcpolload_sum', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('v_rpt_arcpolload_sum', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');

SELECT * FROM finish();

ROLLBACK;
