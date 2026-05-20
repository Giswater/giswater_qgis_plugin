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
        'exploitation', 'dma', 'period', 'auth_bill', 'auth_unbill', 'loss_app',
        'loss_real', 'total_in', 'total_out', 'total', 'startdate', 'enddate',
        'ili', 'auth', 'loss', 'loss_eff', 'rw', 'nrw',
        'nrw_eff', 'the_geom'
    ],
    'View v_om_waterbalance should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_om_waterbalance', 'exploitation', 'varchar(100)', 'Column exploitation should be varchar(100)');
SELECT col_type_is('v_om_waterbalance', 'dma', 'varchar(100)', 'Column dma should be varchar(100)');
SELECT col_type_is('v_om_waterbalance', 'period', 'text', 'Column period should be text');
SELECT col_type_is('v_om_waterbalance', 'auth_bill', 'float8', 'Column auth_bill should be float8');
SELECT col_type_is('v_om_waterbalance', 'auth_unbill', 'float8', 'Column auth_unbill should be float8');
SELECT col_type_is('v_om_waterbalance', 'loss_app', 'float8', 'Column loss_app should be float8');
SELECT col_type_is('v_om_waterbalance', 'loss_real', 'float8', 'Column loss_real should be float8');
SELECT col_type_is('v_om_waterbalance', 'total_in', 'numeric', 'Column total_in should be numeric');
SELECT col_type_is('v_om_waterbalance', 'total_out', 'numeric', 'Column total_out should be numeric');
SELECT col_type_is('v_om_waterbalance', 'total', 'float8', 'Column total should be float8');
SELECT col_type_is('v_om_waterbalance', 'startdate', 'date', 'Column startdate should be date');
SELECT col_type_is('v_om_waterbalance', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('v_om_waterbalance', 'ili', 'numeric', 'Column ili should be numeric');
SELECT col_type_is('v_om_waterbalance', 'auth', 'float8', 'Column auth should be float8');
SELECT col_type_is('v_om_waterbalance', 'loss', 'float8', 'Column loss should be float8');
SELECT col_type_is('v_om_waterbalance', 'loss_eff', 'numeric(20,2)', 'Column loss_eff should be numeric(20,2)');
SELECT col_type_is('v_om_waterbalance', 'rw', 'float8', 'Column rw should be float8');
SELECT col_type_is('v_om_waterbalance', 'nrw', 'numeric(20,2)', 'Column nrw should be numeric(20,2)');
SELECT col_type_is('v_om_waterbalance', 'nrw_eff', 'numeric(20,2)', 'Column nrw_eff should be numeric(20,2)');
SELECT col_type_is('v_om_waterbalance', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
