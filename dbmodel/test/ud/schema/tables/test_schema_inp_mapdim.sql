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
SELECT has_table('inp_mapdim'::name, 'Table inp_mapdim should exist');

-- Check columns
SELECT columns_are(
    'inp_mapdim',
    ARRAY[
        'type_dim', 'x1', 'y1', 'x2', 'y2'
    ],
    'Table inp_mapdim should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_mapdim', 'type_dim', 'varchar(18)', 'Column type_dim should be varchar(18)');
SELECT col_type_is('inp_mapdim', 'x1', 'numeric(18,6)', 'Column x1 should be numeric(18,6)');
SELECT col_type_is('inp_mapdim', 'y1', 'numeric(18,6)', 'Column y1 should be numeric(18,6)');
SELECT col_type_is('inp_mapdim', 'x2', 'numeric(18,6)', 'Column x2 should be numeric(18,6)');
SELECT col_type_is('inp_mapdim', 'y2', 'numeric(18,6)', 'Column y2 should be numeric(18,6)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
