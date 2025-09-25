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

-- Check table doc_x_node
SELECT has_table('doc_x_node'::name, 'Table doc_x_node should exist');

-- Check columns
SELECT columns_are(
    'doc_x_node',
    ARRAY[
        'doc_id', 'node_id', 'node_uuid'
    ],
    'Table doc_x_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('doc_x_node', ARRAY['doc_id', 'node_id'], 'Columns doc_id and node_id should be primary key');

-- Check column types
SELECT col_type_is('doc_x_node', 'doc_id', 'varchar(30)', 'Column doc_id should be varchar(30)');
SELECT col_type_is('doc_x_node', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('doc_x_node', 'node_uuid', 'uuid', 'Column node_uuid should be uuid');

-- Check foreign keys
SELECT has_fk('doc_x_node', 'Table doc_x_node should have foreign keys');
SELECT fk_ok('doc_x_node', 'node_id', 'node', 'node_id', 'FK doc_x_node_node_id_fkey should exist');
SELECT fk_ok('doc_x_node', 'doc_id', 'doc', 'id', 'FK doc_x_node_doc_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('doc_x_node', 'doc_id', 'Column doc_id should be NOT NULL');
SELECT col_not_null('doc_x_node', 'node_id', 'Column node_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
