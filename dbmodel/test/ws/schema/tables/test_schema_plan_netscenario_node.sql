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

-- Check table
SELECT has_table('plan_netscenario_node'::name, 'Table plan_netscenario_node should exist');

-- Check columns
SELECT columns_are(
    'plan_netscenario_node',
    ARRAY[
        'netscenario_id', 'node_id', 'presszone_id', 'staticpressure', 'dma_id', 'pattern_id',
        'the_geom'
    ],
    'Table plan_netscenario_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_netscenario_node', 'netscenario_id', 'int4', 'Column netscenario_id should be int4');
SELECT col_type_is('plan_netscenario_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('plan_netscenario_node', 'presszone_id', 'int4', 'Column presszone_id should be int4');
SELECT col_type_is('plan_netscenario_node', 'staticpressure', 'numeric(12,3)', 'Column staticpressure should be numeric(12,3)');
SELECT col_type_is('plan_netscenario_node', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('plan_netscenario_node', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('plan_netscenario_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

-- Check foreign keys
SELECT has_fk('plan_netscenario_node', 'Table plan_netscenario_node should have foreign keys');

SELECT fk_ok('plan_netscenario_node', ARRAY['netscenario_id', 'dma_id'], 'plan_netscenario_dma', ARRAY['netscenario_id', 'dma_id'], 'FK (netscenario_id, dma_id) → plan_netscenario_dma(netscenario_id, dma_id)');
SELECT fk_ok('plan_netscenario_node', ARRAY['netscenario_id', 'presszone_id'], 'plan_netscenario_presszone', ARRAY['netscenario_id', 'presszone_id'], 'FK (netscenario_id, presszone_id) → plan_netscenario_presszone(netscenario_id, presszone_id)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
