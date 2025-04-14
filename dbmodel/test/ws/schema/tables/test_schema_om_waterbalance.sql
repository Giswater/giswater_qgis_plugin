/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table om_waterbalance
SELECT has_table('om_waterbalance'::name, 'Table om_waterbalance should exist');

-- Check columns
SELECT columns_are(
    'om_waterbalance',
    ARRAY[
        'expl_id', 'dma_id', 'cat_period_id', 'total_sys_input', 'auth_bill_met_export', 'auth_bill_met_hydro',
        'auth_bill_unmet', 'auth_unbill_met', 'auth_unbill_unmet', 'loss_app_unath', 'loss_app_met_error',
        'loss_app_data_error', 'loss_real_leak_main', 'loss_real_leak_service', 'loss_real_storage', 'type',
        'descript', 'startdate', 'enddate', 'total_in', 'total_out', 'ili', 'auth_bill', 'auth_unbill',
        'loss_app', 'loss_real', 'total', 'auth', 'nrw', 'nrw_eff', 'loss', 'meters_in', 'meters_out',
        'n_connec', 'n_hydro', 'arc_length', 'link_length', 'n_inhabitants', 'avg_press'
    ],
    'Table om_waterbalance should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_waterbalance', ARRAY['dma_id', 'startdate', 'enddate'], 'Columns dma_id, startdate and enddate should be primary key');

-- Check column types
SELECT col_type_is('om_waterbalance', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('om_waterbalance', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('om_waterbalance', 'cat_period_id', 'varchar(16)', 'Column cat_period_id should be varchar(16)');
SELECT col_type_is('om_waterbalance', 'total_sys_input', 'double precision', 'Column total_sys_input should be double precision');
SELECT col_type_is('om_waterbalance', 'auth_bill_met_export', 'double precision', 'Column auth_bill_met_export should be double precision');
SELECT col_type_is('om_waterbalance', 'auth_bill_met_hydro', 'double precision', 'Column auth_bill_met_hydro should be double precision');
SELECT col_type_is('om_waterbalance', 'auth_bill_unmet', 'double precision', 'Column auth_bill_unmet should be double precision');
SELECT col_type_is('om_waterbalance', 'auth_unbill_met', 'double precision', 'Column auth_unbill_met should be double precision');
SELECT col_type_is('om_waterbalance', 'auth_unbill_unmet', 'double precision', 'Column auth_unbill_unmet should be double precision');
SELECT col_type_is('om_waterbalance', 'loss_app_unath', 'double precision', 'Column loss_app_unath should be double precision');
SELECT col_type_is('om_waterbalance', 'loss_app_met_error', 'double precision', 'Column loss_app_met_error should be double precision');
SELECT col_type_is('om_waterbalance', 'loss_app_data_error', 'double precision', 'Column loss_app_data_error should be double precision');
SELECT col_type_is('om_waterbalance', 'loss_real_leak_main', 'double precision', 'Column loss_real_leak_main should be double precision');
SELECT col_type_is('om_waterbalance', 'loss_real_leak_service', 'double precision', 'Column loss_real_leak_service should be double precision');
SELECT col_type_is('om_waterbalance', 'loss_real_storage', 'double precision', 'Column loss_real_storage should be double precision');
SELECT col_type_is('om_waterbalance', 'type', 'varchar(50)', 'Column type should be varchar(50)');
SELECT col_type_is('om_waterbalance', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('om_waterbalance', 'startdate', 'date', 'Column startdate should be date');
SELECT col_type_is('om_waterbalance', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('om_waterbalance', 'total_in', 'numeric', 'Column total_in should be numeric');
SELECT col_type_is('om_waterbalance', 'total_out', 'numeric', 'Column total_out should be numeric');
SELECT col_type_is('om_waterbalance', 'ili', 'numeric', 'Column ili should be numeric');
SELECT col_type_is('om_waterbalance', 'auth_bill', 'double precision', 'Column auth_bill should be double precision');
SELECT col_type_is('om_waterbalance', 'auth_unbill', 'double precision', 'Column auth_unbill should be double precision');
SELECT col_type_is('om_waterbalance', 'loss_app', 'double precision', 'Column loss_app should be double precision');
SELECT col_type_is('om_waterbalance', 'loss_real', 'double precision', 'Column loss_real should be double precision');
SELECT col_type_is('om_waterbalance', 'total', 'double precision', 'Column total should be double precision');
SELECT col_type_is('om_waterbalance', 'auth', 'double precision', 'Column auth should be double precision');
SELECT col_type_is('om_waterbalance', 'nrw', 'double precision', 'Column nrw should be double precision');
SELECT col_type_is('om_waterbalance', 'nrw_eff', 'double precision', 'Column nrw_eff should be double precision');
SELECT col_type_is('om_waterbalance', 'loss', 'double precision', 'Column loss should be double precision');
SELECT col_type_is('om_waterbalance', 'meters_in', 'text', 'Column meters_in should be text');
SELECT col_type_is('om_waterbalance', 'meters_out', 'text', 'Column meters_out should be text');
SELECT col_type_is('om_waterbalance', 'n_connec', 'integer', 'Column n_connec should be integer');
SELECT col_type_is('om_waterbalance', 'n_hydro', 'integer', 'Column n_hydro should be integer');
SELECT col_type_is('om_waterbalance', 'arc_length', 'double precision', 'Column arc_length should be double precision');
SELECT col_type_is('om_waterbalance', 'link_length', 'double precision', 'Column link_length should be double precision');
SELECT col_type_is('om_waterbalance', 'n_inhabitants', 'integer', 'Column n_inhabitants should be integer');
SELECT col_type_is('om_waterbalance', 'avg_press', 'numeric(12,3)', 'Column avg_press should be numeric(12,3)');

-- Check foreign keys
SELECT has_fk('om_waterbalance', 'Table om_waterbalance should have foreign keys');
SELECT fk_ok('om_waterbalance', 'dma_id', 'dma', 'dma_id', 'FK dma_id should reference dma.dma_id');
SELECT fk_ok('om_waterbalance', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation.expl_id');

-- Check constraints
SELECT col_not_null('om_waterbalance', 'dma_id', 'Column dma_id should be NOT NULL');
SELECT col_not_null('om_waterbalance', 'cat_period_id', 'Column cat_period_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 