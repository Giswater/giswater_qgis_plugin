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

-- Check view v_plan_psector_budget_other
SELECT has_view('v_plan_psector_budget_other'::name, 'View v_plan_psector_budget_other should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_psector_budget_other',
    ARRAY[
        'id', 'psector_id', 'psector_type', 'price_id', 'descript', 'price',
        'measurement', 'total_budget', 'priority'
    ],
    'View v_plan_psector_budget_other should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_psector_budget_other', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_plan_psector_budget_other', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('v_plan_psector_budget_other', 'psector_type', 'int4', 'Column psector_type should be int4');
SELECT col_type_is('v_plan_psector_budget_other', 'price_id', 'varchar(16)', 'Column price_id should be varchar(16)');
SELECT col_type_is('v_plan_psector_budget_other', 'descript', 'varchar(100)', 'Column descript should be varchar(100)');
SELECT col_type_is('v_plan_psector_budget_other', 'price', 'numeric(14,2)', 'Column price should be numeric(14,2)');
SELECT col_type_is('v_plan_psector_budget_other', 'measurement', 'numeric(12,2)', 'Column measurement should be numeric(12,2)');
SELECT col_type_is('v_plan_psector_budget_other', 'total_budget', 'numeric(14,2)', 'Column total_budget should be numeric(14,2)');
SELECT col_type_is('v_plan_psector_budget_other', 'priority', 'varchar(16)', 'Column priority should be varchar(16)');

SELECT * FROM finish();

ROLLBACK;
