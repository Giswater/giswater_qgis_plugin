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
SELECT has_table('element_x_sector_visibility'::name, 'Table element_x_sector_visibility should exist');

-- Check columns
SELECT columns_are(
    'element_x_sector_visibility',
    ARRAY[
        'element_id', 'sector_id'
    ],
    'Table element_x_sector_visibility should have the correct columns'
);

-- Check column types
SELECT col_type_is('element_x_sector_visibility', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('element_x_sector_visibility', 'sector_id', 'int4', 'Column sector_id should be int4');

-- Check foreign keys
SELECT has_fk('element_x_sector_visibility', 'Table element_x_sector_visibility should have foreign keys');

SELECT fk_ok('element_x_sector_visibility', 'element_id', 'element', 'element_id', 'FK element_id → element.element_id');
SELECT fk_ok('element_x_sector_visibility', 'sector_id', 'sector', 'sector_id', 'FK sector_id → sector.sector_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
