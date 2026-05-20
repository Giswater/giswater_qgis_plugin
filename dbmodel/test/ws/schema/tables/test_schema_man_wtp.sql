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
SELECT has_table('man_wtp'::name, 'Table man_wtp should exist');

-- Check columns
SELECT columns_are(
    'man_wtp',
    ARRAY[
        'node_id', 'name', 'maxflow', 'opsflow', 'screening', 'desander',
        'chemical', 'oxidation', 'coagulation', 'floculation', 'presendiment', 'sediment',
        'filtration', 'disinfection', 'storage', 'sludgeman', 'inlet_arc'
    ],
    'Table man_wtp should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_wtp', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_wtp', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('man_wtp', 'maxflow', 'float8', 'Column maxflow should be float8');
SELECT col_type_is('man_wtp', 'opsflow', 'float8', 'Column opsflow should be float8');
SELECT col_type_is('man_wtp', 'screening', 'int4', 'Column screening should be int4');
SELECT col_type_is('man_wtp', 'desander', 'int4', 'Column desander should be int4');
SELECT col_type_is('man_wtp', 'chemical', 'int4', 'Column chemical should be int4');
SELECT col_type_is('man_wtp', 'oxidation', 'int4', 'Column oxidation should be int4');
SELECT col_type_is('man_wtp', 'coagulation', 'int4', 'Column coagulation should be int4');
SELECT col_type_is('man_wtp', 'floculation', 'int4', 'Column floculation should be int4');
SELECT col_type_is('man_wtp', 'presendiment', 'int4', 'Column presendiment should be int4');
SELECT col_type_is('man_wtp', 'sediment', 'int4', 'Column sediment should be int4');
SELECT col_type_is('man_wtp', 'filtration', 'int4', 'Column filtration should be int4');
SELECT col_type_is('man_wtp', 'disinfection', 'int4', 'Column disinfection should be int4');
SELECT col_type_is('man_wtp', 'storage', 'int4', 'Column storage should be int4');
SELECT col_type_is('man_wtp', 'sludgeman', 'int4', 'Column sludgeman should be int4');
SELECT col_type_is('man_wtp', 'inlet_arc', 'int4[]', 'Column inlet_arc should be int4[]');

-- Check foreign keys
SELECT has_fk('man_wtp', 'Table man_wtp should have foreign keys');

SELECT fk_ok('man_wtp', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
