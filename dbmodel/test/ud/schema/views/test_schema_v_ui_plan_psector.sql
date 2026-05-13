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

-- Check view v_ui_plan_psector
SELECT has_view('v_ui_plan_psector'::name, 'View v_ui_plan_psector should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_plan_psector',
    ARRAY[
        'psector_id', 'ext_code', 'name', 'descript', 'priority', 'status',
        'text1', 'text2', 'observ', 'vat', 'other', 'expl_id',
        'psector_type', 'active', 'archived', 'workcat_id', 'workcat_id_plan', 'parent_id',
        'creation_date'
    ],
    'View v_ui_plan_psector should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_plan_psector', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('v_ui_plan_psector', 'ext_code', 'text', 'Column ext_code should be text');
SELECT col_type_is('v_ui_plan_psector', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('v_ui_plan_psector', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('v_ui_plan_psector', 'priority', 'text', 'Column priority should be text');
SELECT col_type_is('v_ui_plan_psector', 'status', 'text', 'Column status should be text');
SELECT col_type_is('v_ui_plan_psector', 'text1', 'text', 'Column text1 should be text');
SELECT col_type_is('v_ui_plan_psector', 'text2', 'text', 'Column text2 should be text');
SELECT col_type_is('v_ui_plan_psector', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('v_ui_plan_psector', 'vat', 'numeric(4,2)', 'Column vat should be numeric(4,2)');
SELECT col_type_is('v_ui_plan_psector', 'other', 'numeric(4,2)', 'Column other should be numeric(4,2)');
SELECT col_type_is('v_ui_plan_psector', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_ui_plan_psector', 'psector_type', 'text', 'Column psector_type should be text');
SELECT col_type_is('v_ui_plan_psector', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('v_ui_plan_psector', 'archived', 'bool', 'Column archived should be bool');
SELECT col_type_is('v_ui_plan_psector', 'workcat_id', 'text', 'Column workcat_id should be text');
SELECT col_type_is('v_ui_plan_psector', 'workcat_id_plan', 'text', 'Column workcat_id_plan should be text');
SELECT col_type_is('v_ui_plan_psector', 'parent_id', 'int4', 'Column parent_id should be int4');
SELECT col_type_is('v_ui_plan_psector', 'creation_date', 'date', 'Column creation_date should be date');

SELECT * FROM finish();

ROLLBACK;
