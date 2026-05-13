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
SELECT has_table('inp_dwf'::name, 'Table inp_dwf should exist');

-- Check columns
SELECT columns_are(
    'inp_dwf',
    ARRAY[
        'node_id', 'value', 'pat1', 'pat2', 'pat3', 'pat4',
        'dwfscenario_id'
    ],
    'Table inp_dwf should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_dwf', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('inp_dwf', 'value', 'numeric(12,7)', 'Column value should be numeric(12,7)');
SELECT col_type_is('inp_dwf', 'pat1', 'varchar(16)', 'Column pat1 should be varchar(16)');
SELECT col_type_is('inp_dwf', 'pat2', 'varchar(16)', 'Column pat2 should be varchar(16)');
SELECT col_type_is('inp_dwf', 'pat3', 'varchar(16)', 'Column pat3 should be varchar(16)');
SELECT col_type_is('inp_dwf', 'pat4', 'varchar(16)', 'Column pat4 should be varchar(16)');
SELECT col_type_is('inp_dwf', 'dwfscenario_id', 'int4', 'Column dwfscenario_id should be int4');

-- Check foreign keys
SELECT has_fk('inp_dwf', 'Table inp_dwf should have foreign keys');

SELECT fk_ok('inp_dwf', 'dwfscenario_id', 'cat_dwf', 'id', 'FK dwfscenario_id → cat_dwf.id');
SELECT fk_ok('inp_dwf', 'pat1', 'inp_pattern', 'pattern_id', 'FK pat1 → inp_pattern.pattern_id');
SELECT fk_ok('inp_dwf', 'pat2', 'inp_pattern', 'pattern_id', 'FK pat2 → inp_pattern.pattern_id');
SELECT fk_ok('inp_dwf', 'pat3', 'inp_pattern', 'pattern_id', 'FK pat3 → inp_pattern.pattern_id');
SELECT fk_ok('inp_dwf', 'pat4', 'inp_pattern', 'pattern_id', 'FK pat4 → inp_pattern.pattern_id');
SELECT fk_ok('inp_dwf', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
