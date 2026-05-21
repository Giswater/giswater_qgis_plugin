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

-- Check view v_plan_psector_budget
SELECT has_view('v_plan_psector_budget'::name, 'View v_plan_psector_budget should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_psector_budget',
    ARRAY[
        'rid', 'psector_id', 'feature_type', 'featurecat_id', 'feature_id', 'length',
        'unitary_cost', 'total_budget'
    ],
    'View v_plan_psector_budget should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_psector_budget', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('v_plan_psector_budget', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('v_plan_psector_budget', 'feature_type', 'text', 'Column feature_type should be text');
SELECT col_type_is('v_plan_psector_budget', 'featurecat_id', 'varchar', 'Column featurecat_id should be varchar');
SELECT col_type_is('v_plan_psector_budget', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('v_plan_psector_budget', 'length', 'numeric', 'Column length should be numeric');
SELECT col_type_is('v_plan_psector_budget', 'unitary_cost', 'numeric', 'Column unitary_cost should be numeric');
SELECT col_type_is('v_plan_psector_budget', 'total_budget', 'numeric', 'Column total_budget should be numeric');

SELECT * FROM finish();

ROLLBACK;
