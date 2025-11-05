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

-- Check view v_rtc_hydrometer_x_connec
SELECT has_view('v_rtc_hydrometer_x_connec'::name, 'View v_rtc_hydrometer_x_connec should exist');

-- Check view columns
SELECT columns_are(
    'v_rtc_hydrometer_x_connec',
    ARRAY[
        'hydrometer_id',
        'hydrometer_customer_code',
        'connec_id',
        'connec_customer_code',
        'state',
        'muni_name',
        'expl_id',
        'expl_name',
        'plot_code',
        'priority_id',
        'catalog_id',
        'category_id',
        'hydro_number',
        'hydro_man_date',
        'crm_number',
        'customer_name',
        'address1',
        'address2',
        'address3',
        'address2_1',
        'address2_2',
        'address2_3',
        'm3_volume',
        'start_date',
        'end_date',
        'update_date',
        'hydrometer_link',
        'is_operative',
        'shutdown_date',
    ],
    'View v_rtc_hydrometer_x_connec should have the correct columns'
);


SELECT * FROM finish();

ROLLBACK;