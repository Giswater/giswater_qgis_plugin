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

-- Check table man_hydrant
SELECT has_table('man_hydrant'::name, 'Table man_hydrant should exist');

-- Check columns
SELECT columns_are(
    'man_hydrant',
    ARRAY[
        'node_id', 'fire_code', 'communication', 'valve', 'geom1', 'geom2', 'customer_code',
        'hydrant_type', 'security_cover'
    ],
    'Table man_hydrant should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_hydrant', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_hydrant', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('man_hydrant', 'fire_code', 'varchar(30)', 'Column fire_code should be varchar(30)');
SELECT col_type_is('man_hydrant', 'communication', 'varchar(254)', 'Column communication should be varchar(254)');
SELECT col_type_is('man_hydrant', 'valve', 'varchar(100)', 'Column valve should be varchar(100)');
SELECT col_type_is('man_hydrant', 'geom1', 'double precision', 'Column geom1 should be double precision');
SELECT col_type_is('man_hydrant', 'geom2', 'double precision', 'Column geom2 should be double precision');
SELECT col_type_is('man_hydrant', 'customer_code', 'varchar(30)', 'Column customer_code should be varchar(30)');
SELECT col_type_is('man_hydrant', 'hydrant_type', 'integer', 'Column hydrant_type should be integer');
SELECT col_type_is('man_hydrant', 'security_cover', 'boolean', 'Column security_cover should be boolean');

-- Check not null constraints
SELECT col_not_null('man_hydrant', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_hydrant', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');
SELECT fk_ok('man_hydrant', 'valve', 'cat_node', 'id', 'FK valve should reference cat_node.id');

-- Check triggers
SELECT has_trigger('man_hydrant', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('man_hydrant', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

SELECT * FROM finish();

ROLLBACK;