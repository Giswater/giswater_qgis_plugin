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

-- Check view v_om_waterbalance
SELECT has_view('v_om_waterbalance'::name, 'View v_om_waterbalance should exist');

-- Check view columns
SELECT columns_are(
    'v_om_waterbalance',
    ARRAY[
        'exploitation',
        'dma',
        'period',
        'auth_bill',
        'auth_unbill',
        'loss_app',
        'loss_real',
        'total_in',
        'total_out',
        'total',
        'startdate',
        'enddate',
        'ili',
        'auth',
        'loss',
        'loss_eff',
        'rw',
        'nrw',
        'nrw_eff',
        'the_geom'
    ],
    'View v_om_waterbalance should have the correct columns'
);


SELECT * FROM finish();

ROLLBACK;