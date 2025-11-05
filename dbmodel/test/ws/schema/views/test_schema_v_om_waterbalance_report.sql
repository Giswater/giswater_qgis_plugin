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

-- Check view v_om_waterbalance_report
SELECT has_view('v_om_waterbalance_report'::name, 'View v_om_waterbalance_report should exist');

-- Check view columns
SELECT columns_are(
    'v_om_waterbalance_report',
    ARRAY[
       'exploitation',
       'expl_id',
       'dma',
       'dma_id',
       'cat_period_id',
       'period',
       'start_date',
       'end_date',
       'meters_in',
       'meters_out',
       'n_connec',
       'n_hydro',
       'arc_length',
       'link_length',
       'total_in',
       'total_out',
       'total',
       'auth',
       'nrw',
       'dma_rw_eff',
       'dma_nrw_eff',
       'dma_ili',
       'dma_nightvol',
       'dma_m4day',
       'expl_rw_eff',
       'expl_nrw_eff',
       'expl_nightvol',
       'expl_ili',
       'expl_m4day',
    ],
    'View v_om_waterbalance_report should have the correct columns'
);


SELECT * FROM finish();

ROLLBACK;