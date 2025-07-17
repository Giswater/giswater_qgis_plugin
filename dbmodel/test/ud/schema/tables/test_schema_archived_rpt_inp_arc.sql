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
SELECT has_table('archived_rpt_inp_arc'::name, 'Table archived_rpt_inp_arc should exist');

-- check columns names 


SELECT columns_are(
    'archived_rpt_inp_arc',
    ARRAY[
        'id', 'result_id', 'arc_id', 'node_1', 'node_2', 'elevmax1', 'elevmax2', 'arc_type', 'arccat_id', 'epa_type', 'sector_id', 'state', 'state_type',
        'annotation', 'length', 'n', 'the_geom', 'expl_id', 'addparam', 'arcparent', 'q0', 'qmax', 'barrels', 'slope',
        'culvert', 'kentry', 'kexit', 'kavg', 'flap', 'seepage', 'age', 'max_flow', 'time_days', 'time_hour', 'max_veloc', 'mfull_flow', 'mfull_depth',
        'max_shear', 'max_hr', 'max_slope', 'day_max', 'time_max', 'min_shear', 'day_min', 'time_min', 'poll_id', 'both_ends', 'upstream', 'dnstream',
        'hour_nflow', 'hour_limit', 'percent', 'num_startup', 'min_flow', 'avg_flow', 'max_flow_pumping', 'vol_ltr', 'powus_kwh', 'timoff_min', 'timoff_max', 
        'length_flowclass', 'dry', 'up_dry', 'down_dry', 'sub_crit', 'sub_crit_1', 'up_crit', 'down_crit', 'froud_numb', 'flow_chang'

    ],
    'Table archived_rpt_inp_arc should have the correct columns'
);
-- check columns names
SELECT col_type_is('archived_rpt_inp_arc', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_rpt_inp_arc', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_inp_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('archived_rpt_inp_arc', 'node_1', 'int4', 'Column node_1 should be int4');
SELECT col_type_is('archived_rpt_inp_arc', 'node_2', 'int4', 'Column node_2 should be int4');
SELECT col_type_is('archived_rpt_inp_arc', 'elevmax1', 'numeric(12, 3)', 'Column elevmax1 should be numeric(12, 3)');
SELECT col_type_is('archived_rpt_inp_arc', 'elevmax2', 'numeric(12, 3)', 'Column elevmax2 should be numeric(12, 3)');
SELECT col_type_is('archived_rpt_inp_arc', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('archived_rpt_inp_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('archived_rpt_inp_arc', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_arc', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('archived_rpt_inp_arc', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('archived_rpt_inp_arc', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('archived_rpt_inp_arc', 'annotation', 'varchar(254)', 'Column annotation should be varchar(254)');
SELECT col_type_is('archived_rpt_inp_arc', 'length', 'numeric(12, 3)', 'Column length should be numeric(12, 3)');
SELECT col_type_is('archived_rpt_inp_arc', 'n', 'numeric(12, 3)', 'Column n should be numeric(12, 3)');
SELECT col_type_is('archived_rpt_inp_arc', 'the_geom', 'public.geometry(linestring, 25831)', 'Column the_geom should be public.geometry(linestring, 25831)');
SELECT col_type_is('archived_rpt_inp_arc', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('archived_rpt_inp_arc', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('archived_rpt_inp_arc', 'arcparent', 'varchar(16)', 'Column arcparent should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_arc', 'q0', 'float8', 'Column q0 should be float8');
SELECT col_type_is('archived_rpt_inp_arc', 'qmax', 'float8', 'Column qmax should be float8');
SELECT col_type_is('archived_rpt_inp_arc', 'barrels', 'int4', 'Column barrels should be int4');
SELECT col_type_is('archived_rpt_inp_arc', 'slope', 'float8', 'Column slope should be float8');
SELECT col_type_is('archived_rpt_inp_arc', 'culvert', 'varchar(10)', 'Column culvert should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_arc', 'kentry', 'numeric(12, 4)', 'Column kentry should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'kexit', 'numeric(12, 4)', 'Column kexit should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'kavg', 'numeric(12, 4)', 'Column kavg should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'flap', 'varchar(3)', 'Column flap should be varchar(3)');
SELECT col_type_is('archived_rpt_inp_arc', 'seepage', 'numeric(12, 4)', 'Column seepage should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'age', 'int4', 'Column age should be int4');
SELECT col_type_is('archived_rpt_inp_arc', 'max_flow', 'numeric(12, 4)', 'Column max_flow should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'time_days', 'varchar(10)', 'Column time_days should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_arc', 'time_hour', 'varchar(10)', 'Column time_hour should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_arc', 'max_veloc', 'numeric(12, 4)', 'Column max_veloc should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'mfull_flow', 'numeric(12, 4)', 'Column mfull_flow should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'mfull_depth', 'numeric(12, 4)', 'Column mfull_depth should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'max_shear', 'numeric(12, 4)', 'Column max_shear should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'max_hr', 'numeric(12, 4)', 'Column max_hr should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'max_slope', 'numeric(12, 4)', 'Column max_slope should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'day_max', 'varchar(10)', 'Column day_max should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_arc', 'time_max', 'varchar(10)', 'Column time_max should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_arc', 'min_shear', 'numeric(12, 4)', 'Column min_shear should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'day_min', 'varchar(10)', 'Column day_min should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_arc', 'time_min', 'varchar(10)', 'Column time_min should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_arc', 'poll_id', 'varchar(16)', 'Column poll_id should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_arc', 'both_ends', 'numeric(12, 4)', 'Column both_ends should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'upstream', 'numeric(12, 4)', 'Column upstream should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'dnstream', 'numeric(12, 4)', 'Column dnstream should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'hour_nflow', 'numeric(12, 4)', 'Column hour_nflow should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'hour_limit', 'numeric(12, 4)', 'Column hour_limit should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'percent', 'numeric(12, 4)', 'Column percent should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'num_startup', 'int4', 'Column num_startup should be int4');
SELECT col_type_is('archived_rpt_inp_arc', 'min_flow', 'numeric(12, 4)', 'Column min_flow should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'avg_flow', 'numeric(12, 4)', 'Column avg_flow should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'max_flow_pumping', 'numeric(12, 4)', 'Column max_flow_pumping should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'vol_ltr', 'numeric(12, 4)', 'Column vol_ltr should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'powus_kwh', 'numeric(12, 4)', 'Column powus_kwh should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'timoff_min', 'numeric(12, 4)', 'Column timoff_min should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'timoff_max', 'numeric(12, 4)', 'Column timoff_max should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'length_flowclass', 'numeric(12, 4)', 'Column length_flowclass should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'dry', 'numeric(12, 4)', 'Column dry should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'up_dry', 'numeric(12, 4)', 'Column up_dry should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'down_dry', 'numeric(12, 4)', 'Column down_dry should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'sub_crit', 'numeric(12, 4)', 'Column sub_crit should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'sub_crit_1', 'numeric(12, 4)', 'Column sub_crit_1 should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'up_crit', 'numeric(12, 4)', 'Column up_crit should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'down_crit', 'numeric(12, 4)', 'Column down_crit should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'froud_numb', 'numeric(12, 4)', 'Column froud_numb should be numeric(12, 4)');
SELECT col_type_is('archived_rpt_inp_arc', 'flow_chang', 'numeric(12, 4)', 'Column flow_chang should be numeric(12, 4)');


--check default values



-- check foreign keys


-- check index
SELECT has_index('archived_rpt_inp_arc', 'id', 'Table archived_rpt_inp_arc should have index on id');

--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;