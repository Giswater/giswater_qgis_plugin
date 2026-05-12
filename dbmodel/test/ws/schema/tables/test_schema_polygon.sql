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

-- Check table polygon
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

-- Check primary key
SELECT col_is_pk('polygon', ARRAY['pol_id'], 'Column pol_id should be primary key');

-- Check column types
SELECT col_type_is('polygon', 'pol_id', 'character varying(16)', 'Column pol_id should be character varying(16)');
SELECT col_type_is('polygon', 'sys_type', 'character varying(30)', 'Column sys_type should be character varying(30)');
SELECT col_type_is('polygon', 'text', 'text', 'Column text should be text');
SELECT col_type_is('polygon', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('polygon', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('polygon', 'featurecat_id', 'character varying(50)', 'Column featurecat_id should be character varying(50)');
SELECT col_type_is('polygon', 'feature_id', 'integer', 'Column feature_id should be integer');
SELECT col_type_is('polygon', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('polygon', 'trace_featuregeom', 'boolean', 'Column trace_featuregeom should be boolean');
SELECT col_type_is('element', 'lock_level', 'integer', 'Column lock_level should be integer');

-- Check default values
SELECT col_has_default('polygon', 'pol_id', 'Column pol_id should have a default value');
SELECT col_has_default('polygon', 'tstamp', 'Column tstamp should have a default value');
SELECT col_default_is('polygon', 'state', '1', 'Default value for state should be 1');
SELECT col_default_is('polygon', 'trace_featuregeom', 'true', 'Default value for trace_featuregeom should be true');

-- Check unique constraints
SELECT col_is_unique('polygon', ARRAY['feature_id'], 'Column feature_id should be unique');

-- Check foreign keys
SELECT has_fk('polygon', 'Table polygon should have foreign keys');
SELECT fk_ok('polygon', 'sys_type', 'sys_feature_class', 'id', 'FK sys_type should reference sys_feature_class.id');

SELECT * FROM finish();

ROLLBACK;