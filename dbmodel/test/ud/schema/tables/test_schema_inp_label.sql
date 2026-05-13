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
SELECT has_table('inp_label'::name, 'Table inp_label should exist');

-- Check columns
SELECT columns_are(
    'inp_label',
    ARRAY[
        'label', 'xcoord', 'ycoord', 'anchor', 'font', 'size',
        'bold', 'italic'
    ],
    'Table inp_label should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_label', 'label', 'text', 'Column label should be text');
SELECT col_type_is('inp_label', 'xcoord', 'numeric(18,6)', 'Column xcoord should be numeric(18,6)');
SELECT col_type_is('inp_label', 'ycoord', 'numeric(18,6)', 'Column ycoord should be numeric(18,6)');
SELECT col_type_is('inp_label', 'anchor', 'varchar(16)', 'Column anchor should be varchar(16)');
SELECT col_type_is('inp_label', 'font', 'varchar(50)', 'Column font should be varchar(50)');
SELECT col_type_is('inp_label', 'size', 'int4', 'Column size should be int4');
SELECT col_type_is('inp_label', 'bold', 'varchar(3)', 'Column bold should be varchar(3)');
SELECT col_type_is('inp_label', 'italic', 'varchar(3)', 'Column italic should be varchar(3)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
