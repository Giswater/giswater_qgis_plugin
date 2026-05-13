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
SELECT has_table('node_x_municipality_visibility'::name, 'Table node_x_municipality_visibility should exist');

-- Check columns
SELECT columns_are(
    'node_x_municipality_visibility',
    ARRAY[
        'node_id', 'muni_id'
    ],
    'Table node_x_municipality_visibility should have the correct columns'
);

-- Check column types
SELECT col_type_is('node_x_municipality_visibility', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('node_x_municipality_visibility', 'muni_id', 'int4', 'Column muni_id should be int4');

-- Check foreign keys
SELECT has_fk('node_x_municipality_visibility', 'Table node_x_municipality_visibility should have foreign keys');

SELECT fk_ok('node_x_municipality_visibility', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');
SELECT fk_ok('node_x_municipality_visibility', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
