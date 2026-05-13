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
SELECT has_table('minsector'::name, 'Table minsector should exist');

-- Check columns
SELECT columns_are(
    'minsector',
    ARRAY[
        'minsector_id', 'the_geom'
    ],
    'Table minsector should have the correct columns'
);

-- Check column types
SELECT col_type_is('minsector', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('minsector', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
