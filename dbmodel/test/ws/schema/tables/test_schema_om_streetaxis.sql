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
SELECT has_table('om_streetaxis'::name, 'Table om_streetaxis should exist');

-- Check columns
SELECT columns_are(
    'om_streetaxis',
    ARRAY[
        'id', 'code', 'type', 'name', 'text', 'the_geom',
        'expl_id', 'muni_id', 'road_type', 'surface', 'maxspeed', 'lanes',
        'oneway', 'pedestrian', 'access_info'
    ],
    'Table om_streetaxis should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_streetaxis', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('om_streetaxis', 'code', 'text', 'Column code should be text');
SELECT col_type_is('om_streetaxis', 'type', 'varchar(18)', 'Column type should be varchar(18)');
SELECT col_type_is('om_streetaxis', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('om_streetaxis', 'text', 'text', 'Column text should be text');
SELECT col_type_is('om_streetaxis', 'the_geom', 'geometry(multilinestring, SRID_VALUE)', 'Column the_geom should be geometry(multilinestring, SRID_VALUE)');
SELECT col_type_is('om_streetaxis', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('om_streetaxis', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('om_streetaxis', 'road_type', 'varchar(100)', 'Column road_type should be varchar(100)');
SELECT col_type_is('om_streetaxis', 'surface', 'varchar(100)', 'Column surface should be varchar(100)');
SELECT col_type_is('om_streetaxis', 'maxspeed', 'int4', 'Column maxspeed should be int4');
SELECT col_type_is('om_streetaxis', 'lanes', 'int4', 'Column lanes should be int4');
SELECT col_type_is('om_streetaxis', 'oneway', 'bool', 'Column oneway should be bool');
SELECT col_type_is('om_streetaxis', 'pedestrian', 'bool', 'Column pedestrian should be bool');
SELECT col_type_is('om_streetaxis', 'access_info', 'varchar(100)', 'Column access_info should be varchar(100)');

-- Check foreign keys
SELECT has_fk('om_streetaxis', 'Table om_streetaxis should have foreign keys');

SELECT fk_ok('om_streetaxis', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id → exploitation.expl_id');
SELECT fk_ok('om_streetaxis', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
