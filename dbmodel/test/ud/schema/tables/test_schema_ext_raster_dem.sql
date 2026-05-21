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
SELECT has_table('ext_raster_dem'::name, 'Table ext_raster_dem should exist');

-- Check columns
SELECT columns_are(
    'ext_raster_dem',
    ARRAY[
        'id', 'rast', 'rastercat_id', 'envelope'
    ],
    'Table ext_raster_dem should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_raster_dem', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('ext_raster_dem', 'rast', 'raster', 'Column rast should be raster');
SELECT col_type_is('ext_raster_dem', 'rastercat_id', 'text', 'Column rastercat_id should be text');
SELECT col_type_is('ext_raster_dem', 'envelope', 'geometry(polygon, SRID_VALUE)', 'Column envelope should be geometry(polygon, SRID_VALUE)');

-- Check foreign keys
SELECT has_fk('ext_raster_dem', 'Table ext_raster_dem should have foreign keys');

SELECT fk_ok('ext_raster_dem', 'rastercat_id', 'ext_cat_raster', 'id', 'FK rastercat_id → ext_cat_raster.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
