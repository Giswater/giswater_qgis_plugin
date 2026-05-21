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

-- Check view ve_plan_netscenario_dma
SELECT has_view('ve_plan_netscenario_dma'::name, 'View ve_plan_netscenario_dma should exist');

-- Check view columns
SELECT columns_are(
    've_plan_netscenario_dma',
    ARRAY[
        'netscenario_id', 'netscenario_name', 'dma_id', 'name', 'code', 'descript',
        'pattern_id', 'graphconfig', 'the_geom', 'active', 'stylesheet', 'expl_id',
        'muni_id', 'sector_id', 'addparam'
    ],
    'View ve_plan_netscenario_dma should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_plan_netscenario_dma', 'netscenario_id', 'int4', 'Column netscenario_id should be int4');
SELECT col_type_is('ve_plan_netscenario_dma', 'netscenario_name', 'varchar(30)', 'Column netscenario_name should be varchar(30)');
SELECT col_type_is('ve_plan_netscenario_dma', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('ve_plan_netscenario_dma', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('ve_plan_netscenario_dma', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ve_plan_netscenario_dma', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('ve_plan_netscenario_dma', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('ve_plan_netscenario_dma', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('ve_plan_netscenario_dma', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('ve_plan_netscenario_dma', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ve_plan_netscenario_dma', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('ve_plan_netscenario_dma', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('ve_plan_netscenario_dma', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('ve_plan_netscenario_dma', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('ve_plan_netscenario_dma', 'addparam', 'json', 'Column addparam should be json');

SELECT * FROM finish();

ROLLBACK;
