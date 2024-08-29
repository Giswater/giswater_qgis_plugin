/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 07/08/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"visitability", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"placement_type", "dataType":"varchar(50)"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_arc_traceability", "column":"visitability", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_arc_traceability", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_node_traceability", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_connec_traceability", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_gully_traceability", "column":"placement_type", "dataType":"varchar(50)"}}$$);

CREATE INDEX gully_muni ON gully USING btree (muni_id);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"raingage", "column":"muni_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"rpt_inp_raingage", "column":"muni_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"connec", "column":"n_hydrometer", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"drainzone", "column":"sector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"dma", "column":"sector_id", "dataType":"integer"}}$$);

-- 13/08/24
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"iscorporate", "dataType":"boolean"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"dma", "column":"pattern_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"dma", "column":"min"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"dma", "column":"max"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"dma", "column":"effec"}}$$);


DROP FUNCTION IF EXISTS gw_fct_graphanalytics_downstream_recursive;
DROP FUNCTION IF EXISTS gw_fct_graphanalytics_upstream_recursive;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"model_id", "dataType":"varchar(50)"}}$$);

-- 28/08/24
CREATE TABLE archived_rpt_inp_arc (
	-- rpt_inp_arc
	id serial4 NOT NULL,
	result_id varchar(30) NOT NULL,
	arc_id varchar(16) NOT NULL,
	node_1 varchar(16) NULL,
	node_2 varchar(16) NULL,
	elevmax1 numeric(12, 3) NULL,
	elevmax2 numeric(12, 3) NULL,
	arc_type varchar(30) NULL,
	arccat_id varchar(30) NULL,
	epa_type varchar(16) NULL,
	sector_id int4 NOT NULL,
	state int2 NOT NULL,
	state_type int2 NULL,
	annotation varchar(254) NULL,
	length numeric(12, 3) NULL,
	n numeric(12, 3) NULL,
	the_geom public.geometry(linestring, 25831) NULL,
	expl_id int4 NULL,
	addparam text NULL,
	arcparent varchar(16) NULL,
	q0 float8 NULL,
	qmax float8 NULL,
	barrels int4 NULL,
	slope float8 NULL,
	culvert varchar(10) NULL,
	kentry numeric(12, 4) NULL,
	kexit numeric(12, 4) NULL,
	kavg numeric(12, 4) NULL,
	flap varchar(3) NULL,
	seepage numeric(12, 4) NULL,
	age int4 NULL,
	-- rpt_arcflow_sum
    max_flow numeric(12, 4) NULL,
	time_days varchar(10) NULL,
	time_hour varchar(10) NULL,
	max_veloc numeric(12, 4) NULL,
	mfull_flow numeric(12, 4) NULL,
	mfull_dept numeric(12, 4) NULL,
	max_shear numeric(12, 4) NULL,
	max_hr numeric(12, 4) NULL,
	max_slope numeric(12, 4) NULL,
	day_max varchar(10) NULL,
	time_max varchar(10) NULL,
	min_shear numeric(12, 4) NULL,
	day_min varchar(10) NULL,
	time_min varchar(10) NULL,
    -- rpt_arcpolload_sum
	poll_id varchar(16) NULL,
    -- rpt_condsurcharge_sum
    both_ends numeric(12, 4) NULL,
	upstream numeric(12, 4) NULL,
	dnstream numeric(12, 4) NULL,
	hour_nflow numeric(12, 4) NULL,
	hour_limit numeric(12, 4) NULL,
    -- rpt_pumping_sum
    "percent" numeric(12, 4) NULL,
	num_startup int4 NULL,
	min_flow numeric(12, 4) NULL,
	avg_flow numeric(12, 4) NULL,
	max_flow_pumping numeric(12, 4) NULL,
	vol_ltr numeric(12, 4) NULL,
	powus_kwh numeric(12, 4) NULL,
	timoff_min numeric(12, 4) NULL,
	timoff_max numeric(12, 4) NULL,
    -- rpt_flowclass_sum
    length_flowclass numeric(12, 4) NULL,
	dry numeric(12, 4) NULL,
	up_dry numeric(12, 4) NULL,
	down_dry numeric(12, 4) NULL,
	sub_crit numeric(12, 4) NULL,
	sub_crit_1 numeric(12, 4) NULL,
	up_crit numeric(12, 4) NULL,
	down_crit numeric(12, 4) NULL,
	froud_numb numeric(12, 4) NULL,
	flow_chang numeric(12, 4) NULL,
	CONSTRAINT archived_rpt_inp_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE archived_rpt_inp_node (
    -- rpt_inp_node
	id serial4 NOT NULL,
	result_id varchar(30) NOT NULL,
	node_id varchar(16) NOT NULL,
	top_elev numeric(12, 3) NULL,
	ymax numeric(12, 3) NULL,
	elev numeric(12, 3) NULL,
	node_type varchar(30) NULL,
	nodecat_id varchar(30) NULL,
	epa_type varchar(16) NULL,
	sector_id int4 NOT NULL,
	state int2 NOT NULL,
	state_type int2 NULL,
	annotation varchar(254) NULL,
	y0 numeric(12, 4) NULL,
	ysur numeric(12, 4) NULL,
	apond numeric(12, 4) NULL,
	the_geom public.geometry(point, 25831) NULL,
	expl_id int4 NULL,
	addparam text NULL,
	parent varchar(16) NULL,
	arcposition int2 NULL,
	fusioned_node text NULL,
	age int4 NULL,
    -- rpt_nodeflooding_sum
    hour_flood numeric(12, 4) NULL,
	max_rate numeric(12, 4) NULL,
	flooding_time_days varchar(10) NULL,
	flooding_time_hour varchar(10) NULL,
	tot_flood numeric(12, 4) NULL,
	max_ponded numeric(12, 4) NULL,
    -- rpt_nodesurcharge_sum
	hour_surch numeric(12, 4) NULL,
	max_height numeric(12, 4) NULL,
	min_depth numeric(12, 4) NULL,
    -- rpt_nodeinflow_sum
	max_latinf numeric(12, 4) NULL,
	max_totinf numeric(12, 4) NULL,
	inflow_time_days varchar(10) NULL,
	inflow_time_hour varchar(10) NULL,
	latinf_vol numeric(12, 4) NULL,
	totinf_vol numeric(12, 4) NULL,
	flow_balance_error numeric(12, 2) NULL,
	other_info varchar(12) NULL,
    -- rpt_nodedepth_sum
	aver_depth numeric(12, 4) NULL,
	max_depth numeric(12, 4) NULL,
	max_hgl numeric(12, 4) NULL,
	depth_time_days varchar(10) NULL,
	depth_time_hour varchar(10) NULL,
    -- rpt_outfallflow_sum
    flow_freq numeric(12, 4) NULL,
	avg_flow numeric(12, 4) NULL,
	max_flow numeric(12, 4) NULL,
	total_vol numeric(12, 4) NULL,
    -- rpt_outfallload_sum
    poll_id varchar(16) NULL,
	value numeric(12, 4) NULL,
    -- rpt_storagevol_sum
    aver_vol numeric(12, 4) NULL,
	avg_full numeric(12, 4) NULL,
	ei_loss numeric(12, 4) NULL,
	max_vol numeric(12, 4) NULL,
	max_full numeric(12, 4) NULL,
	storagevol_time_days varchar(10) NULL,
	storagevol_time_hour varchar(10) NULL,
	max_out numeric(12, 4) NULL,
	CONSTRAINT archived_rpt_inp_node_pkey PRIMARY KEY (id)
);

CREATE TABLE archived_rpt_inp_raingage (
    id bigserial NOT NULL,
	result_id varchar(30) NOT NULL,
	rg_id varchar(16) NOT NULL,
	form_type varchar(12) NOT NULL,
	intvl varchar(10) NULL,
	scf numeric(12, 4) DEFAULT 1.00 NULL,
	rgage_type varchar(18) NOT NULL,
	timser_id varchar(16) NULL,
	fname varchar(254) NULL,
	sta varchar(12) NULL,
	units varchar(3) NULL,
	the_geom public.geometry(point, 25831) NULL,
	expl_id int4 NOT NULL,
	muni_id int4 NULL,
	CONSTRAINT archived_rpt_inp_raingage_pkey PRIMARY KEY (id)
);

CREATE TABLE archived_rpt_node (
	id bigserial NOT NULL,
	result_id varchar(30) NOT NULL,
	node_id varchar(16) NULL,
	resultdate varchar(16) NULL,
	resulttime varchar(12) NULL,
	flooding float8 NULL,
	"depth" float8 NULL,
	head float8 NULL,
	inflow numeric(12, 3) NULL,
	CONSTRAINT archived_rpt_node_pkey PRIMARY KEY (id)
);

CREATE TABLE archived_rpt_arc (
	id bigserial NOT NULL,
	result_id varchar(30) NOT NULL,
	arc_id varchar(16) NULL,
	resultdate varchar(16) NULL,
	resulttime varchar(12) NULL,
	flow float8 NULL,
	velocity float8 NULL,
	fullpercent float8 NULL,
	CONSTRAINT archived_rpt_arc_pkey PRIMARY KEY (id)
);

CREATE TABLE archived_rpt_subcatchment (
	id bigserial NOT NULL,
	result_id varchar(30) NOT NULL,
	subc_id varchar(16) NULL,
	resultdate varchar(16) NULL,
	resulttime varchar(12) NULL,
	precip float8 NULL,
	losses float8 NULL,
	runoff float8 NULL,
	CONSTRAINT archived_rpt_subcatchment_pkey PRIMARY KEY (id)
);

CREATE TABLE archived_rpt_subcatchrunoff_sum (
	id serial NOT NULL,
	result_id varchar(30) NOT NULL,
	subc_id varchar(16) NULL,
	tot_precip numeric(12, 4) NULL,
	tot_runon numeric(12, 4) NULL,
	tot_evap numeric(12, 4) NULL,
	tot_infil numeric(12, 4) NULL,
	tot_runoff numeric(12, 4) NULL,
	tot_runofl numeric(12, 4) NULL,
	peak_runof numeric(12, 4) NULL,
	runoff_coe numeric(12, 4) NULL,
	vxmax numeric(12, 4) NULL,
	vymax numeric(12, 4) NULL,
	"depth" numeric(12, 4) NULL,
	vel numeric(12, 4) NULL,
	vhmax numeric(12, 6) NULL,
	CONSTRAINT archived_rpt_subcathrunoff_sum_pkey PRIMARY KEY (id)
);

CREATE TABLE archived_rpt_subcatchwashoff_sum (
	id serial NOT NULL,
	result_id varchar(30) NOT NULL,
	subc_id varchar(16) NOT NULL,
	poll_id varchar(16) NOT NULL,
	value numeric NULL,
	CONSTRAINT archived_rpt_subcatchwashoff_sum_pkey PRIMARY KEY (id)
);

CREATE TABLE archived_rpt_lidperformance_sum (
	id serial NOT NULL,
	result_id varchar(30) NOT NULL,
	subc_id varchar(16) NULL,
	lidco_id varchar(16) NULL,
	tot_inflow numeric(12, 4) NULL,
	evap_loss numeric(12, 4) NULL,
	infil_loss numeric(12, 4) NULL,
	surf_outf numeric(12, 4) NULL,
	drain_outf numeric(12, 4) NULL,
	init_stor numeric(12, 4) NULL,
	final_stor numeric(12, 4) NULL,
	per_error numeric(12, 4) NULL,
	CONSTRAINT archived_rpt_lidperformance_sum_pkey PRIMARY KEY (id)
);

ALTER TABLE rpt_cat_result DROP CONSTRAINT rpt_cat_result_status_check;

ALTER TABLE rpt_cat_result ADD CONSTRAINT rpt_cat_result_status_check CHECK (status = ANY (ARRAY[0, 1, 2, 3]));
