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

-- Check view v_ui_hydrometer
SELECT has_view('v_ui_hydrometer'::name, 'View v_ui_hydrometer should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_hydrometer',
    ARRAY[
        'hydrometer_id',
        'feature_id',
        'hydrometer_customer_code',
        'feature_customer_code',
        'state',
        'expl_name',
        'hydrometer_link'
    ],
    'View v_ui_hydrometer should have the correct columns'
);


SELECT * FROM finish();

ROLLBACK;