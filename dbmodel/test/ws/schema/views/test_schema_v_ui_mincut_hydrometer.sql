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

-- Check view v_ui_mincut_hydrometer
SELECT has_view('v_ui_mincut_hydrometer'::name, 'View v_ui_mincut_hydrometer should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_mincut_hydrometer',
    ARRAY[
        'id', 'hydrometer_id', 'connec_id', 'result_id', 'work_order', 'mincut_state',
        'mincut_class', 'mincut_type', 'received_date', 'anl_cause', 'anl_tstamp', 'anl_user',
        'anl_descript', 'forecast_start', 'forecast_end', 'exec_start', 'exec_end', 'exec_user',
        'exec_descript', 'exec_appropiate', 'start_date', 'end_date', 'shutoff_required'
    ],
    'View v_ui_mincut_hydrometer should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_mincut_hydrometer', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_ui_mincut_hydrometer', 'hydrometer_id', 'int4', 'Column hydrometer_id should be int4');
SELECT col_type_is('v_ui_mincut_hydrometer', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('v_ui_mincut_hydrometer', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('v_ui_mincut_hydrometer', 'work_order', 'varchar(50)', 'Column work_order should be varchar(50)');
SELECT col_type_is('v_ui_mincut_hydrometer', 'mincut_state', 'int2', 'Column mincut_state should be int2');
SELECT col_type_is('v_ui_mincut_hydrometer', 'mincut_class', 'int2', 'Column mincut_class should be int2');
SELECT col_type_is('v_ui_mincut_hydrometer', 'mincut_type', 'varchar(30)', 'Column mincut_type should be varchar(30)');
SELECT col_type_is('v_ui_mincut_hydrometer', 'received_date', 'date', 'Column received_date should be date');
SELECT col_type_is('v_ui_mincut_hydrometer', 'anl_cause', 'varchar(30)', 'Column anl_cause should be varchar(30)');
SELECT col_type_is('v_ui_mincut_hydrometer', 'anl_tstamp', 'timestamp without time zone', 'Column anl_tstamp should be timestamp without time zone');
SELECT col_type_is('v_ui_mincut_hydrometer', 'anl_user', 'varchar(30)', 'Column anl_user should be varchar(30)');
SELECT col_type_is('v_ui_mincut_hydrometer', 'anl_descript', 'text', 'Column anl_descript should be text');
SELECT col_type_is('v_ui_mincut_hydrometer', 'forecast_start', 'timestamp without time zone', 'Column forecast_start should be timestamp without time zone');
SELECT col_type_is('v_ui_mincut_hydrometer', 'forecast_end', 'timestamp without time zone', 'Column forecast_end should be timestamp without time zone');
SELECT col_type_is('v_ui_mincut_hydrometer', 'exec_start', 'timestamp without time zone', 'Column exec_start should be timestamp without time zone');
SELECT col_type_is('v_ui_mincut_hydrometer', 'exec_end', 'timestamp without time zone', 'Column exec_end should be timestamp without time zone');
SELECT col_type_is('v_ui_mincut_hydrometer', 'exec_user', 'varchar(30)', 'Column exec_user should be varchar(30)');
SELECT col_type_is('v_ui_mincut_hydrometer', 'exec_descript', 'text', 'Column exec_descript should be text');
SELECT col_type_is('v_ui_mincut_hydrometer', 'exec_appropiate', 'bool', 'Column exec_appropiate should be bool');
SELECT col_type_is('v_ui_mincut_hydrometer', 'start_date', 'timestamp with time zone', 'Column start_date should be timestamp with time zone');
SELECT col_type_is('v_ui_mincut_hydrometer', 'end_date', 'timestamp with time zone', 'Column end_date should be timestamp with time zone');
SELECT col_type_is('v_ui_mincut_hydrometer', 'shutoff_required', 'bool', 'Column shutoff_required should be bool');

SELECT * FROM finish();

ROLLBACK;
