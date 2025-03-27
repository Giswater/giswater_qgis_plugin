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

-- Check table man_wtp
SELECT has_table('man_wtp'::name, 'Table man_wtp should exist');

-- Check columns
SELECT columns_are(
    'man_wtp',
    ARRAY[
        'node_id', 'name', 'maxflow', 'opsflow', 'screening', 'desander', 'chemcond', 'oxidation',
        'coagulation', 'floculation', 'presendiment', 'sediment', 'filtration', 'disinfection',
        'chemtreatment', 'storage', 'sludgeman'
    ],
    'Table man_wtp should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_wtp', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_wtp', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('man_wtp', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('man_wtp', 'maxflow', 'double precision', 'Column maxflow should be double precision');
SELECT col_type_is('man_wtp', 'opsflow', 'double precision', 'Column opsflow should be double precision');
SELECT col_type_is('man_wtp', 'screening', 'boolean', 'Column screening should be boolean');
SELECT col_type_is('man_wtp', 'desander', 'boolean', 'Column desander should be boolean');
SELECT col_type_is('man_wtp', 'chemcond', 'boolean', 'Column chemcond should be boolean');
SELECT col_type_is('man_wtp', 'oxidation', 'boolean', 'Column oxidation should be boolean');
SELECT col_type_is('man_wtp', 'coagulation', 'boolean', 'Column coagulation should be boolean');
SELECT col_type_is('man_wtp', 'floculation', 'boolean', 'Column floculation should be boolean');
SELECT col_type_is('man_wtp', 'presendiment', 'boolean', 'Column presendiment should be boolean');
SELECT col_type_is('man_wtp', 'sediment', 'boolean', 'Column sediment should be boolean');
SELECT col_type_is('man_wtp', 'filtration', 'boolean', 'Column filtration should be boolean');
SELECT col_type_is('man_wtp', 'disinfection', 'boolean', 'Column disinfection should be boolean');
SELECT col_type_is('man_wtp', 'chemtreatment', 'boolean', 'Column chemtreatment should be boolean');
SELECT col_type_is('man_wtp', 'storage', 'boolean', 'Column storage should be boolean');
SELECT col_type_is('man_wtp', 'sludgeman', 'boolean', 'Column sludgeman should be boolean');

-- Check foreign keys
SELECT has_fk('man_wtp', 'Table man_wtp should have foreign keys');
SELECT fk_ok('man_wtp', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

-- Check constraints
SELECT col_not_null('man_wtp', 'node_id', 'Column node_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 