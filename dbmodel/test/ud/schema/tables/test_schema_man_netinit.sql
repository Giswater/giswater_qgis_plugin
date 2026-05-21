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
SELECT has_table('man_netinit'::name, 'Table man_netinit should exist');

-- Check columns
SELECT columns_are(
    'man_netinit',
    ARRAY[
        'node_id', 'length', 'width', 'inlet', 'bottom_channel', 'accessibility',
        'name', 'sander_depth', 'inlet_medium'
    ],
    'Table man_netinit should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_netinit', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_netinit', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('man_netinit', 'width', 'numeric(12,3)', 'Column width should be numeric(12,3)');
SELECT col_type_is('man_netinit', 'inlet', 'bool', 'Column inlet should be bool');
SELECT col_type_is('man_netinit', 'bottom_channel', 'bool', 'Column bottom_channel should be bool');
SELECT col_type_is('man_netinit', 'accessibility', 'varchar(16)', 'Column accessibility should be varchar(16)');
SELECT col_type_is('man_netinit', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('man_netinit', 'sander_depth', 'numeric(12,3)', 'Column sander_depth should be numeric(12,3)');
SELECT col_type_is('man_netinit', 'inlet_medium', 'int4', 'Column inlet_medium should be int4');

-- Check foreign keys
SELECT has_fk('man_netinit', 'Table man_netinit should have foreign keys');

SELECT fk_ok('man_netinit', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
