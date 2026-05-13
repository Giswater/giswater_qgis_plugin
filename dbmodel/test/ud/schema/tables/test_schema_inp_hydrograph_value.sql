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
SELECT has_table('inp_hydrograph_value'::name, 'Table inp_hydrograph_value should exist');

-- Check columns
SELECT columns_are(
    'inp_hydrograph_value',
    ARRAY[
        'id', 'text'
    ],
    'Table inp_hydrograph_value should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_hydrograph_value', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('inp_hydrograph_value', 'text', 'varchar(254)', 'Column text should be varchar(254)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
