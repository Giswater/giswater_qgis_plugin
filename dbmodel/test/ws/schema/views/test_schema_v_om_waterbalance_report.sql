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
        'exploitation', 'expl_id', 'dma', 'dma_id', 'cat_period_id', 'period',
        'start_date', 'end_date', 'meters_in', 'meters_out', 'n_connec', 'n_hydro',
        'arc_length', 'link_length', 'total_in', 'total_out', 'total', 'auth',
        'nrw', 'dma_rw_eff', 'dma_nrw_eff', 'dma_ili', 'dma_nightvol', 'dma_m4day',
        'expl_rw_eff', 'expl_nrw_eff', 'expl_nightvol', 'expl_ili', 'expl_m4day'
    ],
    'View v_om_waterbalance_report should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_om_waterbalance_report', 'exploitation', 'varchar(100)', 'Column exploitation should be varchar(100)');
SELECT col_type_is('v_om_waterbalance_report', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_om_waterbalance_report', 'dma', 'varchar(100)', 'Column dma should be varchar(100)');
SELECT col_type_is('v_om_waterbalance_report', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('v_om_waterbalance_report', 'cat_period_id', 'varchar(16)', 'Column cat_period_id should be varchar(16)');
SELECT col_type_is('v_om_waterbalance_report', 'period', 'text', 'Column period should be text');
SELECT col_type_is('v_om_waterbalance_report', 'start_date', 'timestamp(6) without time zone', 'Column start_date should be timestamp(6) without time zone');
SELECT col_type_is('v_om_waterbalance_report', 'end_date', 'timestamp(6) without time zone', 'Column end_date should be timestamp(6) without time zone');
SELECT col_type_is('v_om_waterbalance_report', 'meters_in', 'text', 'Column meters_in should be text');
SELECT col_type_is('v_om_waterbalance_report', 'meters_out', 'text', 'Column meters_out should be text');
SELECT col_type_is('v_om_waterbalance_report', 'n_connec', 'int4', 'Column n_connec should be int4');
SELECT col_type_is('v_om_waterbalance_report', 'n_hydro', 'int4', 'Column n_hydro should be int4');
SELECT col_type_is('v_om_waterbalance_report', 'arc_length', 'float8', 'Column arc_length should be float8');
SELECT col_type_is('v_om_waterbalance_report', 'link_length', 'float8', 'Column link_length should be float8');
SELECT col_type_is('v_om_waterbalance_report', 'total_in', 'numeric', 'Column total_in should be numeric');
SELECT col_type_is('v_om_waterbalance_report', 'total_out', 'numeric', 'Column total_out should be numeric');
SELECT col_type_is('v_om_waterbalance_report', 'total', 'float8', 'Column total should be float8');
SELECT col_type_is('v_om_waterbalance_report', 'auth', 'float8', 'Column auth should be float8');
SELECT col_type_is('v_om_waterbalance_report', 'nrw', 'float8', 'Column nrw should be float8');
SELECT col_type_is('v_om_waterbalance_report', 'dma_rw_eff', 'float8', 'Column dma_rw_eff should be float8');
SELECT col_type_is('v_om_waterbalance_report', 'dma_nrw_eff', 'float8', 'Column dma_nrw_eff should be float8');
SELECT col_type_is('v_om_waterbalance_report', 'dma_ili', 'numeric', 'Column dma_ili should be numeric');
SELECT col_type_is('v_om_waterbalance_report', 'dma_nightvol', 'text', 'Column dma_nightvol should be text');
SELECT col_type_is('v_om_waterbalance_report', 'dma_m4day', 'float8', 'Column dma_m4day should be float8');
SELECT col_type_is('v_om_waterbalance_report', 'expl_rw_eff', 'float8', 'Column expl_rw_eff should be float8');
SELECT col_type_is('v_om_waterbalance_report', 'expl_nrw_eff', 'float8', 'Column expl_nrw_eff should be float8');
SELECT col_type_is('v_om_waterbalance_report', 'expl_nightvol', 'text', 'Column expl_nightvol should be text');
SELECT col_type_is('v_om_waterbalance_report', 'expl_ili', 'float8', 'Column expl_ili should be float8');
SELECT col_type_is('v_om_waterbalance_report', 'expl_m4day', 'float8', 'Column expl_m4day should be float8');

SELECT * FROM finish();

ROLLBACK;
