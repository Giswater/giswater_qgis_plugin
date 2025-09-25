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
SELECT has_table('element_x_gully'::name, 'Table element_x_gully should exist');

-- Check columns
SELECT columns_are(
    'element_x_gully',
    ARRAY[
        'element_id', 'gully_id', 'gully_uuid'
    ],
    'Table element_x_gully should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('element_x_gully', ARRAY['element_id', 'gully_id'], 'Columns element_id and gully_id should be primary key');

-- Check column types
SELECT col_type_is('element_x_gully', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('element_x_gully', 'gully_id', 'int4', 'Column gully_id should be int4');
SELECT col_type_is('element_x_gully', 'gully_uuid', 'uuid', 'Column gully_uuid should be uuid');

-- Check foreign keys
SELECT has_fk('element_x_gully', 'Table element_x_gully should have foreign keys');

SELECT fk_ok('element_x_gully', 'element_id', 'element', 'element_id', 'Table should have foreign key from element_id to element.element_id');
SELECT fk_ok('element_x_gully', 'gully_id', 'gully', 'gully_id', 'Table should have foreign key from gully_id to gully.gully_id');

-- Check indexes
SELECT has_index('element_x_gully', 'element_x_gully_pkey', ARRAY['element_id', 'gully_id'], 'Table should have index on element_id, gully_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;