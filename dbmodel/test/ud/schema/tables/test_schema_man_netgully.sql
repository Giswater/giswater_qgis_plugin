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
SELECT has_table('man_netgully'::name, 'Table man_netgully should exist');

-- Check columns
SELECT columns_are(
    'man_netgully',
    ARRAY[
        'node_id', 'sander_depth', 'gullycat_id', 'units', 'groove', 'siphon',
        'gullycat2_id', 'groove_height', 'groove_length', 'units_placement'
    ],
    'Table man_netgully should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_netgully', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_netgully', 'sander_depth', 'numeric(12,4)', 'Column sander_depth should be numeric(12,4)');
SELECT col_type_is('man_netgully', 'gullycat_id', 'varchar(18)', 'Column gullycat_id should be varchar(18)');
SELECT col_type_is('man_netgully', 'units', 'int2', 'Column units should be int2');
SELECT col_type_is('man_netgully', 'groove', 'bool', 'Column groove should be bool');
SELECT col_type_is('man_netgully', 'siphon', 'bool', 'Column siphon should be bool');
SELECT col_type_is('man_netgully', 'gullycat2_id', 'text', 'Column gullycat2_id should be text');
SELECT col_type_is('man_netgully', 'groove_height', 'float8', 'Column groove_height should be float8');
SELECT col_type_is('man_netgully', 'groove_length', 'float8', 'Column groove_length should be float8');
SELECT col_type_is('man_netgully', 'units_placement', 'varchar(16)', 'Column units_placement should be varchar(16)');

-- Check foreign keys
SELECT has_fk('man_netgully', 'Table man_netgully should have foreign keys');

SELECT fk_ok('man_netgully', 'gullycat2_id', 'cat_gully', 'id', 'FK gullycat2_id → cat_gully.id');
SELECT fk_ok('man_netgully', 'gullycat_id', 'cat_gully', 'id', 'FK gullycat_id → cat_gully.id');
SELECT fk_ok('man_netgully', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
