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
SELECT has_table('inp_loadings'::name, 'Table inp_loadings should exist');

-- Check columns
SELECT columns_are(
    'inp_loadings',
    ARRAY[
        'poll_id', 'subc_id', 'ibuildup', 'hydrology_id'
    ],
    'Table inp_loadings should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_loadings', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('inp_loadings', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('inp_loadings', 'ibuildup', 'numeric(12,4)', 'Column ibuildup should be numeric(12,4)');
SELECT col_type_is('inp_loadings', 'hydrology_id', 'int4', 'Column hydrology_id should be int4');

-- Finish
SELECT * FROM finish();

ROLLBACK;
