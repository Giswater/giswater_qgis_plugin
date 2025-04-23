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

-- Check table plan_netscenario_arc
SELECT has_table('plan_netscenario_arc'::name, 'Table plan_netscenario_arc should exist');

-- Check columns
SELECT columns_are(
    'plan_netscenario_arc',
    ARRAY[
        'netscenario_id', 'arc_id', 'presszone_id', 'dma_id', 'the_geom'
    ],
    'Table plan_netscenario_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_netscenario_arc', ARRAY['netscenario_id', 'arc_id'], 'Columns netscenario_id and arc_id should be primary key');

-- Check column types
SELECT col_type_is('plan_netscenario_arc', 'netscenario_id', 'integer', 'Column netscenario_id should be integer');
SELECT col_type_is('plan_netscenario_arc', 'arc_id', 'character varying(16)', 'Column arc_id should be character varying(16)');
SELECT col_type_is('plan_netscenario_arc', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('plan_netscenario_arc', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('plan_netscenario_arc', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');

-- Check foreign keys
SELECT has_fk('plan_netscenario_arc', 'Table plan_netscenario_arc should have foreign keys');
SELECT fk_ok('plan_netscenario_arc', ARRAY['netscenario_id', 'dma_id'], 'plan_netscenario_dma', ARRAY['netscenario_id', 'dma_id'], 'FK netscenario_id,dma_id should reference plan_netscenario_dma');
SELECT fk_ok('plan_netscenario_arc', ARRAY['netscenario_id', 'presszone_id'], 'plan_netscenario_presszone', ARRAY['netscenario_id', 'presszone_id'], 'FK netscenario_id,presszone_id should reference plan_netscenario_presszone');

-- Check constraints
SELECT col_not_null('plan_netscenario_arc', 'netscenario_id', 'Column netscenario_id should be NOT NULL');
SELECT col_not_null('plan_netscenario_arc', 'arc_id', 'Column arc_id should be NOT NULL');

-- Check indexes
SELECT has_index('plan_netscenario_arc', 'plan_netscenario_arc_dma_index', 'Table should have index on dma_id');
SELECT has_index('plan_netscenario_arc', 'plan_netscenario_arc_geom_index', 'Table should have index on the_geom');
SELECT has_index('plan_netscenario_arc', 'plan_netscenario_arc_presszone_index', 'Table should have index on presszone_id');

SELECT * FROM finish();

ROLLBACK;