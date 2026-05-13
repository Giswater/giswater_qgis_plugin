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
SELECT has_table('element_x_municipality_visibility'::name, 'Table element_x_municipality_visibility should exist');

-- Check columns
SELECT columns_are(
    'element_x_municipality_visibility',
    ARRAY[
        'element_id', 'muni_id'
    ],
    'Table element_x_municipality_visibility should have the correct columns'
);

-- Check column types
SELECT col_type_is('element_x_municipality_visibility', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('element_x_municipality_visibility', 'muni_id', 'int4', 'Column muni_id should be int4');

-- Check foreign keys
SELECT has_fk('element_x_municipality_visibility', 'Table element_x_municipality_visibility should have foreign keys');

SELECT fk_ok('element_x_municipality_visibility', 'element_id', 'element', 'element_id', 'FK element_id → element.element_id');
SELECT fk_ok('element_x_municipality_visibility', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
