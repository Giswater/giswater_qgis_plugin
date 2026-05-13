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

-- Check view v_om_mincut_current_hydrometer
SELECT has_view('v_om_mincut_current_hydrometer'::name, 'View v_om_mincut_current_hydrometer should exist');

-- Check view columns
SELECT columns_are(
    'v_om_mincut_current_hydrometer',
    ARRAY[
        'id', 'result_id', 'work_order', 'hydrometer_id', 'hydrometer_customer_code', 'connec_id',
        'connec_code'
    ],
    'View v_om_mincut_current_hydrometer should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_om_mincut_current_hydrometer', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_om_mincut_current_hydrometer', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('v_om_mincut_current_hydrometer', 'work_order', 'varchar(50)', 'Column work_order should be varchar(50)');
SELECT col_type_is('v_om_mincut_current_hydrometer', 'hydrometer_id', 'int4', 'Column hydrometer_id should be int4');
SELECT col_type_is('v_om_mincut_current_hydrometer', 'hydrometer_customer_code', 'text', 'Column hydrometer_customer_code should be text');
SELECT col_type_is('v_om_mincut_current_hydrometer', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('v_om_mincut_current_hydrometer', 'connec_code', 'text', 'Column connec_code should be text');

SELECT * FROM finish();

ROLLBACK;
