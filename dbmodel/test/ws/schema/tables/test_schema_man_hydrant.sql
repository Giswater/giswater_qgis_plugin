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
SELECT has_table('man_hydrant'::name, 'Table man_hydrant should exist');

-- Check columns
SELECT columns_are(
    'man_hydrant',
    ARRAY[
        'node_id', 'fire_code', 'communication', 'valve', 'geom1', 'geom2',
        'customer_code', 'hydrant_type', 'security_cover'
    ],
    'Table man_hydrant should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_hydrant', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_hydrant', 'fire_code', 'varchar(30)', 'Column fire_code should be varchar(30)');
SELECT col_type_is('man_hydrant', 'communication', 'varchar(254)', 'Column communication should be varchar(254)');
SELECT col_type_is('man_hydrant', 'valve', 'varchar(100)', 'Column valve should be varchar(100)');
SELECT col_type_is('man_hydrant', 'geom1', 'float8', 'Column geom1 should be float8');
SELECT col_type_is('man_hydrant', 'geom2', 'float8', 'Column geom2 should be float8');
SELECT col_type_is('man_hydrant', 'customer_code', 'varchar(30)', 'Column customer_code should be varchar(30)');
SELECT col_type_is('man_hydrant', 'hydrant_type', 'int4', 'Column hydrant_type should be int4');
SELECT col_type_is('man_hydrant', 'security_cover', 'bool', 'Column security_cover should be bool');

-- Check foreign keys
SELECT has_fk('man_hydrant', 'Table man_hydrant should have foreign keys');

SELECT fk_ok('man_hydrant', 'valve', 'cat_node', 'id', 'FK valve → cat_node.id');
SELECT fk_ok('man_hydrant', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
