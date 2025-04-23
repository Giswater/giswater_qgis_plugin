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

-- Check table dimensions
SELECT has_table('dimensions'::name, 'Table dimensions should exist');

-- Check columns
SELECT columns_are(
    'dimensions',
    ARRAY[
        'id', 'distance', 'depth', 'the_geom', 'x_label', 'y_label', 'rotation_label', 'offset_label', 'direction_arrow',
        'x_symbol', 'y_symbol', 'feature_id', 'feature_type', 'state', 'expl_id', 'observ', 'comment', 'tstamp',
        'insert_user', 'lastupdate', 'lastupdate_user', 'muni_id', 'sector_id', 'workcat_id'
    ],
    'Table dimensions should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('dimensions', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('dimensions', 'id', 'bigint', 'Column id should be bigint');
SELECT col_type_is('dimensions', 'distance', 'numeric(12,4)', 'Column distance should be numeric(12,4)');
SELECT col_type_is('dimensions', 'depth', 'numeric(12,4)', 'Column depth should be numeric(12,4)');
SELECT col_type_is('dimensions', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');
SELECT col_type_is('dimensions', 'x_label', 'double precision', 'Column x_label should be double precision');
SELECT col_type_is('dimensions', 'y_label', 'double precision', 'Column y_label should be double precision');
SELECT col_type_is('dimensions', 'rotation_label', 'double precision', 'Column rotation_label should be double precision');
SELECT col_type_is('dimensions', 'offset_label', 'double precision', 'Column offset_label should be double precision');
SELECT col_type_is('dimensions', 'direction_arrow', 'boolean', 'Column direction_arrow should be boolean');
SELECT col_type_is('dimensions', 'x_symbol', 'double precision', 'Column x_symbol should be double precision');
SELECT col_type_is('dimensions', 'y_symbol', 'double precision', 'Column y_symbol should be double precision');
SELECT col_type_is('dimensions', 'feature_id', 'varchar', 'Column feature_id should be varchar');
SELECT col_type_is('dimensions', 'feature_type', 'varchar', 'Column feature_type should be varchar');
SELECT col_type_is('dimensions', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('dimensions', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('dimensions', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('dimensions', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('dimensions', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');
SELECT col_type_is('dimensions', 'insert_user', 'varchar(50)', 'Column insert_user should be varchar(50)');
SELECT col_type_is('dimensions', 'lastupdate', 'timestamp', 'Column lastupdate should be timestamp');
SELECT col_type_is('dimensions', 'lastupdate_user', 'varchar(50)', 'Column lastupdate_user should be varchar(50)');
SELECT col_type_is('dimensions', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('dimensions', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('dimensions', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');

-- Check foreign keys
SELECT has_fk('dimensions', 'Table dimensions should have foreign keys');
SELECT fk_ok('dimensions', 'expl_id', 'exploitation', 'expl_id', 'FK dimensions_exploitation_id_fkey should exist');
SELECT fk_ok('dimensions', 'feature_type', 'sys_feature_type', 'id', 'FK dimensions_feature_type_fkey should exist');
SELECT fk_ok('dimensions', 'muni_id', 'ext_municipality', 'muni_id', 'FK dimensions_muni_id_fkey should exist');
SELECT fk_ok('dimensions', 'sector_id', 'sector', 'sector_id', 'FK dimensions_sector_id should exist');
SELECT fk_ok('dimensions', 'state', 'value_state', 'id', 'FK dimensions_state_fkey should exist');
SELECT fk_ok('dimensions', 'workcat_id', 'cat_work', 'id', 'FK dimensions_workcat_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('dimensions_id_seq', 'Sequence dimensions_id_seq should exist');

-- Check constraints
SELECT col_not_null('dimensions', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('dimensions', 'state', 'Column state should be NOT NULL');
SELECT col_not_null('dimensions', 'expl_id', 'Column expl_id should be NOT NULL');
SELECT col_not_null('dimensions', 'muni_id', 'Column muni_id should be NOT NULL');
SELECT col_not_null('dimensions', 'sector_id', 'Column sector_id should be NOT NULL');

SELECT col_default_is('dimensions', 'tstamp', 'now()', 'Column tstamp should default to now()');
SELECT col_default_is('dimensions', 'insert_user', 'CURRENT_USER', 'Column insert_user should default to CURRENT_USER');
SELECT col_default_is('dimensions', 'sector_id', '0', 'Column sector_id should default to 0');

SELECT * FROM finish();

ROLLBACK;
