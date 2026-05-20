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
SELECT has_table('minsector_mincut_valve'::name, 'Table minsector_mincut_valve should exist');

-- Check columns
SELECT columns_are(
    'minsector_mincut_valve',
    ARRAY[
        'minsector_id', 'node_id', 'proposed', 'closed', 'broken', 'unaccess',
        'to_arc', 'changestatus'
    ],
    'Table minsector_mincut_valve should have the correct columns'
);

-- Check column types
SELECT col_type_is('minsector_mincut_valve', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('minsector_mincut_valve', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('minsector_mincut_valve', 'proposed', 'bool', 'Column proposed should be bool');
SELECT col_type_is('minsector_mincut_valve', 'closed', 'bool', 'Column closed should be bool');
SELECT col_type_is('minsector_mincut_valve', 'broken', 'bool', 'Column broken should be bool');
SELECT col_type_is('minsector_mincut_valve', 'unaccess', 'bool', 'Column unaccess should be bool');
SELECT col_type_is('minsector_mincut_valve', 'to_arc', 'int4', 'Column to_arc should be int4');
SELECT col_type_is('minsector_mincut_valve', 'changestatus', 'bool', 'Column changestatus should be bool');

-- Check foreign keys
SELECT has_fk('minsector_mincut_valve', 'Table minsector_mincut_valve should have foreign keys');

SELECT fk_ok('minsector_mincut_valve', 'minsector_id', 'minsector', 'minsector_id', 'FK minsector_id → minsector.minsector_id');
SELECT fk_ok('minsector_mincut_valve', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
