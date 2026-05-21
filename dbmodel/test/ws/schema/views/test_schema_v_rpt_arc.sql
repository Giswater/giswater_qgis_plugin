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

-- Check view v_rpt_arc
SELECT has_view('v_rpt_arc'::name, 'View v_rpt_arc should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_arc',
    ARRAY[
        'id', 'arc_id', 'result_id', 'flow_units', 'quality_units', 'arc_type',
        'sector_id', 'arccat_id', 'flow', 'vel', 'headloss', 'setting',
        'ffactor', 'time', 'length', 'tot_headloss', 'diameter', 'the_geom'
    ],
    'View v_rpt_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_arc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_arc', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('v_rpt_arc', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_arc', 'flow_units', 'text', 'Column flow_units should be text');
SELECT col_type_is('v_rpt_arc', 'quality_units', 'text', 'Column quality_units should be text');
SELECT col_type_is('v_rpt_arc', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('v_rpt_arc', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_rpt_arc', 'flow', 'numeric', 'Column flow should be numeric');
SELECT col_type_is('v_rpt_arc', 'vel', 'numeric', 'Column vel should be numeric');
SELECT col_type_is('v_rpt_arc', 'headloss', 'numeric', 'Column headloss should be numeric');
SELECT col_type_is('v_rpt_arc', 'setting', 'numeric', 'Column setting should be numeric');
SELECT col_type_is('v_rpt_arc', 'ffactor', 'numeric', 'Column ffactor should be numeric');
SELECT col_type_is('v_rpt_arc', 'time', 'timestamp without time zone', 'Column time should be timestamp without time zone');
SELECT col_type_is('v_rpt_arc', 'length', 'numeric', 'Column length should be numeric');
SELECT col_type_is('v_rpt_arc', 'tot_headloss', 'numeric', 'Column tot_headloss should be numeric');
SELECT col_type_is('v_rpt_arc', 'diameter', 'numeric(12,3)', 'Column diameter should be numeric(12,3)');
SELECT col_type_is('v_rpt_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
