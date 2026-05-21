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
SELECT has_table('plan_netscenario_presszone'::name, 'Table plan_netscenario_presszone should exist');

-- Check columns
SELECT columns_are(
    'plan_netscenario_presszone',
    ARRAY[
        'netscenario_id', 'presszone_id', 'name', 'head', 'graphconfig', 'the_geom',
        'active', 'updated_at', 'updated_by', 'presszone_type', 'stylesheet', 'expl_id',
        'muni_id', 'sector_id', 'code', 'descript', 'addparam'
    ],
    'Table plan_netscenario_presszone should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_netscenario_presszone', 'netscenario_id', 'int4', 'Column netscenario_id should be int4');
SELECT col_type_is('plan_netscenario_presszone', 'presszone_id', 'int4', 'Column presszone_id should be int4');
SELECT col_type_is('plan_netscenario_presszone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('plan_netscenario_presszone', 'head', 'numeric(12,2)', 'Column head should be numeric(12,2)');
SELECT col_type_is('plan_netscenario_presszone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('plan_netscenario_presszone', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('plan_netscenario_presszone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('plan_netscenario_presszone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('plan_netscenario_presszone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('plan_netscenario_presszone', 'presszone_type', 'text', 'Column presszone_type should be text');
SELECT col_type_is('plan_netscenario_presszone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('plan_netscenario_presszone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('plan_netscenario_presszone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('plan_netscenario_presszone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('plan_netscenario_presszone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('plan_netscenario_presszone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('plan_netscenario_presszone', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys
SELECT has_fk('plan_netscenario_presszone', 'Table plan_netscenario_presszone should have foreign keys');

SELECT fk_ok('plan_netscenario_presszone', 'netscenario_id', 'plan_netscenario', 'netscenario_id', 'FK netscenario_id → plan_netscenario.netscenario_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
