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
SELECT has_table('inp_froutlet'::name, 'Table inp_froutlet should exist');

-- Check columns
SELECT columns_are(
    'inp_froutlet',
    ARRAY[
        'element_id', 'outlet_type', 'offsetval', 'curve_id', 'cd1', 'cd2',
        'flap'
    ],
    'Table inp_froutlet should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_froutlet', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('inp_froutlet', 'outlet_type', 'varchar(16)', 'Column outlet_type should be varchar(16)');
SELECT col_type_is('inp_froutlet', 'offsetval', 'numeric(12,4)', 'Column offsetval should be numeric(12,4)');
SELECT col_type_is('inp_froutlet', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('inp_froutlet', 'cd1', 'numeric(12,4)', 'Column cd1 should be numeric(12,4)');
SELECT col_type_is('inp_froutlet', 'cd2', 'numeric(12,4)', 'Column cd2 should be numeric(12,4)');
SELECT col_type_is('inp_froutlet', 'flap', 'varchar(3)', 'Column flap should be varchar(3)');

-- Check foreign keys
SELECT has_fk('inp_froutlet', 'Table inp_froutlet should have foreign keys');

SELECT fk_ok('inp_froutlet', 'element_id', 'element', 'element_id', 'FK element_id → element.element_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
