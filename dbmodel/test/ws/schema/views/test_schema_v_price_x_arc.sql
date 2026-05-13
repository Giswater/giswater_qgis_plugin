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

-- Check view v_price_x_arc
SELECT has_view('v_price_x_arc'::name, 'View v_price_x_arc should exist');

-- Check view columns
SELECT columns_are(
    'v_price_x_arc',
    ARRAY[
        'arc_id', 'catalog_id', 'price_id', 'unit', 'descript', 'cost',
        'identif'
    ],
    'View v_price_x_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_price_x_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_price_x_arc', 'catalog_id', 'varchar(30)', 'Column catalog_id should be varchar(30)');
SELECT col_type_is('v_price_x_arc', 'price_id', 'varchar(16)', 'Column price_id should be varchar(16)');
SELECT col_type_is('v_price_x_arc', 'unit', 'varchar(5)', 'Column unit should be varchar(5)');
SELECT col_type_is('v_price_x_arc', 'descript', 'varchar(100)', 'Column descript should be varchar(100)');
SELECT col_type_is('v_price_x_arc', 'cost', 'numeric(14,2)', 'Column cost should be numeric(14,2)');
SELECT col_type_is('v_price_x_arc', 'identif', 'text', 'Column identif should be text');

SELECT * FROM finish();

ROLLBACK;
