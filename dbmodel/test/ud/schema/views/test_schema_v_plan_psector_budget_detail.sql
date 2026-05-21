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

-- Check view v_plan_psector_budget_detail
SELECT has_view('v_plan_psector_budget_detail'::name, 'View v_plan_psector_budget_detail should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_psector_budget_detail',
    ARRAY[
        'arc_id', 'psector_id', 'arccat_id', 'soilcat_id', 'y1', 'y2',
        'mlarc_cost', 'm3mlexc', 'mlexc_cost', 'm2mltrenchl', 'mltrench_cost', 'm2mlbase',
        'mlbase_cost', 'm2mlpav', 'mlpav_cost', 'm3mlprotec', 'mlprotec_cost', 'm3mlfill',
        'mlfill_cost', 'm3mlexcess', 'mlexcess_cost', 'mltotal_cost', 'length', 'other_budget',
        'total_budget'
    ],
    'View v_plan_psector_budget_detail should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_psector_budget_detail', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_plan_psector_budget_detail', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('v_plan_psector_budget_detail', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('v_plan_psector_budget_detail', 'soilcat_id', 'varchar(30)', 'Column soilcat_id should be varchar(30)');
SELECT col_type_is('v_plan_psector_budget_detail', 'y1', 'numeric(12,3)', 'Column y1 should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'y2', 'numeric(12,3)', 'Column y2 should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'mlarc_cost', 'numeric(12,3)', 'Column mlarc_cost should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'm3mlexc', 'numeric(12,3)', 'Column m3mlexc should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'mlexc_cost', 'numeric(12,3)', 'Column mlexc_cost should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'm2mltrenchl', 'numeric(12,3)', 'Column m2mltrenchl should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'mltrench_cost', 'numeric(12,3)', 'Column mltrench_cost should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'm2mlbase', 'numeric(12,3)', 'Column m2mlbase should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'mlbase_cost', 'numeric(12,3)', 'Column mlbase_cost should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'm2mlpav', 'numeric(12,3)', 'Column m2mlpav should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'mlpav_cost', 'numeric(12,3)', 'Column mlpav_cost should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'm3mlprotec', 'numeric(12,3)', 'Column m3mlprotec should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'mlprotec_cost', 'numeric(12,3)', 'Column mlprotec_cost should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'm3mlfill', 'numeric(12,3)', 'Column m3mlfill should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'mlfill_cost', 'numeric(12,3)', 'Column mlfill_cost should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'm3mlexcess', 'numeric(12,3)', 'Column m3mlexcess should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'mlexcess_cost', 'numeric(12,3)', 'Column mlexcess_cost should be numeric(12,3)');
SELECT col_type_is('v_plan_psector_budget_detail', 'mltotal_cost', 'numeric(12,2)', 'Column mltotal_cost should be numeric(12,2)');
SELECT col_type_is('v_plan_psector_budget_detail', 'length', 'numeric(12,2)', 'Column length should be numeric(12,2)');
SELECT col_type_is('v_plan_psector_budget_detail', 'other_budget', 'numeric(14,2)', 'Column other_budget should be numeric(14,2)');
SELECT col_type_is('v_plan_psector_budget_detail', 'total_budget', 'numeric(14,2)', 'Column total_budget should be numeric(14,2)');

SELECT * FROM finish();

ROLLBACK;
