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
SELECT has_table('minsector_graph'::name, 'Table minsector_graph should exist');

-- Check columns
SELECT columns_are(
    'minsector_graph',
    ARRAY[
        'node_id', 'node_type', 'minsector_1', 'minsector_2'
    ],
    'Table minsector_graph should have the correct columns'
);

-- Check column types
SELECT col_type_is('minsector_graph', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('minsector_graph', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('minsector_graph', 'minsector_1', 'int4', 'Column minsector_1 should be int4');
SELECT col_type_is('minsector_graph', 'minsector_2', 'int4', 'Column minsector_2 should be int4');

-- Check foreign keys
SELECT has_fk('minsector_graph', 'Table minsector_graph should have foreign keys');

SELECT fk_ok('minsector_graph', 'minsector_1', 'minsector', 'minsector_id', 'FK minsector_1 → minsector.minsector_id');
SELECT fk_ok('minsector_graph', 'minsector_2', 'minsector', 'minsector_id', 'FK minsector_2 → minsector.minsector_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
