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

-- Check view v_plan_netscenario_connec
SELECT has_view('v_plan_netscenario_connec'::name, 'View v_plan_netscenario_connec should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_netscenario_connec',
    ARRAY[
        'netscenario_id', 'connec_id', 'presszone_id', 'staticpressure', 'dma_id', 'pattern_id',
        'the_geom', 'conneccat_id', 'connec_type', 'epa_type', 'state', 'state_type'
    ],
    'View v_plan_netscenario_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_netscenario_connec', 'netscenario_id', 'int4', 'Column netscenario_id should be int4');
SELECT col_type_is('v_plan_netscenario_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('v_plan_netscenario_connec', 'presszone_id', 'int4', 'Column presszone_id should be int4');
SELECT col_type_is('v_plan_netscenario_connec', 'staticpressure', 'numeric(12,3)', 'Column staticpressure should be numeric(12,3)');
SELECT col_type_is('v_plan_netscenario_connec', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('v_plan_netscenario_connec', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('v_plan_netscenario_connec', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('v_plan_netscenario_connec', 'conneccat_id', 'varchar(30)', 'Column conneccat_id should be varchar(30)');
SELECT col_type_is('v_plan_netscenario_connec', 'connec_type', 'varchar(18)', 'Column connec_type should be varchar(18)');
SELECT col_type_is('v_plan_netscenario_connec', 'epa_type', 'text', 'Column epa_type should be text');
SELECT col_type_is('v_plan_netscenario_connec', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('v_plan_netscenario_connec', 'state_type', 'int2', 'Column state_type should be int2');

SELECT * FROM finish();

ROLLBACK;
