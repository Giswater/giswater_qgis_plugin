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

-- Check view v_price_compost
SELECT has_view('v_price_compost'::name, 'View v_price_compost should exist');

-- Check view columns
SELECT columns_are(
    'v_price_compost',
    ARRAY[
        'id', 'unit', 'descript', 'price'
    ],
    'View v_price_compost should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_price_compost', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('v_price_compost', 'unit', 'varchar(5)', 'Column unit should be varchar(5)');
SELECT col_type_is('v_price_compost', 'descript', 'varchar(100)', 'Column descript should be varchar(100)');
SELECT col_type_is('v_price_compost', 'price', 'numeric(14,2)', 'Column price should be numeric(14,2)');

SELECT * FROM finish();

ROLLBACK;
