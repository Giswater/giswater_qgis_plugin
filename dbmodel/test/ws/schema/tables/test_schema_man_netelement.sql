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

-- Check table man_netelement
SELECT has_table('man_netelement'::name, 'Table man_netelement should exist');

-- Check columns
SELECT columns_are(
    'man_netelement',
    ARRAY[
        'node_id', 'automated', 'fence_type'
    ],
    'Table man_netelement should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_netelement', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_netelement', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('man_netelement', 'automated', 'boolean', 'Column automated should be boolean');
SELECT col_type_is('man_netelement', 'fence_type', 'integer', 'Column fence_type should be integer');

-- Check not null constraints
SELECT col_not_null('man_netelement', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_netelement', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

-- Check triggers
SELECT has_trigger('man_netelement', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('man_netelement', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

SELECT * FROM finish();

ROLLBACK;