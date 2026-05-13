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
SELECT has_table('dimensions'::name, 'Table dimensions should exist');

-- Check columns
SELECT columns_are(
    'dimensions',
    ARRAY[
        'id', 'distance', 'depth', 'the_geom', 'x_label', 'y_label',
        'rotation_label', 'offset_label', 'direction_arrow', 'x_symbol', 'y_symbol', 'feature_id',
        'feature_type', 'state', 'expl_id', 'observ', 'comment', 'tstamp',
        'insert_user', 'lastupdate', 'lastupdate_user', 'muni_id', 'sector_id', 'workcat_id'
    ],
    'Table dimensions should have the correct columns'
);

-- Check column types
SELECT col_type_is('dimensions', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('dimensions', 'distance', 'numeric(12,4)', 'Column distance should be numeric(12,4)');
SELECT col_type_is('dimensions', 'depth', 'numeric(12,4)', 'Column depth should be numeric(12,4)');
SELECT col_type_is('dimensions', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('dimensions', 'x_label', 'float8', 'Column x_label should be float8');
SELECT col_type_is('dimensions', 'y_label', 'float8', 'Column y_label should be float8');
SELECT col_type_is('dimensions', 'rotation_label', 'float8', 'Column rotation_label should be float8');
SELECT col_type_is('dimensions', 'offset_label', 'float8', 'Column offset_label should be float8');
SELECT col_type_is('dimensions', 'direction_arrow', 'bool', 'Column direction_arrow should be bool');
SELECT col_type_is('dimensions', 'x_symbol', 'float8', 'Column x_symbol should be float8');
SELECT col_type_is('dimensions', 'y_symbol', 'float8', 'Column y_symbol should be float8');
SELECT col_type_is('dimensions', 'feature_id', 'varchar', 'Column feature_id should be varchar');
SELECT col_type_is('dimensions', 'feature_type', 'varchar', 'Column feature_type should be varchar');
SELECT col_type_is('dimensions', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('dimensions', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('dimensions', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('dimensions', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('dimensions', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('dimensions', 'insert_user', 'varchar(50)', 'Column insert_user should be varchar(50)');
SELECT col_type_is('dimensions', 'lastupdate', 'timestamp without time zone', 'Column lastupdate should be timestamp without time zone');
SELECT col_type_is('dimensions', 'lastupdate_user', 'varchar(50)', 'Column lastupdate_user should be varchar(50)');
SELECT col_type_is('dimensions', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('dimensions', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('dimensions', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');

-- Check foreign keys
SELECT has_fk('dimensions', 'Table dimensions should have foreign keys');

SELECT fk_ok('dimensions', 'feature_type', 'sys_feature_type', 'id', 'FK feature_type → sys_feature_type.id');
SELECT fk_ok('dimensions', 'state', 'value_state', 'id', 'FK state → value_state.id');
SELECT fk_ok('dimensions', 'workcat_id', 'cat_work', 'id', 'FK workcat_id → cat_work.id');
SELECT fk_ok('dimensions', 'sector_id', 'sector', 'sector_id', 'FK sector_id → sector.sector_id');
SELECT fk_ok('dimensions', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id → exploitation.expl_id');
SELECT fk_ok('dimensions', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');
SELECT fk_ok('dimensions', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
