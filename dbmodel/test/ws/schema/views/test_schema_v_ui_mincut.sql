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

-- Check view v_ui_mincut
SELECT has_view('v_ui_mincut'::name, 'View v_ui_mincut should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_mincut',
    ARRAY[
        'id', 'work_order', 'state', 'class', 'mincut_type', 'received_date',
        'exploitation', 'municipality', 'postcode', 'streetaxis', 'postnumber', 'anl_cause',
        'anl_tstamp', 'anl_user', 'anl_descript', 'anl_feature_id', 'anl_feature_type', 'forecast_start',
        'forecast_end', 'assigned_to', 'exec_start', 'exec_end', 'exec_user', 'exec_descript',
        'exec_from_plot', 'exec_depth', 'exec_appropiate', 'chlorine', 'turbidity', 'notified',
        'output', 'reagent_lot', 'equipment_code', 'shutoff_required'
    ],
    'View v_ui_mincut should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_mincut', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_ui_mincut', 'work_order', 'varchar(50)', 'Column work_order should be varchar(50)');
SELECT col_type_is('v_ui_mincut', 'state', 'text', 'Column state should be text');
SELECT col_type_is('v_ui_mincut', 'class', 'text', 'Column class should be text');
SELECT col_type_is('v_ui_mincut', 'mincut_type', 'varchar(30)', 'Column mincut_type should be varchar(30)');
SELECT col_type_is('v_ui_mincut', 'received_date', 'date', 'Column received_date should be date');
SELECT col_type_is('v_ui_mincut', 'exploitation', 'varchar(100)', 'Column exploitation should be varchar(100)');
SELECT col_type_is('v_ui_mincut', 'municipality', 'text', 'Column municipality should be text');
SELECT col_type_is('v_ui_mincut', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('v_ui_mincut', 'streetaxis', 'varchar(100)', 'Column streetaxis should be varchar(100)');
SELECT col_type_is('v_ui_mincut', 'postnumber', 'varchar(16)', 'Column postnumber should be varchar(16)');
SELECT col_type_is('v_ui_mincut', 'anl_cause', 'text', 'Column anl_cause should be text');
SELECT col_type_is('v_ui_mincut', 'anl_tstamp', 'timestamp without time zone', 'Column anl_tstamp should be timestamp without time zone');
SELECT col_type_is('v_ui_mincut', 'anl_user', 'varchar(30)', 'Column anl_user should be varchar(30)');
SELECT col_type_is('v_ui_mincut', 'anl_descript', 'text', 'Column anl_descript should be text');
SELECT col_type_is('v_ui_mincut', 'anl_feature_id', 'int4', 'Column anl_feature_id should be int4');
SELECT col_type_is('v_ui_mincut', 'anl_feature_type', 'varchar(16)', 'Column anl_feature_type should be varchar(16)');
SELECT col_type_is('v_ui_mincut', 'forecast_start', 'timestamp without time zone', 'Column forecast_start should be timestamp without time zone');
SELECT col_type_is('v_ui_mincut', 'forecast_end', 'timestamp without time zone', 'Column forecast_end should be timestamp without time zone');
SELECT col_type_is('v_ui_mincut', 'assigned_to', 'varchar(150)', 'Column assigned_to should be varchar(150)');
SELECT col_type_is('v_ui_mincut', 'exec_start', 'timestamp without time zone', 'Column exec_start should be timestamp without time zone');
SELECT col_type_is('v_ui_mincut', 'exec_end', 'timestamp without time zone', 'Column exec_end should be timestamp without time zone');
SELECT col_type_is('v_ui_mincut', 'exec_user', 'varchar(30)', 'Column exec_user should be varchar(30)');
SELECT col_type_is('v_ui_mincut', 'exec_descript', 'text', 'Column exec_descript should be text');
SELECT col_type_is('v_ui_mincut', 'exec_from_plot', 'float8', 'Column exec_from_plot should be float8');
SELECT col_type_is('v_ui_mincut', 'exec_depth', 'float8', 'Column exec_depth should be float8');
SELECT col_type_is('v_ui_mincut', 'exec_appropiate', 'bool', 'Column exec_appropiate should be bool');
SELECT col_type_is('v_ui_mincut', 'chlorine', 'varchar(30)', 'Column chlorine should be varchar(30)');
SELECT col_type_is('v_ui_mincut', 'turbidity', 'varchar(30)', 'Column turbidity should be varchar(30)');
SELECT col_type_is('v_ui_mincut', 'notified', 'json', 'Column notified should be json');
SELECT col_type_is('v_ui_mincut', 'output', 'json', 'Column output should be json');
SELECT col_type_is('v_ui_mincut', 'reagent_lot', 'varchar(100)', 'Column reagent_lot should be varchar(100)');
SELECT col_type_is('v_ui_mincut', 'equipment_code', 'varchar(50)', 'Column equipment_code should be varchar(50)');
SELECT col_type_is('v_ui_mincut', 'shutoff_required', 'bool', 'Column shutoff_required should be bool');

SELECT * FROM finish();

ROLLBACK;
