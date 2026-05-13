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
SELECT has_table('man_source'::name, 'Table man_source should exist');

-- Check columns
SELECT columns_are(
    'man_source',
    ARRAY[
        'node_id', 'name', 'source_type', 'source_code', 'aquifer_type', 'aquifer_name',
        'wtp_id', 'registered_flow', 'auth_code', 'basin_id', 'subbasin_id', 'inlet_arc'
    ],
    'Table man_source should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_source', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_source', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('man_source', 'source_type', 'int4', 'Column source_type should be int4');
SELECT col_type_is('man_source', 'source_code', 'text', 'Column source_code should be text');
SELECT col_type_is('man_source', 'aquifer_type', 'int4', 'Column aquifer_type should be int4');
SELECT col_type_is('man_source', 'aquifer_name', 'text', 'Column aquifer_name should be text');
SELECT col_type_is('man_source', 'wtp_id', 'int4', 'Column wtp_id should be int4');
SELECT col_type_is('man_source', 'registered_flow', 'float8', 'Column registered_flow should be float8');
SELECT col_type_is('man_source', 'auth_code', 'text', 'Column auth_code should be text');
SELECT col_type_is('man_source', 'basin_id', 'int4', 'Column basin_id should be int4');
SELECT col_type_is('man_source', 'subbasin_id', 'int4', 'Column subbasin_id should be int4');
SELECT col_type_is('man_source', 'inlet_arc', 'int4[]', 'Column inlet_arc should be int4[]');

-- Check foreign keys
SELECT has_fk('man_source', 'Table man_source should have foreign keys');

SELECT fk_ok('man_source', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');
SELECT fk_ok('man_source', 'wtp_id', 'man_wtp', 'node_id', 'FK wtp_id → man_wtp.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
