/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table om_mincut_polygon
SELECT has_table('om_mincut_polygon'::name, 'Table om_mincut_polygon should exist');

-- Check columns
SELECT columns_are(
    'om_mincut_polygon',
    ARRAY[
        'id', 'result_id', 'polygon_id', 'the_geom'
    ],
    'Table om_mincut_polygon should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_mincut_polygon', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_mincut_polygon', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('om_mincut_polygon', 'result_id', 'integer', 'Column result_id should be integer');
SELECT col_type_is('om_mincut_polygon', 'polygon_id', 'varchar(16)', 'Column polygon_id should be varchar(16)');
SELECT col_type_is('om_mincut_polygon', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');

-- Check foreign keys
SELECT has_fk('om_mincut_polygon', 'Table om_mincut_polygon should have foreign keys');
SELECT fk_ok('om_mincut_polygon', 'result_id', 'om_mincut', 'id', 'FK result_id should reference om_mincut.id');

-- Check constraints
SELECT col_not_null('om_mincut_polygon', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_mincut_polygon', 'result_id', 'Column result_id should be NOT NULL');
SELECT col_not_null('om_mincut_polygon', 'polygon_id', 'Column polygon_id should be NOT NULL');

-- Check indexes
SELECT has_index('om_mincut_polygon', 'mincut_polygon_index', 'Table should have mincut_polygon_index on the_geom');

SELECT * FROM finish();

ROLLBACK; 