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

-- Check table man_source
SELECT has_table('man_source'::name, 'Table man_source should exist');

-- Check columns
SELECT columns_are(
    'man_source',
    ARRAY[
        'node_id', 'name', 'source_type', 'source_code', 'aquifer_type', 'aquifer_name', 'wtp_id', 'registered_flow', 'auth_code', 'basin_id', 'subbasin_id', 'inlet_arc'
    ],
    'Table man_source should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_source', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_source', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('man_source', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('man_source', 'source_type', 'integer', 'Column source_type should be integer');
SELECT col_type_is('man_source', 'source_code', 'text', 'Column source_code should be text');
SELECT col_type_is('man_source', 'aquifer_type', 'integer', 'Column aquifer_type should be integer');
SELECT col_type_is('man_source', 'aquifer_name', 'text', 'Column aquifer_name should be text');
SELECT col_type_is('man_source', 'wtp_id', 'varchar(16)', 'Column wtp_id should be varchar(16)');
SELECT col_type_is('man_source', 'registered_flow', 'double precision', 'Column registered_flow should be double precision');
SELECT col_type_is('man_source', 'auth_code', 'text', 'Column auth_code should be text');
SELECT col_type_is('man_source', 'basin_id', 'integer', 'Column basin_id should be integer');
SELECT col_type_is('man_source', 'subbasin_id', 'integer', 'Column subbasin_id should be integer');
SELECT col_type_is('man_source', 'inlet_arc', 'integer[]', 'Column inlet_arc should be integer[]');

-- Check not null constraints
SELECT col_not_null('man_source', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_not_null('man_source', 'source_type', 'Column source_type should be NOT NULL');
SELECT col_not_null('man_source', 'aquifer_type', 'Column aquifer_type should be NOT NULL');
SELECT col_not_null('man_source', 'basin_id', 'Column basin_id should be NOT NULL');
SELECT col_not_null('man_source', 'subbasin_id', 'Column subbasin_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_source', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');
SELECT fk_ok('man_source', 'wtp_id', 'man_wtp', 'node_id', 'FK wtp_id should reference man_wtp.node_id');

-- Check triggers
SELECT has_trigger('man_source', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('man_source', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');

SELECT * FROM finish();

ROLLBACK;