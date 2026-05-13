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

-- Check view ve_plan_netscenario_presszone
SELECT has_view('ve_plan_netscenario_presszone'::name, 'View ve_plan_netscenario_presszone should exist');

-- Check view columns
SELECT columns_are(
    've_plan_netscenario_presszone',
    ARRAY[
        'netscenario_id', 'netscenario_name', 'presszone_id', 'name', 'code', 'descript',
        'head', 'graphconfig', 'the_geom', 'active', 'presszone_type', 'stylesheet',
        'expl_id', 'muni_id', 'sector_id', 'addparam'
    ],
    'View ve_plan_netscenario_presszone should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_plan_netscenario_presszone', 'netscenario_id', 'int4', 'Column netscenario_id should be int4');
SELECT col_type_is('ve_plan_netscenario_presszone', 'netscenario_name', 'varchar(30)', 'Column netscenario_name should be varchar(30)');
SELECT col_type_is('ve_plan_netscenario_presszone', 'presszone_id', 'int4', 'Column presszone_id should be int4');
SELECT col_type_is('ve_plan_netscenario_presszone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('ve_plan_netscenario_presszone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ve_plan_netscenario_presszone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('ve_plan_netscenario_presszone', 'head', 'numeric(12,2)', 'Column head should be numeric(12,2)');
SELECT col_type_is('ve_plan_netscenario_presszone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('ve_plan_netscenario_presszone', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('ve_plan_netscenario_presszone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ve_plan_netscenario_presszone', 'presszone_type', 'text', 'Column presszone_type should be text');
SELECT col_type_is('ve_plan_netscenario_presszone', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('ve_plan_netscenario_presszone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('ve_plan_netscenario_presszone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('ve_plan_netscenario_presszone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('ve_plan_netscenario_presszone', 'addparam', 'json', 'Column addparam should be json');

SELECT * FROM finish();

ROLLBACK;
