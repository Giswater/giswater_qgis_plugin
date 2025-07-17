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
SELECT has_table('archived_rpt_lidperformance_sum'::name, 'Table archived_rpt_lidperformance_sum should exist');

-- check columns names 


SELECT columns_are(
    'archived_rpt_lidperformance_sum',
    ARRAY[
        'id', 'result_id', 'subc_id','lidco_id','tot_inflow', 'evap_loss', 'infil_loss', 'surf_outf', 'drain_outf', 'init_stor', 'final_stor','per_error'
    ],
    'Table archived_rpt_lidperformance_sum should have the correct columns'
);
-- check columns names
SELECT col_type_is('archived_rpt_lidperformance_sum', 'id', 'serial4', 'Column id should be serial4');
SELECT col_type_is('archived_rpt_lidperformance_sum', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_lidperformance_sum', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('archived_rpt_lidperformance_sum', 'lidco_id', 'varchar(16)', 'Column lidco_id should be varchar(16)');
SELECT col_type_is('archived_rpt_lidperformance_sum', 'tot_inflow', 'numeric(12, 4)', 'Column tot_inflow should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_lidperformance_sum', 'evap_loss', 'numeric(12, 4)', 'Column evap_loss should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_lidperformance_sum', 'infil_loss', 'numeric(12, 4)', 'Column infil_loss should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_lidperformance_sum', 'surf_outf', 'numeric(12, 4)', 'Column surf_outf should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_lidperformance_sum', 'drain_outf', 'numeric(12, 4)', 'Column drain_outf should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_lidperformance_sum', 'init_stor', 'numeric(12, 4)', 'Column init_stor should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_lidperformance_sum', 'final_stor', 'numeric(12, 4)', 'Column final_stor should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_lidperformance_sum', 'per_error', 'numeric(12, 4)', 'Column per_error should be numeric(12, 4)');


--check default values



-- check foreign keys


-- check index
SELECT has_index('archived_rpt_lidperformance_sum', 'id', 'Table archived_rpt_lidperformance_sum should have index on id');

--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;