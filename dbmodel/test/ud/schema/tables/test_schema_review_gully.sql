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
SELECT has_table('review_gully'::name, 'Table review_gully should exist');

-- Check columns
SELECT columns_are(
    'review_gully',
    ARRAY[
        'gully_id', 'top_elev', 'ymax', 'sandbox', 'gully_type', 'matcat_id',
        'gullycat_id', 'units', 'groove', 'siphon', 'connec_arccat_id', 'annotation',
        'observ', 'review_obs', 'expl_id', 'the_geom', 'field_checked', 'is_validated',
        'field_date'
    ],
    'Table review_gully should have the correct columns'
);

-- Check column types
SELECT col_type_is('review_gully', 'gully_id', 'int4', 'Column gully_id should be int4');
SELECT col_type_is('review_gully', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('review_gully', 'ymax', 'numeric(12,3)', 'Column ymax should be numeric(12,3)');
SELECT col_type_is('review_gully', 'sandbox', 'numeric(12,3)', 'Column sandbox should be numeric(12,3)');
SELECT col_type_is('review_gully', 'gully_type', 'varchar(30)', 'Column gully_type should be varchar(30)');
SELECT col_type_is('review_gully', 'matcat_id', 'varchar(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('review_gully', 'gullycat_id', 'varchar(30)', 'Column gullycat_id should be varchar(30)');
SELECT col_type_is('review_gully', 'units', 'int2', 'Column units should be int2');
SELECT col_type_is('review_gully', 'groove', 'bool', 'Column groove should be bool');
SELECT col_type_is('review_gully', 'siphon', 'bool', 'Column siphon should be bool');
SELECT col_type_is('review_gully', 'connec_arccat_id', 'varchar(18)', 'Column connec_arccat_id should be varchar(18)');
SELECT col_type_is('review_gully', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('review_gully', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('review_gully', 'review_obs', 'text', 'Column review_obs should be text');
SELECT col_type_is('review_gully', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('review_gully', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('review_gully', 'field_checked', 'bool', 'Column field_checked should be bool');
SELECT col_type_is('review_gully', 'is_validated', 'int4', 'Column is_validated should be int4');
SELECT col_type_is('review_gully', 'field_date', 'timestamp(6) without time zone', 'Column field_date should be timestamp(6) without time zone');

-- Finish
SELECT * FROM finish();

ROLLBACK;
