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

-- Check table om_streetaxis
SELECT has_table('om_streetaxis'::name, 'Table om_streetaxis should exist');

-- Check columns
SELECT columns_are(
    'om_streetaxis',
    ARRAY[
        'id', 'code', 'type', 'name', 'text', 'the_geom', 'expl_id', 'muni_id', 'road_type',
        'surface', 'maxspeed', 'lanes', 'oneway', 'pedestrian', 'access_info'
    ],
    'Table om_streetaxis should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_streetaxis', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_streetaxis', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('om_streetaxis', 'code', 'text', 'Column code should be text');
SELECT col_type_is('om_streetaxis', 'type', 'varchar(18)', 'Column type should be varchar(18)');
SELECT col_type_is('om_streetaxis', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('om_streetaxis', 'text', 'text', 'Column text should be text');
SELECT col_type_is('om_streetaxis', 'the_geom', 'geometry(MultiLineString,25831)', 'Column the_geom should be geometry(MultiLineString,25831)');
SELECT col_type_is('om_streetaxis', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('om_streetaxis', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('om_streetaxis', 'road_type', 'varchar(100)', 'Column road_type should be varchar(100)');
SELECT col_type_is('om_streetaxis', 'surface', 'varchar(100)', 'Column surface should be varchar(100)');
SELECT col_type_is('om_streetaxis', 'maxspeed', 'integer', 'Column maxspeed should be integer');
SELECT col_type_is('om_streetaxis', 'lanes', 'integer', 'Column lanes should be integer');
SELECT col_type_is('om_streetaxis', 'oneway', 'boolean', 'Column oneway should be boolean');
SELECT col_type_is('om_streetaxis', 'pedestrian', 'boolean', 'Column pedestrian should be boolean');
SELECT col_type_is('om_streetaxis', 'access_info', 'varchar(100)', 'Column access_info should be varchar(100)');

-- Check default values
SELECT col_has_default('om_streetaxis', 'id', 'Column id should have a default value');

-- Check unique constraints
SELECT col_is_unique('om_streetaxis', ARRAY['muni_id', 'id'], 'Columns muni_id and id should have a unique constraint');

-- Check foreign keys
SELECT has_fk('om_streetaxis', 'Table om_streetaxis should have foreign keys');
SELECT fk_ok('om_streetaxis', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation.expl_id');
SELECT fk_ok('om_streetaxis', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id should reference ext_municipality.muni_id');

-- Check constraints
SELECT col_not_null('om_streetaxis', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_streetaxis', 'name', 'Column name should be NOT NULL');
SELECT col_not_null('om_streetaxis', 'expl_id', 'Column expl_id should be NOT NULL');
SELECT col_not_null('om_streetaxis', 'muni_id', 'Column muni_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 