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

-- Check table minsector_graph
SELECT has_table('minsector_graph'::name, 'Table minsector_graph should exist');

-- Check columns
SELECT columns_are(
    'minsector_graph',
    ARRAY[
        'node_id', 'node_type', 'minsector_1', 'minsector_2'
    ],
    'Table minsector_graph should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('minsector_graph', ARRAY['node_id'], 'Columns node_id should be primary key');

-- Check column types
SELECT col_type_is('minsector_graph', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('minsector_graph', 'node_type', 'character varying(30)', 'Column node_type should be character varying(30)');
SELECT col_type_is('minsector_graph', 'minsector_1', 'integer', 'Column minsector_1 should be integer');
SELECT col_type_is('minsector_graph', 'minsector_2', 'integer', 'Column minsector_2 should be integer');

-- Check constraints
SELECT col_not_null('minsector_graph', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_not_null('minsector_graph', 'node_type', 'Column node_type should be NOT NULL');
SELECT col_not_null('minsector_graph', 'minsector_1', 'Column minsector_1 should be NOT NULL');
SELECT col_not_null('minsector_graph', 'minsector_2', 'Column minsector_2 should be NOT NULL');

-- Check foreign key
SELECT fk_ok('minsector_graph', ARRAY['minsector_1'], 'minsector', ARRAY['minsector_id'], 'Table should have foreign key from minsector_1 to minsector(minsector_id)');
SELECT fk_ok('minsector_graph', ARRAY['minsector_2'], 'minsector', ARRAY['minsector_id'], 'Table should have foreign key from minsector_2 to minsector(minsector_id)');

-- Check indexes
SELECT has_index('minsector_graph', 'minsector_graph_minsector_1_idx', ARRAY['minsector_1'], 'Index minsector_graph_minsector_1_idx should be on column minsector_1');
SELECT has_index('minsector_graph', 'minsector_graph_minsector_2_idx', ARRAY['minsector_2'], 'Index minsector_graph_minsector_2_idx should be on column minsector_2');


SELECT * FROM finish();

ROLLBACK;