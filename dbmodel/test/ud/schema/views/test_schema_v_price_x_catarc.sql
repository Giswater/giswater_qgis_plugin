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

-- Check view v_price_x_catarc
SELECT has_view('v_price_x_catarc'::name, 'View v_price_x_catarc should exist');

-- Check view columns
SELECT columns_are(
    'v_price_x_catarc',
    ARRAY[
        'id', 'geom1', 'z1', 'z2', 'width', 'area',
        'thickness', 'estimated_depth', 'cost_unit', 'cost', 'm2bottom_cost', 'm3protec_cost'
    ],
    'View v_price_x_catarc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_price_x_catarc', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('v_price_x_catarc', 'geom1', 'numeric(12,4)', 'Column geom1 should be numeric(12,4)');
SELECT col_type_is('v_price_x_catarc', 'z1', 'numeric(12,2)', 'Column z1 should be numeric(12,2)');
SELECT col_type_is('v_price_x_catarc', 'z2', 'numeric(12,2)', 'Column z2 should be numeric(12,2)');
SELECT col_type_is('v_price_x_catarc', 'width', 'numeric(12,2)', 'Column width should be numeric(12,2)');
SELECT col_type_is('v_price_x_catarc', 'area', 'numeric(12,4)', 'Column area should be numeric(12,4)');
SELECT col_type_is('v_price_x_catarc', 'thickness', 'numeric(12,2)', 'Column thickness should be numeric(12,2)');
SELECT col_type_is('v_price_x_catarc', 'estimated_depth', 'numeric(12,2)', 'Column estimated_depth should be numeric(12,2)');
SELECT col_type_is('v_price_x_catarc', 'cost_unit', 'varchar(3)', 'Column cost_unit should be varchar(3)');
SELECT col_type_is('v_price_x_catarc', 'cost', 'numeric(14,2)', 'Column cost should be numeric(14,2)');
SELECT col_type_is('v_price_x_catarc', 'm2bottom_cost', 'numeric(14,2)', 'Column m2bottom_cost should be numeric(14,2)');
SELECT col_type_is('v_price_x_catarc', 'm3protec_cost', 'numeric(14,2)', 'Column m3protec_cost should be numeric(14,2)');

SELECT * FROM finish();

ROLLBACK;
