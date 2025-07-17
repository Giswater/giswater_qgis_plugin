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

--check if table exists
SELECT has_table('archived_rpt_subcatchrunoff_sum'::name, 'Table archived_rpt_subcatchrunoff_sum should exist');

-- check columns names 


SELECT columns_are(
    'archived_rpt_subcatchrunoff_sum',
    ARRAY[
        'id', 'result_id', 'subc_id', 'tot_precip', 'tot_runon', 'tot_evap', 'tot_infil', 'tot_runoff', 'tot_runofl',
        'peak_runof', 'runoff_coe', 'vxmax', 'vymax', 'depth', 'vel', 'vhmax'
    ],
    'Table archived_rpt_subcatchrunoff_sum should have the correct columns'
);
-- check columns names
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'tot_precip', 'numeric(12, 4)', 'Column tot_precip should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'tot_runon', 'numeric(12, 4)', 'Column tot_runon should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'tot_evap', 'numeric(12, 4)', 'Column tot_evap should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'tot_infil', 'numeric(12, 4)', 'Column tot_infil should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'tot_runoff', 'numeric(12, 4)', 'Column tot_runoff should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'tot_runofl', 'numeric(12, 4)', 'Column tot_runofl should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'peak_runof', 'numeric(12, 4)', 'Column peak_runof should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'runoff_coe', 'numeric(12, 4)', 'Column runoff_coe should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'vxmax', 'numeric(12, 4)', 'Column vxmax should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'vymax', 'numeric(12, 4)', 'Column vymax should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'depth', 'numeric(12, 4)', 'Column depth should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'vel', 'numeric(12, 4)', 'Column vel should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_subcatchrunoff_sum', 'vhmax', 'numeric(12, 6)', 'Column vhmax should be numeric(12, 6)');



--check default values



-- check foreign keys


-- check index
SELECT has_index('archived_rpt_subcatchrunoff_sum', 'archived_rpt_subcathrunoff_sum_pkey', ARRAY['id'], 'Table archived_rpt_subcatchrunoff_sum should have index on id');

--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;