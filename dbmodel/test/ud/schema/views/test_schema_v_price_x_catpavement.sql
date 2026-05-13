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

-- Check view v_price_x_catpavement
SELECT has_view('v_price_x_catpavement'::name, 'View v_price_x_catpavement should exist');

-- Check view columns
SELECT columns_are(
    'v_price_x_catpavement',
    ARRAY[
        'pavcat_id', 'thickness', 'm2pav_cost'
    ],
    'View v_price_x_catpavement should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_price_x_catpavement', 'pavcat_id', 'varchar(30)', 'Column pavcat_id should be varchar(30)');
SELECT col_type_is('v_price_x_catpavement', 'thickness', 'numeric(12,2)', 'Column thickness should be numeric(12,2)');
SELECT col_type_is('v_price_x_catpavement', 'm2pav_cost', 'numeric(14,2)', 'Column m2pav_cost should be numeric(14,2)');

SELECT * FROM finish();

ROLLBACK;
