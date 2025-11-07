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

-- Check view exists
SELECT has_view('v_ui_mincut'::name, 'View v_ui_mincut should exist');

-- Check view columns
SELECT columns_are('v_ui_mincut', ARRAY[
    'id',
    'work_order',
    'state',
    'class',
    'mincut_type',
    'received_date',
    'exploitation',
    'municipality',
    'postcode',
    'streetaxis',
    'postnumber',
    'anl_cause',
    'anl_tstamp',
    'anl_user',
    'anl_descript',
    'anl_feature_id',
    'anl_feature_type',
    'forecast_start',
    'forecast_end',
    'assigned_to',
    'exec_start',
    'exec_end',
    'exec_user',
    'exec_descript',
    'exec_from_plot',
    'exec_depth',
    'exec_appropiate',
    'chlorine',
    'turbidity',
    'notified',
    'output',
    'reagent_lot',
    'equipment_code'
], 'View v_ui_mincut should have the correct columns');

SELECT * FROM finish();

ROLLBACK;
