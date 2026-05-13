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
SELECT has_table('man_waterwell'::name, 'Table man_waterwell should exist');

-- Check columns
SELECT columns_are(
    'man_waterwell',
    ARRAY[
        'node_id', 'name', 'inlet_arc'
    ],
    'Table man_waterwell should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_waterwell', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_waterwell', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('man_waterwell', 'inlet_arc', 'int4[]', 'Column inlet_arc should be int4[]');

-- Check foreign keys
SELECT has_fk('man_waterwell', 'Table man_waterwell should have foreign keys');

SELECT fk_ok('man_waterwell', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
