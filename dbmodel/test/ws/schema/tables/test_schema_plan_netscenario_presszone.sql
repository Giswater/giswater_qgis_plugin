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

-- Check table plan_netscenario_presszone
SELECT has_table('plan_netscenario_presszone'::name, 'Table plan_netscenario_presszone should exist');

-- Check columns
SELECT columns_are(
    'plan_netscenario_presszone',
    ARRAY[
        'netscenario_id', 'presszone_id', 'presszone_name', 'head', 'graphconfig', 'the_geom',
        'active', 'updated_at', 'updated_by', 'presszone_type', 'stylesheet', 'expl_id2'
    ],
    'Table plan_netscenario_presszone should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_netscenario_presszone', ARRAY['netscenario_id', 'presszone_id'], 'Columns netscenario_id and presszone_id should be primary key');

-- Check column types
SELECT col_type_is('plan_netscenario_presszone', 'netscenario_id', 'integer', 'Column netscenario_id should be integer');
SELECT col_type_is('plan_netscenario_presszone', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('plan_netscenario_presszone', 'presszone_name', 'character varying(30)', 'Column presszone_name should be character varying(30)');
SELECT col_type_is('plan_netscenario_presszone', 'head', 'numeric(12,2)', 'Column head should be numeric(12,2)');
SELECT col_type_is('plan_netscenario_presszone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('plan_netscenario_presszone', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('plan_netscenario_presszone', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('plan_netscenario_presszone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('plan_netscenario_presszone', 'updated_by', 'character varying(50)', 'Column updated_by should be character varying(50)');
SELECT col_type_is('plan_netscenario_presszone', 'presszone_type', 'text', 'Column presszone_type should be text');
SELECT col_type_is('plan_netscenario_presszone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('plan_netscenario_presszone', 'expl_id2', 'integer', 'Column expl_id2 should be integer');

-- Check default values
SELECT col_default_is('plan_netscenario_presszone', 'active', 'true', 'Default value for active should be true');
SELECT col_has_default('plan_netscenario_presszone', 'updated_at', 'Column updated_at should have a default value');
SELECT col_default_is('plan_netscenario_presszone', 'updated_by', 'CURRENT_USER', 'Default value for updated_by should be CURRENT_USER');

-- Check foreign keys
SELECT has_fk('plan_netscenario_presszone', 'Table plan_netscenario_presszone should have foreign keys');
SELECT fk_ok('plan_netscenario_presszone', 'netscenario_id', 'plan_netscenario', 'netscenario_id', 'FK netscenario_id should reference plan_netscenario.netscenario_id');

-- Check constraints
SELECT col_not_null('plan_netscenario_presszone', 'netscenario_id', 'Column netscenario_id should be NOT NULL');
SELECT col_not_null('plan_netscenario_presszone', 'presszone_id', 'Column presszone_id should be NOT NULL');
SELECT col_has_check('plan_netscenario_presszone', 'presszone_type', 'Column presszone_type should have a check constraint');

SELECT * FROM finish();

ROLLBACK;