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
SELECT has_table('inp_netgully'::name, 'Table inp_netgully should exist');

-- Check columns
SELECT columns_are(
    'inp_netgully',
    ARRAY[
        'node_id', 'y0', 'ysur', 'apond', 'outlet_type', 'custom_width',
        'custom_length', 'custom_depth', 'gully_method', 'weir_cd', 'orifice_cd', 'custom_a_param',
        'custom_b_param', 'efficiency'
    ],
    'Table inp_netgully should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_netgully', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('inp_netgully', 'y0', 'numeric(12,4)', 'Column y0 should be numeric(12,4)');
SELECT col_type_is('inp_netgully', 'ysur', 'numeric(12,4)', 'Column ysur should be numeric(12,4)');
SELECT col_type_is('inp_netgully', 'apond', 'numeric(12,4)', 'Column apond should be numeric(12,4)');
SELECT col_type_is('inp_netgully', 'outlet_type', 'varchar(30)', 'Column outlet_type should be varchar(30)');
SELECT col_type_is('inp_netgully', 'custom_width', 'float8', 'Column custom_width should be float8');
SELECT col_type_is('inp_netgully', 'custom_length', 'float8', 'Column custom_length should be float8');
SELECT col_type_is('inp_netgully', 'custom_depth', 'float8', 'Column custom_depth should be float8');
SELECT col_type_is('inp_netgully', 'gully_method', 'varchar(30)', 'Column gully_method should be varchar(30)');
SELECT col_type_is('inp_netgully', 'weir_cd', 'float8', 'Column weir_cd should be float8');
SELECT col_type_is('inp_netgully', 'orifice_cd', 'float8', 'Column orifice_cd should be float8');
SELECT col_type_is('inp_netgully', 'custom_a_param', 'float8', 'Column custom_a_param should be float8');
SELECT col_type_is('inp_netgully', 'custom_b_param', 'float8', 'Column custom_b_param should be float8');
SELECT col_type_is('inp_netgully', 'efficiency', 'float8', 'Column efficiency should be float8');

-- Check foreign keys
SELECT has_fk('inp_netgully', 'Table inp_netgully should have foreign keys');

SELECT fk_ok('inp_netgully', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
