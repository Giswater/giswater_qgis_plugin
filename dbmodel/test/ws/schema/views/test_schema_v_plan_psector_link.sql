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

-- Check view v_plan_psector_link
SELECT has_view('v_plan_psector_link'::name, 'View v_plan_psector_link should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_psector_link',
    ARRAY[
        'rid', 'link_id', 'psector_id', 'connec_id', 'original_state', 'original_state_type',
        'plan_state', 'doable', 'psector_priority', 'the_geom'
    ],
    'View v_plan_psector_link should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_psector_link', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('v_plan_psector_link', 'link_id', 'int4', 'Column link_id should be int4');
SELECT col_type_is('v_plan_psector_link', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('v_plan_psector_link', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('v_plan_psector_link', 'original_state', 'int2', 'Column original_state should be int2');
SELECT col_type_is('v_plan_psector_link', 'original_state_type', 'int2', 'Column original_state_type should be int2');
SELECT col_type_is('v_plan_psector_link', 'plan_state', 'int2', 'Column plan_state should be int2');
SELECT col_type_is('v_plan_psector_link', 'doable', 'bool', 'Column doable should be bool');
SELECT col_type_is('v_plan_psector_link', 'psector_priority', 'varchar(16)', 'Column psector_priority should be varchar(16)');
SELECT col_type_is('v_plan_psector_link', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
