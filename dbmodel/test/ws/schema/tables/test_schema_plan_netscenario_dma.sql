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

-- Check table plan_netscenario_dma
SELECT has_table('plan_netscenario_dma'::name, 'Table plan_netscenario_dma should exist');

-- Check columns
SELECT columns_are(
    'plan_netscenario_dma',
    ARRAY[
        'netscenario_id', 'dma_id', 'dma_name', 'pattern_id', 'graphconfig', 'the_geom',
        'active', 'updated_at', 'updated_by', 'stylesheet', 'expl_id2'
    ],
    'Table plan_netscenario_dma should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_netscenario_dma', ARRAY['netscenario_id', 'dma_id'], 'Columns netscenario_id and dma_id should be primary key');

-- Check column types
SELECT col_type_is('plan_netscenario_dma', 'netscenario_id', 'integer', 'Column netscenario_id should be integer');
SELECT col_type_is('plan_netscenario_dma', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('plan_netscenario_dma', 'dma_name', 'character varying(30)', 'Column dma_name should be character varying(30)');
SELECT col_type_is('plan_netscenario_dma', 'pattern_id', 'character varying(16)', 'Column pattern_id should be character varying(16)');
SELECT col_type_is('plan_netscenario_dma', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('plan_netscenario_dma', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('plan_netscenario_dma', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('plan_netscenario_dma', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('plan_netscenario_dma', 'updated_by', 'character varying(50)', 'Column updated_by should be character varying(50)');
SELECT col_type_is('plan_netscenario_dma', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('plan_netscenario_dma', 'expl_id2', 'integer', 'Column expl_id2 should be integer');

-- Check default values
SELECT col_default_is('plan_netscenario_dma', 'active', 'true', 'Default value for active should be true');
SELECT col_has_default('plan_netscenario_dma', 'updated_at', 'Column updated_at should have a default value');
SELECT col_default_is('plan_netscenario_dma', 'updated_by', 'CURRENT_USER', 'Default value for updated_by should be CURRENT_USER');

-- Check foreign keys
SELECT has_fk('plan_netscenario_dma', 'Table plan_netscenario_dma should have foreign keys');
SELECT fk_ok('plan_netscenario_dma', 'netscenario_id', 'plan_netscenario', 'netscenario_id', 'FK netscenario_id should reference plan_netscenario.netscenario_id');

-- Check constraints
SELECT col_not_null('plan_netscenario_dma', 'netscenario_id', 'Column netscenario_id should be NOT NULL');
SELECT col_not_null('plan_netscenario_dma', 'dma_id', 'Column dma_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;