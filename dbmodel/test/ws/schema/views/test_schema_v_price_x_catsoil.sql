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

-- Check view v_price_x_catsoil
SELECT has_view('v_price_x_catsoil'::name, 'View v_price_x_catsoil should exist');

-- Check view columns
SELECT columns_are(
    'v_price_x_catsoil',
    ARRAY[
        'id', 'y_param', 'b', 'trenchlining', 'm3exc_cost', 'm3fill_cost',
        'm3excess_cost', 'm2trenchl_cost'
    ],
    'View v_price_x_catsoil should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_price_x_catsoil', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('v_price_x_catsoil', 'y_param', 'numeric(5,2)', 'Column y_param should be numeric(5,2)');
SELECT col_type_is('v_price_x_catsoil', 'b', 'numeric(5,2)', 'Column b should be numeric(5,2)');
SELECT col_type_is('v_price_x_catsoil', 'trenchlining', 'numeric(3,2)', 'Column trenchlining should be numeric(3,2)');
SELECT col_type_is('v_price_x_catsoil', 'm3exc_cost', 'numeric(14,2)', 'Column m3exc_cost should be numeric(14,2)');
SELECT col_type_is('v_price_x_catsoil', 'm3fill_cost', 'numeric(14,2)', 'Column m3fill_cost should be numeric(14,2)');
SELECT col_type_is('v_price_x_catsoil', 'm3excess_cost', 'numeric(14,2)', 'Column m3excess_cost should be numeric(14,2)');
SELECT col_type_is('v_price_x_catsoil', 'm2trenchl_cost', 'numeric(14,2)', 'Column m2trenchl_cost should be numeric(14,2)');

SELECT * FROM finish();

ROLLBACK;
