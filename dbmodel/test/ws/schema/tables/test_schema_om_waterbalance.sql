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

-- Check table
SELECT has_table('om_waterbalance'::name, 'Table om_waterbalance should exist');

-- Check columns
SELECT columns_are(
    'om_waterbalance',
    ARRAY[
        'expl_id', 'dma_id', 'cat_period_id', 'total_sys_input', 'auth_bill_met_export', 'auth_bill_met_hydro',
        'auth_bill_unmet', 'auth_unbill_met', 'auth_unbill_unmet', 'loss_app_unath', 'loss_app_met_error', 'loss_app_data_error',
        'loss_real_leak_main', 'loss_real_leak_service', 'loss_real_storage', 'type', 'descript', 'startdate',
        'enddate', 'total_in', 'total_out', 'ili', 'auth_bill', 'auth_unbill',
        'loss_app', 'loss_real', 'total', 'auth', 'nrw', 'nrw_eff',
        'loss', 'meters_in', 'meters_out', 'n_connec', 'n_hydro', 'arc_length',
        'link_length', 'n_inhabitants', 'avg_press'
    ],
    'Table om_waterbalance should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_waterbalance', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('om_waterbalance', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('om_waterbalance', 'cat_period_id', 'varchar(16)', 'Column cat_period_id should be varchar(16)');
SELECT col_type_is('om_waterbalance', 'total_sys_input', 'float8', 'Column total_sys_input should be float8');
SELECT col_type_is('om_waterbalance', 'auth_bill_met_export', 'float8', 'Column auth_bill_met_export should be float8');
SELECT col_type_is('om_waterbalance', 'auth_bill_met_hydro', 'float8', 'Column auth_bill_met_hydro should be float8');
SELECT col_type_is('om_waterbalance', 'auth_bill_unmet', 'float8', 'Column auth_bill_unmet should be float8');
SELECT col_type_is('om_waterbalance', 'auth_unbill_met', 'float8', 'Column auth_unbill_met should be float8');
SELECT col_type_is('om_waterbalance', 'auth_unbill_unmet', 'float8', 'Column auth_unbill_unmet should be float8');
SELECT col_type_is('om_waterbalance', 'loss_app_unath', 'float8', 'Column loss_app_unath should be float8');
SELECT col_type_is('om_waterbalance', 'loss_app_met_error', 'float8', 'Column loss_app_met_error should be float8');
SELECT col_type_is('om_waterbalance', 'loss_app_data_error', 'float8', 'Column loss_app_data_error should be float8');
SELECT col_type_is('om_waterbalance', 'loss_real_leak_main', 'float8', 'Column loss_real_leak_main should be float8');
SELECT col_type_is('om_waterbalance', 'loss_real_leak_service', 'float8', 'Column loss_real_leak_service should be float8');
SELECT col_type_is('om_waterbalance', 'loss_real_storage', 'float8', 'Column loss_real_storage should be float8');
SELECT col_type_is('om_waterbalance', 'type', 'varchar(50)', 'Column type should be varchar(50)');
SELECT col_type_is('om_waterbalance', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('om_waterbalance', 'startdate', 'date', 'Column startdate should be date');
SELECT col_type_is('om_waterbalance', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('om_waterbalance', 'total_in', 'numeric', 'Column total_in should be numeric');
SELECT col_type_is('om_waterbalance', 'total_out', 'numeric', 'Column total_out should be numeric');
SELECT col_type_is('om_waterbalance', 'ili', 'numeric', 'Column ili should be numeric');
SELECT col_type_is('om_waterbalance', 'auth_bill', 'float8', 'Column auth_bill should be float8');
SELECT col_type_is('om_waterbalance', 'auth_unbill', 'float8', 'Column auth_unbill should be float8');
SELECT col_type_is('om_waterbalance', 'loss_app', 'float8', 'Column loss_app should be float8');
SELECT col_type_is('om_waterbalance', 'loss_real', 'float8', 'Column loss_real should be float8');
SELECT col_type_is('om_waterbalance', 'total', 'float8', 'Column total should be float8');
SELECT col_type_is('om_waterbalance', 'auth', 'float8', 'Column auth should be float8');
SELECT col_type_is('om_waterbalance', 'nrw', 'float8', 'Column nrw should be float8');
SELECT col_type_is('om_waterbalance', 'nrw_eff', 'float8', 'Column nrw_eff should be float8');
SELECT col_type_is('om_waterbalance', 'loss', 'float8', 'Column loss should be float8');
SELECT col_type_is('om_waterbalance', 'meters_in', 'text', 'Column meters_in should be text');
SELECT col_type_is('om_waterbalance', 'meters_out', 'text', 'Column meters_out should be text');
SELECT col_type_is('om_waterbalance', 'n_connec', 'int4', 'Column n_connec should be int4');
SELECT col_type_is('om_waterbalance', 'n_hydro', 'int4', 'Column n_hydro should be int4');
SELECT col_type_is('om_waterbalance', 'arc_length', 'float8', 'Column arc_length should be float8');
SELECT col_type_is('om_waterbalance', 'link_length', 'float8', 'Column link_length should be float8');
SELECT col_type_is('om_waterbalance', 'n_inhabitants', 'int4', 'Column n_inhabitants should be int4');
SELECT col_type_is('om_waterbalance', 'avg_press', 'numeric(12,3)', 'Column avg_press should be numeric(12,3)');

-- Check foreign keys
SELECT has_fk('om_waterbalance', 'Table om_waterbalance should have foreign keys');

SELECT fk_ok('om_waterbalance', 'dma_id', 'dma', 'dma_id', 'FK dma_id → dma.dma_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
