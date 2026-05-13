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
SELECT has_table('cat_dscenario'::name, 'Table cat_dscenario should exist');

-- Check columns
SELECT columns_are(
    'cat_dscenario',
    ARRAY[
        'dscenario_id', 'name', 'descript', 'parent_id', 'dscenario_type', 'active',
        'expl_id', 'log'
    ],
    'Table cat_dscenario should have the correct columns'
);

-- Check column types
SELECT col_type_is('cat_dscenario', 'dscenario_id', 'int4', 'Column dscenario_id should be int4');
SELECT col_type_is('cat_dscenario', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('cat_dscenario', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_dscenario', 'parent_id', 'int4', 'Column parent_id should be int4');
SELECT col_type_is('cat_dscenario', 'dscenario_type', 'text', 'Column dscenario_type should be text');
SELECT col_type_is('cat_dscenario', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_dscenario', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('cat_dscenario', 'log', 'text', 'Column log should be text');

-- Check foreign keys
SELECT has_fk('cat_dscenario', 'Table cat_dscenario should have foreign keys');

SELECT fk_ok('cat_dscenario', 'parent_id', 'cat_dscenario', 'dscenario_id', 'FK parent_id → cat_dscenario.dscenario_id');
SELECT fk_ok('cat_dscenario', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id → exploitation.expl_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
