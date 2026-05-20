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
SELECT has_table('node_x_sector_visibility'::name, 'Table node_x_sector_visibility should exist');

-- Check columns
SELECT columns_are(
    'node_x_sector_visibility',
    ARRAY[
        'node_id', 'sector_id'
    ],
    'Table node_x_sector_visibility should have the correct columns'
);

-- Check column types
SELECT col_type_is('node_x_sector_visibility', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('node_x_sector_visibility', 'sector_id', 'int4', 'Column sector_id should be int4');

-- Check foreign keys
SELECT has_fk('node_x_sector_visibility', 'Table node_x_sector_visibility should have foreign keys');

SELECT fk_ok('node_x_sector_visibility', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');
SELECT fk_ok('node_x_sector_visibility', 'sector_id', 'sector', 'sector_id', 'FK sector_id → sector.sector_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
