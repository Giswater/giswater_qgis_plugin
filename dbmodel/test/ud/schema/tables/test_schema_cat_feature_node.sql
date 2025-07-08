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
SELECT has_table('cat_feature_node'::name, 'Table cat_feature_node should exist');

-- Check columns
SELECT columns_are(
    'cat_feature_node',
    ARRAY[
        'id', 'epa_default', 'num_arcs', 'choose_hemisphere', 'isarcdivide', 'isprofilesurface', 'isexitupperintro', 'double_geom', 'graph_delimiter'
    ],
    'Table cat_feature_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_feature_node', 'id', 'Column id should be primary key'); 

-- Check check columns
SELECT col_has_check('cat_feature_node', 'epa_default', 'Table should have check on epa_default');
SELECT col_has_check('cat_feature_node', 'isexitupperintro', 'Table should have check on isexitupperintro');

-- Check column types
SELECT col_type_is('cat_feature_node', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_feature_node', 'epa_default', 'varchar(30)', 'Column epa_default should be varchar(30)');
SELECT col_type_is('cat_feature_node', 'num_arcs', 'int4', 'Column num_arcs should be int4');
SELECT col_type_is('cat_feature_node', 'choose_hemisphere', 'bool', 'Column choose_hemisphere should be bool');
SELECT col_type_is('cat_feature_node', 'isarcdivide', 'bool', 'Column isarcdivide should be bool');
SELECT col_type_is('cat_feature_node', 'isprofilesurface', 'bool', 'Column isprofilesurface should be bool');
SELECT col_type_is('cat_feature_node', 'isexitupperintro', 'int2', 'Column isexitupperintro should be int2');
SELECT col_type_is('cat_feature_node', 'double_geom', 'json', 'Column double_geom should be json');
SELECT col_type_is('cat_feature_node', 'graph_delimiter', 'text', 'Column graph_delimiter should be text');


-- Check default values
SELECT col_has_default('cat_feature_node', 'choose_hemisphere', 'Column choose_hemisphere should have default value');
SELECT col_has_default('cat_feature_node', 'isarcdivide', 'Column isarcdivide should have default value');
SELECT col_has_default('cat_feature_node', 'isprofilesurface', 'Column isprofilesurface should have default value');
SELECT col_has_default('cat_feature_node', 'double_geom', 'Column double_geom should have default value');

-- Check foreign keys
SELECT has_fk('cat_feature_node', 'Table cat_feature_node should have foreign keys');

SELECT fk_ok('cat_feature_node', 'id', 'cat_feature', 'id','Table should have foreign key from id to cat_feature.id');

-- Check indexes
SELECT has_index('cat_feature_node', 'id', 'Table should have index on id');


-- Finish
SELECT * FROM finish();

ROLLBACK;