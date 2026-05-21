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

-- Check view v_plan_psector_arc
SELECT has_view('v_plan_psector_arc'::name, 'View v_plan_psector_arc should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_psector_arc',
    ARRAY[
        'rid', 'arc_id', 'psector_id', 'code', 'arccat_id', 'arc_type',
        'feature_class', 'original_state', 'original_state_type', 'plan_state', 'doable', 'addparam',
        'psector_priority', 'the_geom'
    ],
    'View v_plan_psector_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_psector_arc', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('v_plan_psector_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_plan_psector_arc', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('v_plan_psector_arc', 'code', 'text', 'Column code should be text');
SELECT col_type_is('v_plan_psector_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_plan_psector_arc', 'arc_type', 'text', 'Column arc_type should be text');
SELECT col_type_is('v_plan_psector_arc', 'feature_class', 'varchar(30)', 'Column feature_class should be varchar(30)');
SELECT col_type_is('v_plan_psector_arc', 'original_state', 'int2', 'Column original_state should be int2');
SELECT col_type_is('v_plan_psector_arc', 'original_state_type', 'int2', 'Column original_state_type should be int2');
SELECT col_type_is('v_plan_psector_arc', 'plan_state', 'int2', 'Column plan_state should be int2');
SELECT col_type_is('v_plan_psector_arc', 'doable', 'bool', 'Column doable should be bool');
SELECT col_type_is('v_plan_psector_arc', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('v_plan_psector_arc', 'psector_priority', 'varchar(16)', 'Column psector_priority should be varchar(16)');
SELECT col_type_is('v_plan_psector_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
