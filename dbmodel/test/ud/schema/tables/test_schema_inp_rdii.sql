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
SELECT has_table('inp_rdii'::name, 'Table inp_rdii should exist');

-- Check columns
SELECT columns_are(
    'inp_rdii',
    ARRAY[
        'node_id', 'hydro_id', 'sewerarea'
    ],
    'Table inp_rdii should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_rdii', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('inp_rdii', 'hydro_id', 'varchar(16)', 'Column hydro_id should be varchar(16)');
SELECT col_type_is('inp_rdii', 'sewerarea', 'numeric(16,6)', 'Column sewerarea should be numeric(16,6)');

-- Check foreign keys
SELECT has_fk('inp_rdii', 'Table inp_rdii should have foreign keys');

SELECT fk_ok('inp_rdii', 'hydro_id', 'inp_hydrograph', 'id', 'FK hydro_id → inp_hydrograph.id');
SELECT fk_ok('inp_rdii', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
