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

-- Check view v_ui_plan_node_cost
SELECT has_view('v_ui_plan_node_cost'::name, 'View v_ui_plan_node_cost should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_plan_node_cost',
    ARRAY[
        'node_id', 'orderby', 'identif', 'catalog_id', 'price_id', 'unit',
        'descript', 'cost', 'measurement', 'total_cost', 'length'
    ],
    'View v_ui_plan_node_cost should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_plan_node_cost', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('v_ui_plan_node_cost', 'orderby', 'int4', 'Column orderby should be int4');
SELECT col_type_is('v_ui_plan_node_cost', 'identif', 'text', 'Column identif should be text');
SELECT col_type_is('v_ui_plan_node_cost', 'catalog_id', 'varchar(30)', 'Column catalog_id should be varchar(30)');
SELECT col_type_is('v_ui_plan_node_cost', 'price_id', 'varchar(16)', 'Column price_id should be varchar(16)');
SELECT col_type_is('v_ui_plan_node_cost', 'unit', 'varchar(5)', 'Column unit should be varchar(5)');
SELECT col_type_is('v_ui_plan_node_cost', 'descript', 'varchar(100)', 'Column descript should be varchar(100)');
SELECT col_type_is('v_ui_plan_node_cost', 'cost', 'numeric(14,2)', 'Column cost should be numeric(14,2)');
SELECT col_type_is('v_ui_plan_node_cost', 'measurement', 'int4', 'Column measurement should be int4');
SELECT col_type_is('v_ui_plan_node_cost', 'total_cost', 'numeric', 'Column total_cost should be numeric');
SELECT col_type_is('v_ui_plan_node_cost', 'length', 'float8', 'Column length should be float8');

SELECT * FROM finish();

ROLLBACK;
