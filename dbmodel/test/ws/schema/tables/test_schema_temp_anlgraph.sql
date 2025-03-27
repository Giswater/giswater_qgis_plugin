/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table temp_anlgraph
SELECT has_table('temp_anlgraph'::name, 'Table temp_anlgraph should exist');

-- Check columns
SELECT columns_are(
    'temp_anlgraph',
    ARRAY[
        'id', 'arc_id', 'node_1', 'node_2', 'water', 'flag', 'checkf', 'length', 'cost', 'value',
        'trace', 'isheader', 'orderby', 'cur_user'
    ],
    'Table temp_anlgraph should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('temp_anlgraph', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('temp_anlgraph', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('temp_anlgraph', 'arc_id', 'character varying(20)', 'Column arc_id should be character varying(20)');
SELECT col_type_is('temp_anlgraph', 'node_1', 'character varying(20)', 'Column node_1 should be character varying(20)');
SELECT col_type_is('temp_anlgraph', 'node_2', 'character varying(20)', 'Column node_2 should be character varying(20)');
SELECT col_type_is('temp_anlgraph', 'water', 'smallint', 'Column water should be smallint');
SELECT col_type_is('temp_anlgraph', 'flag', 'smallint', 'Column flag should be smallint');
SELECT col_type_is('temp_anlgraph', 'checkf', 'smallint', 'Column checkf should be smallint');
SELECT col_type_is('temp_anlgraph', 'length', 'numeric(12,4)', 'Column length should be numeric(12,4)');
SELECT col_type_is('temp_anlgraph', 'cost', 'numeric(12,4)', 'Column cost should be numeric(12,4)');
SELECT col_type_is('temp_anlgraph', 'value', 'numeric(12,4)', 'Column value should be numeric(12,4)');
SELECT col_type_is('temp_anlgraph', 'trace', 'integer', 'Column trace should be integer');
SELECT col_type_is('temp_anlgraph', 'isheader', 'boolean', 'Column isheader should be boolean');
SELECT col_type_is('temp_anlgraph', 'orderby', 'integer', 'Column orderby should be integer');
SELECT col_type_is('temp_anlgraph', 'cur_user', 'text', 'Column cur_user should be text');

-- Check default values
SELECT col_has_default('temp_anlgraph', 'id', 'Column id should have a default value');
SELECT col_default_is('temp_anlgraph', 'cur_user', 'CURRENT_USER', 'Column cur_user should default to CURRENT_USER');

-- Check constraints
SELECT col_not_null('temp_anlgraph', 'id', 'Column id should be NOT NULL');
SELECT col_is_unique('temp_anlgraph', ARRAY['arc_id', 'node_1'], 'Columns arc_id, node_1 should be unique');

-- Check indexes
SELECT has_index('temp_anlgraph', 'temp_anlgraph_arc_id', 'Index temp_anlgraph_arc_id should exist');
SELECT has_index('temp_anlgraph', 'temp_anlgraph_node_1', 'Index temp_anlgraph_node_1 should exist');
SELECT has_index('temp_anlgraph', 'temp_anlgraph_node_2', 'Index temp_anlgraph_node_2 should exist');

SELECT * FROM finish();

ROLLBACK;