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

-- Check table ext_raster_dem
SELECT has_table('ext_raster_dem'::name, 'Table ext_raster_dem should exist');

-- Check columns
SELECT columns_are(
    'ext_raster_dem',
    ARRAY[
        'id', 'rast', 'rastercat_id', 'envelope'
    ],
    'Table ext_raster_dem should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_raster_dem', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_raster_dem', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('ext_raster_dem', 'rast', 'raster', 'Column rast should be raster');
SELECT col_type_is('ext_raster_dem', 'rastercat_id', 'text', 'Column rastercat_id should be text');
SELECT col_type_is('ext_raster_dem', 'envelope', 'geometry(Polygon,25831)', 'Column envelope should be geometry(Polygon,25831)');

-- Check indexes

-- Check foreign keys
SELECT has_fk('ext_raster_dem', 'Table ext_raster_dem should have foreign keys');
SELECT fk_ok('ext_raster_dem', 'rastercat_id', 'ext_cat_raster', 'id', 'FK raster_dem_rastercat_id_fkey should exist');

-- Check triggers
SELECT has_trigger('ext_raster_dem', 'gw_trg_manage_raster_dem_delete', 'Table should have gw_trg_manage_raster_dem_delete trigger');
SELECT has_trigger('ext_raster_dem', 'gw_trg_manage_raster_dem_insert', 'Table should have gw_trg_manage_raster_dem_insert trigger');

-- Check sequences
SELECT has_sequence('raster_dem_id_seq', 'Sequence raster_dem_id_seq should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_raster_dem', 'id', 'Column id should be NOT NULL');
SELECT col_has_default('ext_raster_dem', 'id', 'Column id should have default value');

SELECT * FROM finish();

ROLLBACK;
