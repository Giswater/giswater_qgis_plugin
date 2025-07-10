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
        'rotation_label', 'offset_label', 'direction_arrow',
        'x_symbol', 'y_symbol', 'feature_id', 'feature_type',
        'state', 'expl_id', 'observ', 'comment', 'tstamp',
        'insert_user', 'lastupdate', 'lastupdate_user',
        'muni_id', 'sector_id', 'workcat_id'
    ],
    'Table dimensions should have the correct columns'
);


-- Check primary key
SELECT col_is_pk('dimensions', 'id', 'Column id should be primary key');

SELECT col_type_is('dimensions', 'id', 'bigserial', 'Column id should be bigserial');
SELECT col_type_is('dimensions', 'distance', 'numeric(12,4)', 'Column distance should be numeric(12,4)');
SELECT col_type_is('dimensions', 'depth', 'numeric(12,4)', 'Column depth should be numeric(12,4)');
SELECT col_type_is('dimensions', 'the_geom', 'geometry(linestring,25831)', 'Column the_geom should be geometry(linestring,25831)');
SELECT col_type_is('dimensions', 'x_label', 'float8', 'Column x_label should be float8');
SELECT col_type_is('dimensions', 'y_label', 'float8', 'Column y_label should be float8');
SELECT col_type_is('dimensions', 'rotation_label', 'float8', 'Column rotation_label should be float8');
SELECT col_type_is('dimensions', 'offset_label', 'float8', 'Column offset_label should be float8');
SELECT col_type_is('dimensions', 'direction_arrow', 'bool', 'Column direction_arrow should be bool');
SELECT col_type_is('dimensions', 'x_symbol', 'float8', 'Column x_symbol should be float8');
SELECT col_type_is('dimensions', 'y_symbol', 'float8', 'Column y_symbol should be float8');
SELECT col_type_is('dimensions', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('dimensions', 'feature_type', 'varchar', 'Column feature_type should be varchar');
SELECT col_type_is('dimensions', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('dimensions', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('dimensions', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('dimensions', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('dimensions', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');
SELECT col_type_is('dimensions', 'insert_user', 'varchar(50)', 'Column insert_user should be varchar(50)');
SELECT col_type_is('dimensions', 'lastupdate', 'timestamp', 'Column lastupdate should be timestamp');
SELECT col_type_is('dimensions', 'lastupdate_user', 'varchar(50)', 'Column lastupdate_user should be varchar(50)');
SELECT col_type_is('dimensions', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('dimensions', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('dimensions', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');

-- Check default values
SELECT col_has_default('dimensions', 'tstamp', 'Column tstamp should have default value');
SELECT col_has_default('dimensions', 'insert_user', 'Column insert_user should have default value');
SELECT col_has_default('dimensions', 'muni_id', 'Column muni_id should have default value');
SELECT col_has_default('dimensions', 'sector_id', 'Column sector_id should have default value');


-- Check foreign keys
SELECT has_fk('dimensions', 'Table dimensions should have foreign keys');

SELECT fk_ok('dimensions', 'expl_id', 'exploitation', 'expl_id','Table should have foreign key from expl_id to exploitation.expl_id');
SELECT fk_ok('dimensions', 'feature_type', 'sys_feature_type', 'id','Table should have foreign key from feature_type to sys_feature_type.id');
SELECT fk_ok('dimensions', 'muni_id', 'ext_municipality', 'muni_id','Table should have foreign key from muni_id to ext_municipality.muni_id');
SELECT fk_ok('dimensions', 'sector_id', 'sector', 'sector_id','Table should have foreign key from sector_id to sector.sector_id');
SELECT fk_ok('dimensions', 'state', 'value_state', 'id','Table should have foreign key from state to value_state.id');
SELECT fk_ok('dimensions', 'workcat_id', 'cat_work', 'id','Table should have foreign key from workcat_id to cat_work.id');

-- Check indexes
SELECT has_index('dimensions', 'muni_id', 'Table should have index on muni_id');
SELECT has_index('dimensions', 'sector_id', 'Table should have index on sector_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;