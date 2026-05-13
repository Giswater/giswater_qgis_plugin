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

-- Check view v_plan_netscenario_arc
SELECT has_view('v_plan_netscenario_arc'::name, 'View v_plan_netscenario_arc should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_netscenario_arc',
    ARRAY[
        'netscenario_id', 'arc_id', 'presszone_id', 'dma_id', 'the_geom', 'arccat_id',
        'epa_type', 'state', 'state_type'
    ],
    'View v_plan_netscenario_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_netscenario_arc', 'netscenario_id', 'int4', 'Column netscenario_id should be int4');
SELECT col_type_is('v_plan_netscenario_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_plan_netscenario_arc', 'presszone_id', 'int4', 'Column presszone_id should be int4');
SELECT col_type_is('v_plan_netscenario_arc', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('v_plan_netscenario_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('v_plan_netscenario_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_plan_netscenario_arc', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('v_plan_netscenario_arc', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('v_plan_netscenario_arc', 'state_type', 'int2', 'Column state_type should be int2');

SELECT * FROM finish();

ROLLBACK;
