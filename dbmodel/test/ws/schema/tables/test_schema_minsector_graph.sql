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
        'node_id', 'nodecat_id', 'minsector_1', 'minsector_2', 'macrominsector_id'
    ],
    'Table minsector_graph should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('minsector_graph', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('minsector_graph', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('minsector_graph', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('minsector_graph', 'minsector_1', 'integer', 'Column minsector_1 should be integer');
SELECT col_type_is('minsector_graph', 'minsector_2', 'integer', 'Column minsector_2 should be integer');
SELECT col_type_is('minsector_graph', 'macrominsector_id', 'integer', 'Column macrominsector_id should be integer');

-- Check default values
SELECT col_default_is('minsector_graph', 'macrominsector_id', '0', 'Column macrominsector_id should default to 0');

-- Check constraints
SELECT col_not_null('minsector_graph', 'node_id', 'Column node_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;