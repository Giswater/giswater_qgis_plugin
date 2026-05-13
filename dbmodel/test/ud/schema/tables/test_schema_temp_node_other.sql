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
SELECT has_table('temp_node_other'::name, 'Table temp_node_other should exist');

-- Check columns
SELECT columns_are(
    'temp_node_other',
    ARRAY[
        'id', 'node_id', 'type', 'poll_id', 'timser_id', 'other',
        'mfactor', 'sfactor', 'base', 'pattern_id', 'active'
    ],
    'Table temp_node_other should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_node_other', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('temp_node_other', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('temp_node_other', 'type', 'varchar(16)', 'Column type should be varchar(16)');
SELECT col_type_is('temp_node_other', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('temp_node_other', 'timser_id', 'varchar(16)', 'Column timser_id should be varchar(16)');
SELECT col_type_is('temp_node_other', 'other', 'varchar(30)', 'Column other should be varchar(30)');
SELECT col_type_is('temp_node_other', 'mfactor', 'numeric(12,4)', 'Column mfactor should be numeric(12,4)');
SELECT col_type_is('temp_node_other', 'sfactor', 'numeric(12,4)', 'Column sfactor should be numeric(12,4)');
SELECT col_type_is('temp_node_other', 'base', 'numeric(12,4)', 'Column base should be numeric(12,4)');
SELECT col_type_is('temp_node_other', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('temp_node_other', 'active', 'bool', 'Column active should be bool');

-- Finish
SELECT * FROM finish();

ROLLBACK;
