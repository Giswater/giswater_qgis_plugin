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
SELECT has_table('man_frelem'::name, 'Table man_frelem should exist');

-- Check columns
SELECT columns_are(
    'man_frelem',
    ARRAY[
        'element_id', 'node_id', 'to_arc', 'flwreg_length'
    ],
    'Table man_frelem should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_frelem', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('man_frelem', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_frelem', 'to_arc', 'int4', 'Column to_arc should be int4');
SELECT col_type_is('man_frelem', 'flwreg_length', 'numeric', 'Column flwreg_length should be numeric');

-- Check foreign keys
SELECT has_fk('man_frelem', 'Table man_frelem should have foreign keys');

SELECT fk_ok('man_frelem', 'element_id', 'element', 'element_id', 'FK element_id → element.element_id');
SELECT fk_ok('man_frelem', 'to_arc', 'arc', 'arc_id', 'FK to_arc → arc.arc_id');
SELECT fk_ok('man_frelem', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
