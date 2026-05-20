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
SELECT has_table('polygon'::name, 'Table polygon should exist');

-- Check columns
SELECT columns_are(
    'polygon',
    ARRAY[
        'pol_id', 'sys_type', 'text', 'the_geom', 'tstamp', 'featurecat_id',
        'feature_id', 'state', 'trace_featuregeom', 'lock_level'
    ],
    'Table polygon should have the correct columns'
);

-- Check column types
SELECT col_type_is('polygon', 'pol_id', 'varchar(16)', 'Column pol_id should be varchar(16)');
SELECT col_type_is('polygon', 'sys_type', 'varchar(30)', 'Column sys_type should be varchar(30)');
SELECT col_type_is('polygon', 'text', 'text', 'Column text should be text');
SELECT col_type_is('polygon', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('polygon', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('polygon', 'featurecat_id', 'varchar(50)', 'Column featurecat_id should be varchar(50)');
SELECT col_type_is('polygon', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('polygon', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('polygon', 'trace_featuregeom', 'bool', 'Column trace_featuregeom should be bool');
SELECT col_type_is('polygon', 'lock_level', 'int4', 'Column lock_level should be int4');

-- Check foreign keys
SELECT has_fk('polygon', 'Table polygon should have foreign keys');

SELECT fk_ok('polygon', 'sys_type', 'sys_feature_class', 'id', 'FK sys_type → sys_feature_class.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
