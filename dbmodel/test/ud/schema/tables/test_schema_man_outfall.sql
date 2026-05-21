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
SELECT has_table('man_outfall'::name, 'Table man_outfall should exist');

-- Check columns
SELECT columns_are(
    'man_outfall',
    ARRAY[
        'node_id', 'name', 'outfall_medium'
    ],
    'Table man_outfall should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_outfall', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_outfall', 'name', 'varchar(255)', 'Column name should be varchar(255)');
SELECT col_type_is('man_outfall', 'outfall_medium', 'int4', 'Column outfall_medium should be int4');

-- Check foreign keys
SELECT has_fk('man_outfall', 'Table man_outfall should have foreign keys');

SELECT fk_ok('man_outfall', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
