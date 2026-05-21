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

-- Check view ve_dimensions
SELECT has_view('ve_dimensions'::name, 'View ve_dimensions should exist');

-- Check view columns
SELECT columns_are(
    've_dimensions',
    ARRAY[
        'id', 'distance', 'depth', 'the_geom', 'x_label', 'y_label',
        'rotation_label', 'offset_label', 'direction_arrow', 'x_symbol', 'y_symbol', 'feature_id',
        'feature_type', 'state', 'expl_id', 'observ', 'comment', 'sector_id',
        'muni_id'
    ],
    'View ve_dimensions should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_dimensions', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('ve_dimensions', 'distance', 'numeric(12,4)', 'Column distance should be numeric(12,4)');
SELECT col_type_is('ve_dimensions', 'depth', 'numeric(12,4)', 'Column depth should be numeric(12,4)');
SELECT col_type_is('ve_dimensions', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('ve_dimensions', 'x_label', 'float8', 'Column x_label should be float8');
SELECT col_type_is('ve_dimensions', 'y_label', 'float8', 'Column y_label should be float8');
SELECT col_type_is('ve_dimensions', 'rotation_label', 'float8', 'Column rotation_label should be float8');
SELECT col_type_is('ve_dimensions', 'offset_label', 'float8', 'Column offset_label should be float8');
SELECT col_type_is('ve_dimensions', 'direction_arrow', 'bool', 'Column direction_arrow should be bool');
SELECT col_type_is('ve_dimensions', 'x_symbol', 'float8', 'Column x_symbol should be float8');
SELECT col_type_is('ve_dimensions', 'y_symbol', 'float8', 'Column y_symbol should be float8');
SELECT col_type_is('ve_dimensions', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('ve_dimensions', 'feature_type', 'varchar', 'Column feature_type should be varchar');
SELECT col_type_is('ve_dimensions', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('ve_dimensions', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_dimensions', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ve_dimensions', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('ve_dimensions', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('ve_dimensions', 'muni_id', 'int4', 'Column muni_id should be int4');

SELECT * FROM finish();

ROLLBACK;
