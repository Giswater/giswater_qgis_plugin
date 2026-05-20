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

-- Check view v_ui_plan_arc_cost
SELECT has_view('v_ui_plan_arc_cost'::name, 'View v_ui_plan_arc_cost should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_plan_arc_cost',
    ARRAY[
        'arc_id', 'orderby', 'identif', 'catalog_id', 'price_id', 'unit',
        'descript', 'cost', 'measurement', 'total_cost', 'length'
    ],
    'View v_ui_plan_arc_cost should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_plan_arc_cost', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_ui_plan_arc_cost', 'orderby', 'int4', 'Column orderby should be int4');
SELECT col_type_is('v_ui_plan_arc_cost', 'identif', 'text', 'Column identif should be text');
SELECT col_type_is('v_ui_plan_arc_cost', 'catalog_id', 'varchar', 'Column catalog_id should be varchar');
SELECT col_type_is('v_ui_plan_arc_cost', 'price_id', 'varchar', 'Column price_id should be varchar');
SELECT col_type_is('v_ui_plan_arc_cost', 'unit', 'varchar', 'Column unit should be varchar');
SELECT col_type_is('v_ui_plan_arc_cost', 'descript', 'varchar', 'Column descript should be varchar');
SELECT col_type_is('v_ui_plan_arc_cost', 'cost', 'numeric', 'Column cost should be numeric');
SELECT col_type_is('v_ui_plan_arc_cost', 'measurement', 'numeric', 'Column measurement should be numeric');
SELECT col_type_is('v_ui_plan_arc_cost', 'total_cost', 'numeric', 'Column total_cost should be numeric');
SELECT col_type_is('v_ui_plan_arc_cost', 'length', 'numeric(12,2)', 'Column length should be numeric(12,2)');

SELECT * FROM finish();

ROLLBACK;
