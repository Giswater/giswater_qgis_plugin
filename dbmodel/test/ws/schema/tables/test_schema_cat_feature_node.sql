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

-- Check table cat_feature_node
SELECT has_table('cat_feature_node'::name, 'Table cat_feature_node should exist');

-- Check columns
SELECT columns_are(
    'cat_feature_node',
    ARRAY[
        'id', 'epa_default', 'num_arcs', 'choose_hemisphere', 'isarcdivide', 'graph_delimiter', 'isprofilesurface', 'double_geom'
    ],
    'Table cat_feature_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_feature_node', 'id', 'Column id should be primary key');

-- Check indexes

-- Check column types
SELECT col_type_is('cat_feature_node', 'id', 'character varying(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_feature_node', 'epa_default', 'character varying(30)', 'Column epa_default should be varchar(30)');
SELECT col_type_is('cat_feature_node', 'num_arcs', 'integer', 'Column num_arcs should be integer');
SELECT col_type_is('cat_feature_node', 'choose_hemisphere', 'boolean', 'Column choose_hemisphere should be boolean');
SELECT col_type_is('cat_feature_node', 'isarcdivide', 'boolean', 'Column isarcdivide should be boolean');
SELECT col_type_is('cat_feature_node', 'graph_delimiter', 'character varying(20)', 'Column graph_delimiter should be varchar(20)');
SELECT col_type_is('cat_feature_node', 'isprofilesurface', 'boolean', 'Column isprofilesurface should be boolean');
SELECT col_type_is('cat_feature_node', 'double_geom', 'json', 'Column double_geom should be json');

-- Check foreign keys
SELECT has_fk('cat_feature_node', 'Table cat_feature_node should have foreign keys');
SELECT fk_ok('cat_feature_node', 'id', 'cat_feature', 'id', 'Column id should reference cat_feature(id)');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_has_check('cat_feature_node', 'epa_default', 'Column epa_default should have check constraint');
SELECT col_has_check('cat_feature_node', 'graph_delimiter', 'Column graph_delimiter should have check constraint');
SELECT col_has_default('cat_feature_node', 'choose_hemisphere', 'Column choose_hemisphere should have default value');
SELECT col_has_default('cat_feature_node', 'isarcdivide', 'Column isarcdivide should have default value');
SELECT col_has_default('cat_feature_node', 'graph_delimiter', 'Column graph_delimiter should have default value');
SELECT col_has_default('cat_feature_node', 'isprofilesurface', 'Column isprofilesurface should have default value');
SELECT col_has_default('cat_feature_node', 'double_geom', 'Column double_geom should have default value');

SELECT * FROM finish();

ROLLBACK;
