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

-- Check view v_raster_dem
SELECT has_view('v_raster_dem'::name, 'View v_raster_dem should exist');

-- Check view columns
SELECT columns_are(
    'v_raster_dem',
    ARRAY[
        'id', 'rast', 'rastercat_id', 'envelope'
    ],
    'View v_raster_dem should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_raster_dem', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_raster_dem', 'rast', 'raster', 'Column rast should be raster');
SELECT col_type_is('v_raster_dem', 'rastercat_id', 'text', 'Column rastercat_id should be text');
SELECT col_type_is('v_raster_dem', 'envelope', 'geometry(polygon, SRID_VALUE)', 'Column envelope should be geometry(polygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
