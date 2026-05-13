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
SELECT has_table('inp_hydrograph'::name, 'Table inp_hydrograph should exist');

-- Check columns
SELECT columns_are(
    'inp_hydrograph',
    ARRAY[
        'id'
    ],
    'Table inp_hydrograph should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_hydrograph', 'id', 'varchar(16)', 'Column id should be varchar(16)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
