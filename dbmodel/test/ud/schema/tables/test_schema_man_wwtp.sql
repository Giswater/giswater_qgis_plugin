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
SELECT has_table('man_wwtp'::name, 'Table man_wwtp should exist');

-- Check columns
SELECT columns_are(
    'man_wwtp',
    ARRAY[
        'node_id', 'name', 'wwtp_code', 'wwtp_type', 'treatment_type', 'maxflow',
        'opsflow', 'wwtp_function', 'served_hydrometer', 'efficiency', 'sludge_disposition', 'sludge_treatment'
    ],
    'Table man_wwtp should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_wwtp', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('man_wwtp', 'name', 'varchar(255)', 'Column name should be varchar(255)');
SELECT col_type_is('man_wwtp', 'wwtp_code', 'text', 'Column wwtp_code should be text');
SELECT col_type_is('man_wwtp', 'wwtp_type', 'int4', 'Column wwtp_type should be int4');
SELECT col_type_is('man_wwtp', 'treatment_type', 'int4', 'Column treatment_type should be int4');
SELECT col_type_is('man_wwtp', 'maxflow', 'float8', 'Column maxflow should be float8');
SELECT col_type_is('man_wwtp', 'opsflow', 'float8', 'Column opsflow should be float8');
SELECT col_type_is('man_wwtp', 'wwtp_function', 'text', 'Column wwtp_function should be text');
SELECT col_type_is('man_wwtp', 'served_hydrometer', 'int4', 'Column served_hydrometer should be int4');
SELECT col_type_is('man_wwtp', 'efficiency', 'text', 'Column efficiency should be text');
SELECT col_type_is('man_wwtp', 'sludge_disposition', 'bool', 'Column sludge_disposition should be bool');
SELECT col_type_is('man_wwtp', 'sludge_treatment', 'bool', 'Column sludge_treatment should be bool');

-- Check foreign keys
SELECT has_fk('man_wwtp', 'Table man_wwtp should have foreign keys');

SELECT fk_ok('man_wwtp', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
