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

-- Check table man_wtp
SELECT has_table('man_wtp'::name, 'Table man_wtp should exist');

-- Check columns
SELECT columns_are(
    'man_wtp',
    ARRAY[
        'node_id', 'name', 'maxflow', 'opsflow', 'screening', 'desander', 'chemical', 'oxidation',
        'coagulation', 'floculation', 'presendiment', 'sediment', 'filtration', 'disinfection',
        'storage', 'sludgeman', 'inlet_arc'
    ],
    'Table man_wtp should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_wtp', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_wtp', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('man_wtp', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('man_wtp', 'maxflow', 'double precision', 'Column maxflow should be double precision');
SELECT col_type_is('man_wtp', 'opsflow', 'double precision', 'Column opsflow should be double precision');
SELECT col_type_is('man_wtp', 'screening', 'integer', 'Column screening should be integer');
SELECT col_type_is('man_wtp', 'desander', 'integer', 'Column desander should be integer');
SELECT col_type_is('man_wtp', 'chemical', 'integer', 'Column chemical should be integer');
SELECT col_type_is('man_wtp', 'oxidation', 'integer', 'Column oxidation should be integer');
SELECT col_type_is('man_wtp', 'coagulation', 'integer', 'Column coagulation should be integer');
SELECT col_type_is('man_wtp', 'floculation', 'integer', 'Column floculation should be integer');
SELECT col_type_is('man_wtp', 'presendiment', 'integer', 'Column presendiment should be integer');
SELECT col_type_is('man_wtp', 'sediment', 'integer', 'Column sediment should be integer');
SELECT col_type_is('man_wtp', 'filtration', 'integer', 'Column filtration should be integer');
SELECT col_type_is('man_wtp', 'disinfection', 'integer', 'Column disinfection should be integer');
SELECT col_type_is('man_wtp', 'storage', 'integer', 'Column storage should be integer');
SELECT col_type_is('man_wtp', 'sludgeman', 'integer', 'Column sludgeman should be integer');
SELECT col_type_is('man_wtp', 'inlet_arc', 'integer[]', 'Column inlet_arc should be integer[]');

-- Check foreign keys
SELECT has_fk('man_wtp', 'Table man_wtp should have foreign keys');
SELECT fk_ok('man_wtp', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

-- Check constraints
SELECT col_not_null('man_wtp', 'node_id', 'Column node_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;