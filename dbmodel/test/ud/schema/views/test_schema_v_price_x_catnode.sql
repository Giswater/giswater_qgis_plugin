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

-- Check view v_price_x_catnode
SELECT has_view('v_price_x_catnode'::name, 'View v_price_x_catnode should exist');

-- Check view columns
SELECT columns_are(
    'v_price_x_catnode',
    ARRAY[
        'id', 'estimated_y', 'cost_unit', 'cost'
    ],
    'View v_price_x_catnode should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_price_x_catnode', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('v_price_x_catnode', 'estimated_y', 'numeric(12,2)', 'Column estimated_y should be numeric(12,2)');
SELECT col_type_is('v_price_x_catnode', 'cost_unit', 'varchar(3)', 'Column cost_unit should be varchar(3)');
SELECT col_type_is('v_price_x_catnode', 'cost', 'numeric(14,2)', 'Column cost should be numeric(14,2)');

SELECT * FROM finish();

ROLLBACK;
