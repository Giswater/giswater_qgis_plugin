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
SELECT has_table('inp_groundwater'::name, 'Table inp_groundwater should exist');

-- Check columns
SELECT columns_are(
    'inp_groundwater',
    ARRAY[
        'subc_id', 'aquif_id', 'node_id', 'surfel', 'a1', 'b1',
        'a2', 'b2', 'a3', 'tw', 'h', 'fl_eq_lat',
        'fl_eq_deep', 'hydrology_id'
    ],
    'Table inp_groundwater should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_groundwater', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('inp_groundwater', 'aquif_id', 'varchar(16)', 'Column aquif_id should be varchar(16)');
SELECT col_type_is('inp_groundwater', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('inp_groundwater', 'surfel', 'numeric(10,4)', 'Column surfel should be numeric(10,4)');
SELECT col_type_is('inp_groundwater', 'a1', 'numeric(10,4)', 'Column a1 should be numeric(10,4)');
SELECT col_type_is('inp_groundwater', 'b1', 'numeric(10,4)', 'Column b1 should be numeric(10,4)');
SELECT col_type_is('inp_groundwater', 'a2', 'numeric(10,4)', 'Column a2 should be numeric(10,4)');
SELECT col_type_is('inp_groundwater', 'b2', 'numeric(10,4)', 'Column b2 should be numeric(10,4)');
SELECT col_type_is('inp_groundwater', 'a3', 'numeric(10,4)', 'Column a3 should be numeric(10,4)');
SELECT col_type_is('inp_groundwater', 'tw', 'numeric(10,4)', 'Column tw should be numeric(10,4)');
SELECT col_type_is('inp_groundwater', 'h', 'numeric(10,4)', 'Column h should be numeric(10,4)');
SELECT col_type_is('inp_groundwater', 'fl_eq_lat', 'varchar(50)', 'Column fl_eq_lat should be varchar(50)');
SELECT col_type_is('inp_groundwater', 'fl_eq_deep', 'varchar(50)', 'Column fl_eq_deep should be varchar(50)');
SELECT col_type_is('inp_groundwater', 'hydrology_id', 'int4', 'Column hydrology_id should be int4');

-- Check foreign keys
SELECT has_fk('inp_groundwater', 'Table inp_groundwater should have foreign keys');

SELECT fk_ok('inp_groundwater', 'aquif_id', 'inp_aquifer', 'aquif_id', 'FK aquif_id → inp_aquifer.aquif_id');
SELECT fk_ok('inp_groundwater', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
