/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"visitability", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"placement_type", "dataType":"varchar(50)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"access_type", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"access_type", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"access_type", "dataType":"text"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_arc_traceability", "column":"visitability", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_node_traceability", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_connec_traceability", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_gully_traceability", "column":"placement_type", "dataType":"varchar(50)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_node_traceability", "column":"access_type", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_connec_traceability", "column":"access_type", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_gully_traceability", "column":"access_type", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_gully_traceability", "column":"label_quadrant", "dataType":"varchar(12)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"raingage", "column":"muni_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"rpt_inp_raingage", "column":"muni_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"connec", "column":"n_hydrometer", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"n_hydrometer", "dataType":"integer"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"iscorporate", "dataType":"boolean"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"dma", "column":"pattern_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"dma", "column":"min"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"dma", "column":"max"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"dma", "column":"effec"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"dma", "column":"expl_id2"}}$$);



DROP FUNCTION IF EXISTS gw_fct_graphanalytics_downstream_recursive;
DROP FUNCTION IF EXISTS gw_fct_graphanalytics_upstream_recursive;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"model_id", "dataType":"varchar(50)"}}$$);


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
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
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
	the_geom public.geometry(point, SRID_VALUE) NULL,
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
	the_geom public.geometry(point, SRID_VALUE) NULL,
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

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"drainzone_type", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"sector_type", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"dma_type", "dataType":"varchar(16)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"minsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"minsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"minsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"minsector_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"macrominsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"macrominsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"macrominsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"macrominsector_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"minsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"minsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"minsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_gully_traceability", "column":"minsector_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"macrominsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"macrominsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_connec_traceability", "column":"macrominsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_gully_traceability", "column":"macrominsector_id", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_feature_node", "column":"graph_delimiter", "dataType":"text[]"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"graphconfig", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"graphconfig", "dataType":"json"}}$$);

CREATE TABLE minsector (
	minsector_id serial4 NOT NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	CONSTRAINT minsector_pkey PRIMARY KEY (minsector_id)
);

CREATE TABLE macrominsector (
	macrominsector_id serial4 NOT NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	CONSTRAINT macrominsector_pkey PRIMARY KEY (macrominsector_id)
);

CREATE OR REPLACE VIEW v_ui_rpt_cat_result
AS SELECT DISTINCT ON (rpt_cat_result.result_id) rpt_cat_result.result_id,
    rpt_cat_result.expl_id,
    rpt_cat_result.sector_id,
    t2.idval AS network_type,
    t1.idval AS status,
    rpt_cat_result.iscorporate,
    rpt_cat_result.descript,
    rpt_cat_result.exec_date,
    rpt_cat_result.cur_user,
    rpt_cat_result.export_options,
    rpt_cat_result.network_stats,
    rpt_cat_result.inp_options,
    rpt_cat_result.rpt_stats,
    rpt_cat_result.addparam
   FROM selector_expl s,
    rpt_cat_result
     LEFT JOIN inp_typevalue t1 ON rpt_cat_result.status::text = t1.id::text
     LEFT JOIN inp_typevalue t2 ON rpt_cat_result.network_type::text = t2.id::text
  WHERE t1.typevalue::text = 'inp_result_status'::text AND t2.typevalue::text = 'inp_options_networkmode'::text AND ((s.expl_id = ANY (rpt_cat_result.expl_id)) AND s.cur_user = CURRENT_USER OR rpt_cat_result.expl_id = ARRAY[NULL]::INTEGER[]);


DROP VIEW if EXISTS v_ui_doc_x_gully;
CREATE OR REPLACE VIEW v_ui_doc_x_gully
AS SELECT doc_x_gully.id,
    doc_x_gully.gully_id,
    doc."name" AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_gully
     JOIN doc ON doc.id::text = doc_x_gully.doc_id::text;


DROP VIEW IF EXISTS vu_drainzone;
CREATE OR REPLACE VIEW vu_drainzone
AS SELECT d.drainzone_id,
    d.name,
    d.expl_id,
    e.name as exploitation_name,
    et.idval as drainzone_type,
    d.descript,
    d.active,
    d.undelete,
    d.link,
    d.graphconfig::text as graphconfig,
    d.stylesheet::text as stylesheet,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.the_geom
    FROM drainzone d
    LEFT JOIN exploitation e USING (expl_id)
    LEFT JOIN edit_typevalue et ON et.id::text = d.drainzone_type::text AND et.typevalue::text = 'drainzone_type'::text
    ORDER BY d.drainzone_id;

CREATE OR REPLACE VIEW vu_dma
AS SELECT
    dma.dma_id,
    dma.name,
    dma.macrodma_id,
    dma.dma_type,
    dma.expl_id,
    e.name as expl_name,
    dma.descript,
    dma.undelete,
    dma.link,
    dma.graphconfig::text,
    dma.active,
    dma.stylesheet,
    dma.the_geom
    FROM dma
    LEFT JOIN exploitation e USING (expl_id)
    ORDER BY 1;

CREATE OR REPLACE VIEW v_edit_dma AS
select vu_dma.* from vu_dma, selector_expl
WHERE ((vu_dma.expl_id = selector_expl.expl_id) AND selector_expl.cur_user = "current_user"()::text) OR vu_dma.expl_id is null
order by 1 asc;

DROP VIEW IF EXISTS v_edit_sector;
CREATE OR REPLACE VIEW v_edit_sector
AS SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.sector_type,
    sector.the_geom,
    sector.undelete,
    sector.active,
    sector.parent_id,
    sector.graphconfig::text,
    sector.stylesheet
   FROM selector_sector,
    sector
  WHERE sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


-- drop depedency views from gully
-----------------------------------
DROP VIEW IF EXISTS v_plan_psector_gully;
DROP VIEW IF EXISTS v_ui_element_x_gully;
DROP VIEW IF EXISTS vi_gully2node;
DROP VIEW IF EXISTS ve_pol_gully;
DROP VIEW IF EXISTS v_edit_inp_gully;

DROP VIEW IF EXISTS v_edit_gully;
DROP VIEW IF EXISTS v_edit_element;

DROP VIEW IF EXISTS ve_gully;
DROP VIEW IF EXISTS v_gully; -- permanently delete
DROP VIEW IF EXISTS vu_gully;

DROP VIEW IF EXISTS v_edit_samplepoint;

DROP VIEW IF EXISTS v_ext_municipality;
DROP VIEW IF EXISTS v_ext_address;
DROP VIEW IF EXISTS v_ext_streetaxis;
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.views
        WHERE table_schema = 'SCHEMA_NAME'
          AND table_name = 'ext_streetaxis'
    ) THEN
        DROP VIEW ext_streetaxis;
    END IF;
END $$;

DROP view if exists v_edit_link;
DROP view if exists v_edit_link_connec;
DROP view if exists v_edit_link_gully;

DROP view if exists v_link;
DROP view if exists v_link_connec;
DROP view if exists v_link_gully;

DROP view if exists vu_link;
DROP view if exists vu_link_connec;
DROP view if exists vu_link_gully;



-- change type of units columns on gully and audit_psector_gully_traceability
-----------------------------------
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"gully", "column":"units", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_psector_gully_traceability", "column":"units", "dataType":"numeric(12,2)"}}$$);

-- change type of visitability column on cat_arc bool to integer
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_arc", "column":"visitability", "newName":"visitability_vdef"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"cat_arc", "column":"visitability_vdef", "dataType":"integer"}}$$);

-- change type of code column on varchar(30) to text
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"gully", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_psector_gully_traceability", "column":"code", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"element", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_streetaxis", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"samplepoint", "column":"code", "dataType":"text"}}$$);


-- recreate v_edit_element, v_edit_samplepoint, v_ext_streetaxis, v_ext_municipality views
-----------------------------------
CREATE OR REPLACE VIEW v_edit_element AS
SELECT e.* FROM (
SELECT element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.elementtype_id,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    concat(element_type.link_path, element.link) AS link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id,
    element.pol_id,
    element.lastupdate,
    element.lastupdate_user,
    element.top_elev,
    element.expl_id2,
    element.trace_featuregeom,
	element.muni_id,
	element.sector_id
   FROM selector_expl, element
     JOIN v_state_element ON element.element_id::text = v_state_element.element_id::text
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     JOIN element_type ON element_type.id::text = cat_element.elementtype_id::text
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text) e
  join selector_sector s using (sector_id)
  LEFT JOIN selector_municipality m using (muni_id)
  where s.cur_user = current_user
  and (m.cur_user = current_user or e.muni_id is null);

CREATE OR REPLACE VIEW v_edit_samplepoint AS
SELECT sm.* FROM (
SELECT
    samplepoint.sample_id,
    samplepoint.code,
    samplepoint.lab_code,
    samplepoint.feature_id,
    samplepoint.featurecat_id,
    samplepoint.expl_id,
    samplepoint.muni_id,
    samplepoint.sector_id,
    samplepoint.dma_id,
    dma.macrodma_id,
    samplepoint.state,
    samplepoint.builtdate,
    samplepoint.enddate,
    samplepoint.workcat_id,
    samplepoint.workcat_id_end,
    samplepoint.rotation,
    samplepoint.postcode,
    samplepoint.district_id,
    samplepoint.streetaxis_id,
    samplepoint.postnumber,
    samplepoint.postcomplement,
    samplepoint.streetaxis2_id,
    samplepoint.postnumber2,
    samplepoint.postcomplement2,
    samplepoint.place_name,
    samplepoint.cabinet,
    samplepoint.observations,
    samplepoint.verified,
    samplepoint.link,
    samplepoint.the_geom
    FROM selector_expl, samplepoint
    JOIN v_state_samplepoint ON samplepoint.sample_id::text = v_state_samplepoint.sample_id::text
    LEFT JOIN dma ON dma.dma_id = samplepoint.dma_id
	WHERE samplepoint.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text) sm
	join selector_sector s using (sector_id)
    LEFT JOIN selector_municipality m using (muni_id)
    where s.cur_user = current_user
    and (m.cur_user = current_user or sm.muni_id is null);

DO $$
DECLARE
    v_utils boolean;
BEGIN
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	 IF v_utils IS true THEN
        CREATE OR REPLACE VIEW ext_streetaxis
        AS SELECT streetaxis.id,
            streetaxis.code,
            streetaxis.type,
            streetaxis.name,
            streetaxis.text,
            streetaxis.the_geom,
            streetaxis.ud_expl_id AS expl_id,
            streetaxis.muni_id
        FROM utils.streetaxis;
    END IF;
END; $$;

CREATE OR REPLACE VIEW v_ext_address
AS SELECT ext_address.id,
    ext_address.muni_id,
    ext_address.postcode,
    ext_address.streetaxis_id,
    ext_address.postnumber,
    ext_address.plot_id,
    ext_address.expl_id,
    ext_streetaxis.name,
    ext_address.the_geom
   FROM selector_expl,
    ext_address
     LEFT JOIN ext_streetaxis ON ext_streetaxis.id::text = ext_address.streetaxis_id::text
  WHERE ext_address.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ext_streetaxis
AS SELECT ext_streetaxis.id,
    ext_streetaxis.code,
    ext_streetaxis.type,
    ext_streetaxis.name,
    ext_streetaxis.text,
    ext_streetaxis.the_geom,
    ext_streetaxis.expl_id,
    ext_streetaxis.muni_id,
        CASE
            WHEN ext_streetaxis.type IS NULL THEN ext_streetaxis.name::text
            WHEN ext_streetaxis.text IS NULL THEN ((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '.'::text
            WHEN ext_streetaxis.type IS NULL AND ext_streetaxis.text IS NULL THEN ext_streetaxis.name::text
            ELSE (((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '. '::text) || ext_streetaxis.text
        END AS descript
   FROM selector_municipality s, ext_streetaxis
   WHERE ext_streetaxis.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ext_municipality
AS SELECT DISTINCT s.muni_id,
    m.name,
    m.active,
    m.the_geom
    FROM ext_municipality m, selector_municipality s
	WHERE m.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vu_link
AS SELECT DISTINCT ON (link_id)
	l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
	e.macroexpl_id,
    l.sector_id,
    s.sector_type,
	s.macrosector_id,
	l.muni_id,
	l.drainzone_id,
    drainzone.drainzone_type,
    l.dma_id,
	d.macrodma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
	s.name as sector_name,
	d.name as dma_name,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.connecat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user,
    l.uncertain
   FROM link l
	 LEFT JOIN exploitation e USING (expl_id)
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN dma d USING (dma_id)
	 LEFT JOIN ext_municipality m USING (muni_id)
     LEFT JOIN drainzone USING (drainzone_id);

CREATE OR REPLACE VIEW vu_link_connec AS
	SELECT l.*
	FROM link l
	WHERE l.feature_type::text = 'CONNEC'::text;

CREATE OR REPLACE VIEW vu_link_gully AS
	SELECT l.*
	FROM link l
    WHERE l.feature_type::text = 'GULLY'::text;


CREATE OR REPLACE VIEW v_edit_link AS
	SELECT l.* FROM (
	SELECT *
	FROM vu_link
    JOIN v_state_link USING (link_id)) l
	join selector_sector s using (sector_id)
	LEFT JOIN selector_municipality m using (muni_id)
	where s.cur_user = current_user and (m.cur_user = current_user or l.muni_id is null);

CREATE OR REPLACE VIEW v_edit_link_connec AS
	SELECT l.* FROM (
	SELECT l.*
	FROM vu_link_connec l) l
	join selector_sector s using (sector_id)
	LEFT JOIN selector_municipality m using (muni_id)
	where s.cur_user = current_user and (m.cur_user = current_user or l.muni_id is null);

CREATE OR REPLACE VIEW v_edit_link_gully AS
	SELECT l.* FROM (
	SELECT l.*
    FROM vu_link_connec l) l
	join selector_sector s using (sector_id)
	LEFT JOIN selector_municipality m using (muni_id)
	where s.cur_user = current_user and (m.cur_user = current_user or l.muni_id is null);

drop view if exists v_edit_drainzone;

CREATE OR REPLACE VIEW v_edit_drainzone
AS SELECT drainzone.drainzone_id,
    drainzone.name,
    drainzone.expl_id,
    drainzone.descript,
    drainzone.undelete,
    et.idval as drainzone_type,
    drainzone.link,
    drainzone.graphconfig::text AS graphconfig,
    drainzone.stylesheet::text AS stylesheet,
    drainzone.active,
    drainzone.the_geom
   FROM selector_expl,
    drainzone
    LEFT JOIN edit_typevalue et ON et.id::text = drainzone.drainzone_type::text AND et.typevalue::text = 'drainzone_type'::text
  WHERE drainzone.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


-- recreate all deleted views: arc, node, connec, gully and dependencies
-----------------------------------
CREATE OR REPLACE VIEW vu_arc AS
WITH streetaxis as (SELECT id, descript FROM v_ext_streetaxis)
SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.nodetype_1,
    arc.y1,
    arc.custom_y1,
    arc.elev1,
    arc.custom_elev1,
        CASE
            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END AS sys_elev1,
        CASE
            WHEN
            CASE
                WHEN arc.custom_y1 IS NULL THEN arc.y1
                ELSE arc.custom_y1
            END IS NULL THEN arc.node_sys_top_elev_1 - arc.sys_elev1
            ELSE
            CASE
                WHEN arc.custom_y1 IS NULL THEN arc.y1
                ELSE arc.custom_y1
            END
        END AS sys_y1,
    arc.node_sys_top_elev_1 -
        CASE
            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END - cat_arc.geom1 AS r1,
        CASE
            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END - arc.node_sys_elev_1 AS z1,
    arc.node_2,
    arc.nodetype_2,
    arc.y2,
    arc.custom_y2,
    arc.elev2,
    arc.custom_elev2,
        CASE
            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END AS sys_elev2,
        CASE
            WHEN
            CASE
                WHEN arc.custom_y2 IS NULL THEN arc.y2
                ELSE arc.custom_y2
            END IS NULL THEN arc.node_sys_top_elev_2 - arc.sys_elev2
            ELSE
            CASE
                WHEN arc.custom_y2 IS NULL THEN arc.y2
                ELSE arc.custom_y2
            END
        END AS sys_y2,
    arc.node_sys_top_elev_2 -
        CASE
            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END - cat_arc.geom1 AS r2,
        CASE
            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END - arc.node_sys_elev_2 AS z2,
    arc.sys_slope AS slope,
    arc.arc_type,
    cat_feature.system_id AS sys_type,
    arc.arccat_id,
        CASE
            WHEN arc.matcat_id IS NULL THEN cat_arc.matcat_id
            ELSE arc.matcat_id
        END AS matcat_id,
    cat_arc.shape AS cat_shape,
    cat_arc.geom1 AS cat_geom1,
    cat_arc.geom2 AS cat_geom2,
    cat_arc.width AS cat_width,
    cat_arc.area AS cat_area,
    arc.epa_type,
    arc.state,
    arc.state_type,
    arc.expl_id,
    e.macroexpl_id,
    arc.sector_id,
    s.sector_type,
    s.macrosector_id,
    arc.drainzone_id,
    drainzone.drainzone_type,
    arc.annotation,
    st_length(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.inverted_slope,
    arc.observ,
    arc.comment,
    arc.dma_id,
    m.macrodma_id,
    m.dma_type,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.workcat_id_plan,
    arc.builtdate,
    arc.enddate,
    arc.buildercat_id,
    arc.ownercat_id,
    arc.muni_id,
    arc.postcode,
    arc.district_id,
    c.descript::character varying(100) AS streetname,
    arc.postnumber,
    arc.postcomplement,
    d.descript::character varying(100) AS streetname2,
    arc.postnumber2,
    arc.postcomplement2,
    mu.region_id,
    mu.province_id,
    arc.descript,
    concat(cat_feature.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    cat_arc.label,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.label_quadrant,
    arc.publish,
    arc.inventory,
    arc.uncertain,
    arc.num_value,
    arc.asset_id,
    arc.pavcat_id,
    arc.parent_id,
    arc.expl_id2,
    vst.is_operative,
    arc.minsector_id,
    arc.macrominsector_id,
    arc.adate,
    arc.adescript,
    arc.visitability,
	date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    case when arc.sector_id > 0 and is_operative = true and epa_type !='UNDEFINED'::varchar(16) THEN epa_type else NULL::varchar(16) end as inp_type
   FROM arc
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN sector s ON s.sector_id = arc.sector_id
     JOIN exploitation e USING (expl_id)
     JOIN dma m USING (dma_id)
     LEFT JOIN streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN streetaxis d ON d.id::text = arc.streetaxis2_id::text
     LEFT JOIN value_state_type vst ON vst.id = arc.state_type
     LEFT JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
     LEFT JOIN drainzone USING (drainzone_id);

create or replace view v_edit_arc as
select a.* FROM (
select a.* FROM ( SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER) s, vu_arc a
JOIN v_state_arc USING (arc_id)
WHERE a.expl_id = s.expl_id OR a.expl_id2 = s.expl_id) a
join selector_sector s using (sector_id)
LEFT JOIN selector_municipality m using (muni_id)
where s.cur_user = current_user
and (m.cur_user = current_user or a.muni_id is null);


CREATE OR REPLACE VIEW vu_node AS
WITH vu_node AS (SELECT node.node_id,
            node.code,
            node.top_elev,
            node.custom_top_elev,
                CASE
                    WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev
                    ELSE node.top_elev
                END AS sys_top_elev,
            node.ymax,
            node.custom_ymax,
                CASE
                    WHEN node.custom_ymax IS NOT NULL THEN node.custom_ymax
                    ELSE node.ymax
                END AS sys_ymax,
            node.elev,
            node.custom_elev,
                CASE
                    WHEN node.elev IS NOT NULL AND node.custom_elev IS NULL THEN node.elev
                    WHEN node.custom_elev IS NOT NULL THEN node.custom_elev
                    ELSE NULL::numeric(12,3)
                END AS sys_elev,
            node.node_type,
            cat_feature.system_id AS sys_type,
            node.nodecat_id,
                CASE
                    WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
                    ELSE node.matcat_id
                END AS matcat_id,
            node.epa_type,
            node.expl_id,
            exploitation.macroexpl_id,
            node.sector_id,
            sector.sector_type,
            sector.macrosector_id,
            node.state,
            node.state_type,
            node.annotation,
            node.observ,
            node.comment,
            node.dma_id,
            dma.macrodma_id,
            dma.dma_type,
            node.soilcat_id,
            node.function_type,
            node.category_type,
            node.fluid_type,
            node.location_type,
            node.workcat_id,
            node.workcat_id_end,
            node.workcat_id_plan,
            node.buildercat_id,
            node.builtdate,
            node.enddate,
            node.ownercat_id,
            node.muni_id,
            node.postcode,
            node.district_id,
            c.descript::character varying(100) AS streetname,
            node.postnumber,
            node.postcomplement,
            d.descript::character varying(100) AS streetname2,
            node.postnumber2,
            node.postcomplement2,
			mu.region_id,
            mu.province_id,
            node.descript,
            cat_node.svg,
            node.rotation,
            concat(cat_feature.link_path, node.link) AS link,
            node.verified,
            node.undelete,
            cat_node.label,
            node.label_x,
            node.label_y,
            node.label_rotation,
            node.label_quadrant,
            node.publish,
            node.inventory,
            node.uncertain,
            node.xyz_date,
            node.unconnected,
            node.num_value,
            node.asset_id,
            node.drainzone_id,
            drainzone.drainzone_type,
            node.parent_id,
            node.arc_id,
            node.expl_id2,
            vst.is_operative,
            node.minsector_id,
            node.macrominsector_id,
            node.adate,
            node.adescript,
            node.placement_type,
            node.access_type,
			date_trunc('second'::text, node.tstamp) AS tstamp,
            node.insert_user,
            date_trunc('second'::text, node.lastupdate) AS lastupdate,
            node.lastupdate_user,
            node.the_geom
           FROM node
             LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
             LEFT JOIN cat_feature ON cat_feature.id::text = node.node_type::text
             LEFT JOIN dma ON node.dma_id = dma.dma_id
             LEFT JOIN sector ON node.sector_id = sector.sector_id
             LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
             LEFT JOIN v_ext_streetaxis c ON c.id::text = node.streetaxis_id::text
             LEFT JOIN v_ext_streetaxis d ON d.id::text = node.streetaxis2_id::text
             LEFT JOIN value_state_type vst ON vst.id = node.state_type
             LEFT JOIN ext_municipality mu ON node.muni_id = mu.muni_id
             LEFT JOIN drainzone USING (drainzone_id)
        ),
 streetaxis as (SELECT id, descript FROM v_ext_streetaxis)
 SELECT vu_node.node_id,
    vu_node.code,
    vu_node.top_elev,
    vu_node.custom_top_elev,
    vu_node.sys_top_elev,
    vu_node.ymax,
    vu_node.custom_ymax,
        CASE
            WHEN vu_node.sys_ymax IS NOT NULL THEN vu_node.sys_ymax
            ELSE (vu_node.sys_top_elev - vu_node.sys_elev)::numeric(12,3)
        END AS sys_ymax,
    vu_node.elev,
    vu_node.custom_elev,
        CASE
            WHEN vu_node.sys_elev IS NOT NULL THEN vu_node.sys_elev
            ELSE (vu_node.sys_top_elev - vu_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    vu_node.node_type,
    vu_node.sys_type,
    vu_node.nodecat_id,
    vu_node.matcat_id,
    vu_node.epa_type,
    vu_node.state,
    vu_node.state_type,
    vu_node.expl_id,
    vu_node.macroexpl_id,
    vu_node.sector_id,
    vu_node.sector_type,
    vu_node.macrosector_id,
    vu_node.drainzone_id,
    vu_node.drainzone_type,
    vu_node.annotation,
    vu_node.observ,
    vu_node.comment,
    vu_node.dma_id,
    vu_node.macrodma_id,
    vu_node.soilcat_id,
    vu_node.function_type,
    vu_node.category_type,
    vu_node.fluid_type,
    vu_node.location_type,
    vu_node.workcat_id,
    vu_node.workcat_id_end,
    vu_node.buildercat_id,
    vu_node.builtdate,
    vu_node.enddate,
    vu_node.ownercat_id,
    vu_node.muni_id,
    vu_node.postcode,
    vu_node.district_id,
    vu_node.streetname,
    vu_node.postnumber,
    vu_node.postcomplement,
    vu_node.streetname2,
    vu_node.postnumber2,
    vu_node.postcomplement2,
    vu_node.region_id,
    vu_node.province_id,
    vu_node.descript,
    vu_node.svg,
    vu_node.rotation,
    vu_node.link,
    vu_node.verified,
    vu_node.the_geom,
    vu_node.undelete,
    vu_node.label,
    vu_node.label_x,
    vu_node.label_y,
    vu_node.label_rotation,
    vu_node.label_quadrant,
    vu_node.publish,
    vu_node.inventory,
    vu_node.uncertain,
    vu_node.xyz_date,
    vu_node.unconnected,
    vu_node.num_value,
    vu_node.tstamp,
    vu_node.insert_user,
    vu_node.lastupdate,
    vu_node.lastupdate_user,
    vu_node.workcat_id_plan,
    vu_node.asset_id,
    vu_node.parent_id,
    vu_node.arc_id,
    vu_node.expl_id2,
    vu_node.is_operative,
    vu_node.minsector_id,
    vu_node.macrominsector_id,
    vu_node.adate,
    vu_node.adescript,
    vu_node.placement_type,
    vu_node.access_type
   FROM vu_node;

create or replace view v_edit_node as
select a.*, case when s.sector_id > 0 and is_operative = true and epa_type !='UNDEFINED'::varchar(16) THEN epa_type else NULL::varchar(16) end as inp_type
FROM ( select n.* FROM ( SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER) s, vu_node n
JOIN v_state_node USING (node_id)
WHERE n.expl_id = s.expl_id OR n.expl_id2 = s.expl_id) a
join v_sector_node s using (node_id)
LEFT JOIN selector_municipality m using (muni_id)
where (m.cur_user = current_user or a.muni_id is null);

CREATE OR REPLACE VIEW vu_connec AS
WITH streetaxis as (SELECT id, descript FROM v_ext_streetaxis)
SELECT connec.connec_id,
    connec.code,
    connec.customer_code,
    connec.top_elev,
    connec.y1,
    connec.y2,
    connec.connecat_id,
    connec.connec_type,
    cat_feature.system_id AS sys_type,
    connec.private_connecat_id,
        CASE
            WHEN connec.matcat_id IS NULL THEN cat_connec.matcat_id
            ELSE connec.matcat_id
        END AS matcat_id,
	connec.state,
    connec.state_type,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.sector_type,
    sector.macrosector_id,
	connec.drainzone_id,
    drainzone.drainzone_type,
	connec.dma_id,
    dma.macrodma_id,
    dma.dma_type,
    connec.demand,
        CASE
            WHEN ((connec.y1 + connec.y2) / 2::numeric) IS NOT NULL THEN ((connec.y1 + connec.y2) / 2::numeric)::numeric(12,3)
            ELSE connec.connec_depth
        END AS connec_depth,
    connec.connec_length,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.workcat_id_plan,
    connec.buildercat_id,
    connec.builtdate,
    connec.enddate,
    connec.ownercat_id,
    connec.muni_id,
    connec.postcode,
    connec.district_id,
    c.descript::character varying(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    d.descript::character varying(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
    mu.region_id,
    mu.province_id,
    connec.descript,
    cat_connec.svg,
    connec.rotation,
    concat(cat_feature.link_path, connec.link) AS link,
    connec.verified,
    connec.undelete,
    cat_connec.label,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.label_quadrant,
    connec.accessibility,
    connec.diagonal,
    connec.publish,
    connec.inventory,
    connec.uncertain,
    connec.num_value,
    connec.pjoint_id,
    connec.pjoint_type,
    connec.asset_id,
    connec.expl_id2,
    vst.is_operative,
    connec.minsector_id,
    connec.macrominsector_id,
    connec.adate,
    connec.adescript,
    connec.plot_code,
    connec.placement_type,
    connec.access_type,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom
   FROM connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN cat_feature ON connec.connec_type::text = cat_feature.id::text
     LEFT JOIN streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN streetaxis d ON d.id::text = connec.streetaxis2_id::text
     LEFT JOIN value_state_type vst ON vst.id = connec.state_type
     LEFT JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
     LEFT JOIN drainzone USING (drainzone_id);

CREATE OR REPLACE VIEW v_edit_connec AS
SELECT  c.* FROM (
WITH s AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.customer_code,
    vu_connec.top_elev,
    vu_connec.y1,
    vu_connec.y2,
    vu_connec.connecat_id,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.private_connecat_id,
    vu_connec.matcat_id,
	vu_connec.state,
    vu_connec.state_type,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
        CASE
            WHEN a.sector_id IS NULL THEN vu_connec.sector_id
            ELSE a.sector_id
        END AS sector_id,
    vu_connec.sector_type,
        CASE
            WHEN a.macrosector_id IS NULL THEN vu_connec.macrosector_id
            ELSE a.macrosector_id
        END AS macrosector_id,
    vu_connec.drainzone_id,
    vu_connec.drainzone_type,
    vu_connec.demand,
    vu_connec.connec_depth,
    vu_connec.connec_length,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
        CASE
            WHEN a.dma_id IS NULL THEN vu_connec.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN a.macrodma_id IS NULL THEN vu_connec.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
    vu_connec.dma_type,
    vu_connec.soilcat_id,
    vu_connec.function_type,
    vu_connec.category_type,
    vu_connec.fluid_type,
    vu_connec.location_type,
    vu_connec.workcat_id,
    vu_connec.workcat_id_end,
    vu_connec.buildercat_id,
    vu_connec.builtdate,
    vu_connec.enddate,
    vu_connec.ownercat_id,
    vu_connec.muni_id,
    vu_connec.postcode,
    vu_connec.district_id,
    vu_connec.streetname,
    vu_connec.postnumber,
    vu_connec.postcomplement,
    vu_connec.streetname2,
    vu_connec.postnumber2,
    vu_connec.postcomplement2,
	vu_connec.region_id,
    vu_connec.province_id,
    vu_connec.descript,
    vu_connec.svg,
    vu_connec.rotation,
    vu_connec.link,
    vu_connec.verified,
    vu_connec.undelete,
    vu_connec.label,
    vu_connec.label_x,
    vu_connec.label_y,
    vu_connec.label_rotation,
    vu_connec.label_quadrant,
    vu_connec.accessibility,
    vu_connec.diagonal,
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.uncertain,
    vu_connec.num_value,
        CASE
            WHEN a.exit_id IS NULL THEN vu_connec.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN a.exit_type IS NULL THEN vu_connec.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
    vu_connec.tstamp,
    vu_connec.insert_user,
    vu_connec.lastupdate,
    vu_connec.lastupdate_user,
    vu_connec.the_geom,
    vu_connec.workcat_id_plan,
    vu_connec.asset_id,
    vu_connec.expl_id2,
    vu_connec.is_operative,
    vu_connec.minsector_id,
    vu_connec.macrominsector_id,
    vu_connec.adate,
    vu_connec.adescript,
    vu_connec.plot_code,
    vu_connec.placement_type,
    vu_connec.access_type
   FROM s,
    vu_connec
     JOIN v_state_connec USING (connec_id)
     LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
            vu_link.feature_type,
            vu_link.feature_id,
            vu_link.exit_type,
            vu_link.exit_id,
            vu_link.state,
            vu_link.expl_id,
            vu_link.sector_id,
            vu_link.dma_id,
            vu_link.exit_topelev,
            vu_link.exit_elev,
            vu_link.fluid_type,
            vu_link.gis_length,
            vu_link.the_geom,
            vu_link.sector_name,
            vu_link.macrosector_id,
            vu_link.macrodma_id
           FROM vu_link,
            s s_1
          WHERE (vu_link.expl_id = s_1.expl_id OR vu_link.expl_id2 = s_1.expl_id) AND vu_link.state = 2) a ON a.feature_id::text = vu_connec.connec_id::text
	WHERE vu_connec.expl_id = s.expl_id OR vu_connec.expl_id2 = s.expl_id) c
	join selector_sector s using (sector_id)
	LEFT JOIN selector_municipality m using (muni_id)
	where s.cur_user = current_user
	and (m.cur_user = current_user or c.muni_id is null);

CREATE OR REPLACE VIEW vu_gully AS
WITH streetaxis as (SELECT id, descript FROM v_ext_streetaxis)
SELECT gully.gully_id,
    gully.code,
    gully.top_elev,
    gully.ymax,
    gully.sandbox,
    gully.matcat_id,
    gully.gully_type,
    cat_feature.system_id AS sys_type,
    gully.gratecat_id,
    cat_grate.matcat_id AS cat_grate_matcat,
    cat_grate.width AS grate_width,
    cat_grate.length AS grate_length,
    gully.units,
    gully.groove,
    gully.groove_height,
    gully.groove_length,
    gully.siphon,
    gully.connec_arccat_id,
    gully.connec_length,
    gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
    gully.connec_y2,
	CASE
		WHEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric) IS NOT NULL THEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3)
		ELSE gully.connec_depth
	END AS connec_depth,
    gully.arc_id,
    gully.epa_type,
    gully.expl_id,
    exploitation.macroexpl_id,
    gully.sector_id,
    sector.macrosector_id,
    sector.sector_type,
    gully.drainzone_id,
    drainzone.drainzone_type,
    gully.state,
    gully.state_type,
    gully.annotation,
    gully.observ,
    gully.comment,
    gully.dma_id,
    dma.macrodma_id,
    dma.dma_type,
    gully.soilcat_id,
    gully.function_type,
    gully.category_type,
    gully.fluid_type,
    gully.location_type,
    gully.workcat_id,
    gully.workcat_id_end,
    gully.workcat_id_plan,
    gully.buildercat_id,
    gully.builtdate,
    gully.enddate,
    gully.ownercat_id,
    gully.muni_id,
    gully.postcode,
    gully.district_id,
    c.descript::character varying(100) AS streetname,
    gully.postnumber,
    gully.postcomplement,
    d.descript::character varying(100) AS streetname2,
    gully.postnumber2,
    gully.postcomplement2,
    mu.region_id,
    mu.province_id,
    gully.descript,
    cat_grate.svg,
    gully.rotation,
    concat(cat_feature.link_path, gully.link) AS link,
    gully.verified,
    gully.undelete,
    cat_grate.label,
    gully.label_x,
    gully.label_y,
    gully.label_rotation,
    gully.label_quadrant,
    gully.publish,
    gully.inventory,
    gully.uncertain,
    gully.num_value,
    gully.pjoint_id,
    gully.pjoint_type,
    gully.asset_id,
        CASE
            WHEN gully.connec_matcat_id IS NULL THEN cc.matcat_id::text
            ELSE gully.connec_matcat_id
        END AS connec_matcat_id,
    gully.gratecat2_id,
    gully.units_placement,
    gully.expl_id2,
    vst.is_operative,
    gully.minsector_id,
    gully.macrominsector_id,
    gully.adate,
    gully.adescript,
    gully.siphon_type,
    gully.odorflap,
    gully.placement_type,
    gully.access_type,
	date_trunc('second'::text, gully.tstamp) AS tstamp,
    gully.insert_user,
    date_trunc('second'::text, gully.lastupdate) AS lastupdate,
    gully.lastupdate_user,
    gully.the_geom,
    case when gully.sector_id > 0 and is_operative = true and epa_type !='UNDEFINED'::varchar(16) THEN epa_type else NULL::varchar(16) end as inp_type
   FROM gully
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN exploitation ON gully.expl_id = exploitation.expl_id
     LEFT JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
     LEFT JOIN streetaxis c ON c.id::text = gully.streetaxis_id::text
     LEFT JOIN streetaxis d ON d.id::text = gully.streetaxis2_id::text
     LEFT JOIN cat_connec cc ON cc.id::text = gully.connec_arccat_id::text
     LEFT JOIN value_state_type vst ON vst.id = gully.state_type
     LEFT JOIN ext_municipality mu ON gully.muni_id = mu.muni_id
     LEFT JOIN drainzone USING (drainzone_id);

CREATE OR REPLACE VIEW v_edit_gully AS
SELECT g.* FROM (
WITH s AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT vu_gully.gully_id,
    vu_gully.code,
    vu_gully.top_elev,
    vu_gully.ymax,
    vu_gully.sandbox,
    vu_gully.matcat_id,
    vu_gully.gully_type,
    vu_gully.sys_type,
    vu_gully.gratecat_id,
    vu_gully.cat_grate_matcat,
    vu_gully.units,
    vu_gully.groove,
	vu_gully.groove_height,
    vu_gully.groove_length,
    vu_gully.siphon,
    vu_gully.connec_arccat_id,
    vu_gully.connec_length,
    vu_gully.connec_depth,
	vu_gully.connec_matcat_id,
    vu_gully.connec_y1,
    vu_gully.connec_y2,
    vu_gully.grate_width,
    vu_gully.grate_length,
	v_state_gully.arc_id,
	vu_gully.epa_type,
    vu_gully.inp_type,
	vu_gully.state,
    vu_gully.state_type,
	vu_gully.expl_id,
    vu_gully.macroexpl_id,
        CASE
            WHEN a.sector_id IS NULL THEN vu_gully.sector_id
            ELSE a.sector_id
        END AS sector_id,
    vu_gully.sector_type,
        CASE
            WHEN a.macrosector_id IS NULL THEN vu_gully.macrosector_id
            ELSE a.macrosector_id
        END AS macrosector_id,
	vu_gully.drainzone_id,
    vu_gully.drainzone_type,
	CASE
		WHEN a.dma_id IS NULL THEN vu_gully.dma_id
		ELSE a.dma_id
	END AS dma_id,
	CASE
		WHEN a.macrodma_id IS NULL THEN vu_gully.macrodma_id
		ELSE a.macrodma_id
	END AS macrodma_id,
	vu_gully.annotation,
    vu_gully.observ,
    vu_gully.comment,
    vu_gully.soilcat_id,
    vu_gully.function_type,
    vu_gully.category_type,
    vu_gully.fluid_type,
    vu_gully.location_type,
    vu_gully.workcat_id,
    vu_gully.workcat_id_end,
    vu_gully.workcat_id_plan,
    vu_gully.buildercat_id,
    vu_gully.builtdate,
    vu_gully.enddate,
    vu_gully.ownercat_id,
    vu_gully.muni_id,
    vu_gully.postcode,
    vu_gully.district_id,
    vu_gully.streetname,
    vu_gully.postnumber,
    vu_gully.postcomplement,
    vu_gully.streetname2,
    vu_gully.postnumber2,
    vu_gully.postcomplement2,
	vu_gully.region_id,
    vu_gully.province_id,
    vu_gully.descript,
    vu_gully.svg,
    vu_gully.rotation,
    vu_gully.link,
    vu_gully.verified,
    vu_gully.undelete,
    vu_gully.label,
    vu_gully.label_x,
    vu_gully.label_y,
    vu_gully.label_rotation,
    vu_gully.label_quadrant,
    vu_gully.publish,
    vu_gully.inventory,
    vu_gully.uncertain,
    vu_gully.num_value,
        CASE
            WHEN a.exit_id IS NULL THEN vu_gully.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN a.exit_type IS NULL THEN vu_gully.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
    vu_gully.asset_id,
	vu_gully.gratecat2_id,
	vu_gully.units_placement,
    vu_gully.expl_id2,
    vu_gully.is_operative,
    vu_gully.minsector_id,
    vu_gully.macrominsector_id,
    vu_gully.adate,
    vu_gully.adescript,
    vu_gully.siphon_type,
    vu_gully.odorflap,
    vu_gully.placement_type,
    vu_gully.access_type,
	vu_gully.tstamp,
    vu_gully.insert_user,
    vu_gully.lastupdate,
    vu_gully.lastupdate_user,
    vu_gully.the_geom
   FROM s,
    vu_gully
     JOIN v_state_gully USING (gully_id)
     LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
            vu_link.feature_type,
            vu_link.feature_id,
            vu_link.exit_type,
            vu_link.exit_id,
            vu_link.state,
            vu_link.expl_id,
            vu_link.sector_id,
            vu_link.dma_id,
            vu_link.exit_topelev,
            vu_link.exit_elev,
            vu_link.fluid_type,
            vu_link.gis_length,
            vu_link.the_geom,
            vu_link.sector_name,
            vu_link.macrosector_id,
            vu_link.macrodma_id
           FROM vu_link,
            s s_1
          WHERE (vu_link.expl_id = s_1.expl_id OR vu_link.expl_id2 = s_1.expl_id) AND vu_link.state = 2) a ON a.feature_id::text = vu_gully.gully_id::text
	WHERE vu_gully.expl_id = s.expl_id OR vu_gully.expl_id2 = s.expl_id) g
  	join selector_sector s using (sector_id)
	LEFT JOIN selector_municipality m using (muni_id)
	where s.cur_user = current_user
	and (m.cur_user = current_user or g.muni_id is null);


-- dependent views
CREATE OR REPLACE VIEW v_plan_aux_arc_pavement
AS SELECT plan_arc_x_pavement.arc_id,
    sum(v_price_x_catpavement.thickness * plan_arc_x_pavement.percent)::numeric(12,2) AS thickness,
    sum(v_price_x_catpavement.m2pav_cost * plan_arc_x_pavement.percent)::numeric(12,2) AS m2pav_cost,
    'Various pavements'::character varying AS pavcat_id,
    1 AS percent,
    'VARIOUS'::character varying AS price_id
   FROM plan_arc_x_pavement
     JOIN v_price_x_catpavement USING (pavcat_id)
  GROUP BY plan_arc_x_pavement.arc_id
UNION
 SELECT v_edit_arc.arc_id,
    c.thickness,
    v_price_x_catpavement.m2pav_cost,
    v_edit_arc.pavcat_id,
    1 AS percent,
    p.id AS price_id
   FROM v_edit_arc
     JOIN cat_pavement c ON c.id::text = v_edit_arc.pavcat_id::text
     JOIN v_price_x_catpavement USING (pavcat_id)
     LEFT JOIN v_price_compost p ON c.m2_cost::text = p.id::text
     LEFT JOIN ( SELECT plan_arc_x_pavement.arc_id
           FROM plan_arc_x_pavement) a USING (arc_id)
  WHERE a.arc_id IS NULL;

CREATE OR REPLACE VIEW v_plan_arc
AS SELECT d.arc_id,
    d.node_1,
    d.node_2,
    d.arc_type,
    d.arccat_id,
    d.epa_type,
    d.state,
    d.expl_id,
    d.sector_id,
    d.annotation,
    d.soilcat_id,
    d.y1,
    d.y2,
    d.mean_y,
    d.z1,
    d.z2,
    d.thickness,
    d.width,
    d.b,
    d.bulk,
    d.geom1,
    d.area,
    d.y_param,
    d.total_y,
    d.rec_y,
    d.geom1_ext,
    d.calculed_y,
    d.m3mlexc,
    d.m2mltrenchl,
    d.m2mlbottom,
    d.m2mlpav,
    d.m3mlprotec,
    d.m3mlfill,
    d.m3mlexcess,
    d.m3exc_cost,
    d.m2trenchl_cost,
    d.m2bottom_cost,
    d.m2pav_cost,
    d.m3protec_cost,
    d.m3fill_cost,
    d.m3excess_cost,
    d.cost_unit,
    d.pav_cost,
    d.exc_cost,
    d.trenchl_cost,
    d.base_cost,
    d.protec_cost,
    d.fill_cost,
    d.excess_cost,
    d.arc_cost,
    d.cost,
    d.length,
    d.budget,
    d.other_budget,
        CASE
            WHEN d.other_budget IS NOT NULL THEN (d.budget + d.other_budget)::numeric(14,2)
            ELSE d.budget
        END AS total_budget,
    d.the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT v_edit_arc.arc_id,
                            v_edit_arc.y1,
                            v_edit_arc.y2,
                                CASE
                                    WHEN (v_edit_arc.y1 * v_edit_arc.y2) = 0::numeric OR (v_edit_arc.y1 * v_edit_arc.y2) IS NULL THEN v_price_x_catarc.estimated_depth
                                    ELSE ((v_edit_arc.y1 + v_edit_arc.y2) / 2::numeric)::numeric(12,2)
                                END AS mean_y,
                            v_edit_arc.arccat_id,
                            COALESCE(v_price_x_catarc.geom1, 0::numeric)::numeric(12,4) AS geom1,
                            COALESCE(v_price_x_catarc.z1, 0::numeric)::numeric(12,2) AS z1,
                            COALESCE(v_price_x_catarc.z2, 0::numeric)::numeric(12,2) AS z2,
                            COALESCE(v_price_x_catarc.area, 0::numeric)::numeric(12,4) AS area,
                            COALESCE(v_price_x_catarc.width, 0::numeric)::numeric(12,2) AS width,
                            COALESCE(v_price_x_catarc.bulk / 1000::numeric, 0::numeric)::numeric(12,2) AS bulk,
                            v_price_x_catarc.cost_unit,
                            COALESCE(v_price_x_catarc.cost, 0::numeric)::numeric(12,2) AS arc_cost,
                            COALESCE(v_price_x_catarc.m2bottom_cost, 0::numeric)::numeric(12,2) AS m2bottom_cost,
                            COALESCE(v_price_x_catarc.m3protec_cost, 0::numeric)::numeric(12,2) AS m3protec_cost,
                            v_price_x_catsoil.id AS soilcat_id,
                            COALESCE(v_price_x_catsoil.y_param, 10::numeric)::numeric(5,2) AS y_param,
                            COALESCE(v_price_x_catsoil.b, 0::numeric)::numeric(5,2) AS b,
                            COALESCE(v_price_x_catsoil.trenchlining, 0::numeric) AS trenchlining,
                            COALESCE(v_price_x_catsoil.m3exc_cost, 0::numeric)::numeric(12,2) AS m3exc_cost,
                            COALESCE(v_price_x_catsoil.m3fill_cost, 0::numeric)::numeric(12,2) AS m3fill_cost,
                            COALESCE(v_price_x_catsoil.m3excess_cost, 0::numeric)::numeric(12,2) AS m3excess_cost,
                            COALESCE(v_price_x_catsoil.m2trenchl_cost, 0::numeric)::numeric(12,2) AS m2trenchl_cost,
                            COALESCE(v_plan_aux_arc_pavement.thickness, 0::numeric)::numeric(12,2) AS thickness,
                            COALESCE(v_plan_aux_arc_pavement.m2pav_cost, 0::numeric) AS m2pav_cost,
                            v_edit_arc.state,
                            v_edit_arc.expl_id,
                            v_edit_arc.the_geom
                           FROM v_edit_arc
                             LEFT JOIN v_price_x_catarc ON v_edit_arc.arccat_id::text = v_price_x_catarc.id::text
                             LEFT JOIN v_price_x_catsoil ON v_edit_arc.soilcat_id::text = v_price_x_catsoil.id::text
                             LEFT JOIN v_plan_aux_arc_pavement ON v_plan_aux_arc_pavement.arc_id::text = v_edit_arc.arc_id::text
                          WHERE v_plan_aux_arc_pavement.arc_id IS NOT NULL
                        )
                 SELECT v_plan_aux_arc_ml.arc_id,
                    v_plan_aux_arc_ml.y1,
                    v_plan_aux_arc_ml.y2,
                    v_plan_aux_arc_ml.mean_y,
                    v_plan_aux_arc_ml.arccat_id,
                    v_plan_aux_arc_ml.geom1,
                    v_plan_aux_arc_ml.z1,
                    v_plan_aux_arc_ml.z2,
                    v_plan_aux_arc_ml.area,
                    v_plan_aux_arc_ml.width,
                    v_plan_aux_arc_ml.bulk,
                    v_plan_aux_arc_ml.cost_unit,
                    v_plan_aux_arc_ml.arc_cost,
                    v_plan_aux_arc_ml.m2bottom_cost,
                    v_plan_aux_arc_ml.m3protec_cost,
                    v_plan_aux_arc_ml.soilcat_id,
                    v_plan_aux_arc_ml.y_param,
                    v_plan_aux_arc_ml.b,
                    v_plan_aux_arc_ml.trenchlining,
                    v_plan_aux_arc_ml.m3exc_cost,
                    v_plan_aux_arc_ml.m3fill_cost,
                    v_plan_aux_arc_ml.m3excess_cost,
                    v_plan_aux_arc_ml.m2trenchl_cost,
                    v_plan_aux_arc_ml.thickness,
                    v_plan_aux_arc_ml.m2pav_cost,
                    v_plan_aux_arc_ml.state,
                    v_plan_aux_arc_ml.expl_id,
                    (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric)::numeric(12,3) AS m2mlpavement,
                    (2::numeric * v_plan_aux_arc_ml.b + v_plan_aux_arc_ml.width)::numeric(12,3) AS m2mlbase,
                    (v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness)::numeric(12,3) AS calculed_y,
                    (v_plan_aux_arc_ml.trenchlining * 2::numeric * (v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS m2mltrenchl,
                    ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric)::numeric(12,3) AS m3mlexc,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric) - v_plan_aux_arc_ml.area)::numeric(12,3) AS m3mlprotec,
                    ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric - (v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlfill,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlexcess,
                    v_plan_aux_arc_ml.the_geom
                   FROM v_plan_aux_arc_ml
                  WHERE v_plan_aux_arc_ml.arc_id IS NOT NULL
                )
         SELECT v_plan_aux_arc_cost.arc_id,
            arc.node_1,
            arc.node_2,
            arc.arc_type,
            v_plan_aux_arc_cost.arccat_id,
            arc.epa_type,
            v_plan_aux_arc_cost.state,
            v_plan_aux_arc_cost.expl_id,
            arc.sector_id,
            arc.annotation,
            v_plan_aux_arc_cost.soilcat_id,
            v_plan_aux_arc_cost.y1,
            v_plan_aux_arc_cost.y2,
            v_plan_aux_arc_cost.mean_y,
            v_plan_aux_arc_cost.z1,
            v_plan_aux_arc_cost.z2,
            v_plan_aux_arc_cost.thickness,
            v_plan_aux_arc_cost.width,
            v_plan_aux_arc_cost.b,
            v_plan_aux_arc_cost.bulk,
            v_plan_aux_arc_cost.geom1,
            v_plan_aux_arc_cost.area,
            v_plan_aux_arc_cost.y_param,
            (v_plan_aux_arc_cost.calculed_y + v_plan_aux_arc_cost.thickness)::numeric(12,2) AS total_y,
            (v_plan_aux_arc_cost.calculed_y - 2::numeric * v_plan_aux_arc_cost.bulk - v_plan_aux_arc_cost.z1 - v_plan_aux_arc_cost.z2 - v_plan_aux_arc_cost.geom1)::numeric(12,2) AS rec_y,
            (v_plan_aux_arc_cost.geom1 + 2::numeric * v_plan_aux_arc_cost.bulk)::numeric(12,2) AS geom1_ext,
            v_plan_aux_arc_cost.calculed_y,
            v_plan_aux_arc_cost.m3mlexc,
            v_plan_aux_arc_cost.m2mltrenchl,
            v_plan_aux_arc_cost.m2mlbase AS m2mlbottom,
            v_plan_aux_arc_cost.m2mlpavement AS m2mlpav,
            v_plan_aux_arc_cost.m3mlprotec,
            v_plan_aux_arc_cost.m3mlfill,
            v_plan_aux_arc_cost.m3mlexcess,
            v_plan_aux_arc_cost.m3exc_cost,
            v_plan_aux_arc_cost.m2trenchl_cost,
            v_plan_aux_arc_cost.m2bottom_cost,
            v_plan_aux_arc_cost.m2pav_cost::numeric(12,2) AS m2pav_cost,
            v_plan_aux_arc_cost.m3protec_cost,
            v_plan_aux_arc_cost.m3fill_cost,
            v_plan_aux_arc_cost.m3excess_cost,
            v_plan_aux_arc_cost.cost_unit,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost
                END::numeric(12,3) AS pav_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost
                END::numeric(12,3) AS exc_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost
                END::numeric(12,3) AS trenchl_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost
                END::numeric(12,3) AS base_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost
                END::numeric(12,3) AS protec_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost
                END::numeric(12,3) AS fill_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost
                END::numeric(12,3) AS excess_cost,
            v_plan_aux_arc_cost.arc_cost::numeric(12,3) AS arc_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
                    ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost
                END::numeric(12,2) AS cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::double precision
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)
                END::numeric(12,2) AS length,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2)
                END::numeric(14,2) AS budget,
            COALESCE(v_plan_aux_arc_connec.connec_total_cost, 0::numeric) + COALESCE(v_plan_aux_arc_gully.gully_total_cost, 0::numeric) AS other_budget,
            v_plan_aux_arc_cost.the_geom
           FROM v_plan_aux_arc_cost
             JOIN arc ON v_plan_aux_arc_cost.arc_id::text = arc.arc_id::text
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (min(p.price) * count(*)::numeric)::numeric(12,2) AS connec_total_cost
                   FROM v_edit_connec c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id::text = v_plan_aux_arc_cost.arc_id::text
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (min(p.price) * count(*)::numeric)::numeric(12,2) AS gully_total_cost
                   FROM v_edit_gully c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id) v_plan_aux_arc_gully ON v_plan_aux_arc_gully.arc_id::text = v_plan_aux_arc_cost.arc_id::text) d;


CREATE OR REPLACE VIEW v_ext_raster_dem
AS SELECT DISTINCT ON (r.id) r.id,
    c.code,
    c.alias,
    c.raster_type,
    c.descript,
    c.source,
    c.provider,
    c.year,
    r.rast,
    r.rastercat_id,
    r.envelope
    FROM v_ext_municipality a, ext_raster_dem r
    JOIN ext_cat_raster c ON c.id = r.rastercat_id
    WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);


CREATE OR REPLACE VIEW ve_pol_element
AS SELECT e.pol_id,
    e.element_id,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM v_edit_element e
    JOIN polygon USING (pol_id);

CREATE OR REPLACE VIEW v_ui_element_x_node
AS SELECT element_x_node.id,
    element_x_node.node_id,
    element_x_node.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_node
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_node.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_connec
AS SELECT element_x_connec.id,
    element_x_connec.connec_id,
    element_x_connec.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_connec
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_connec.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_arc
AS SELECT element_x_arc.id,
    element_x_arc.arc_id,
    element_x_arc.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_arc
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_arc.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_gully
AS SELECT element_x_gully.id,
    element_x_gully.gully_id,
    element_x_gully.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate
   FROM element_x_gully
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_gully.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_arc_x_relations
AS WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id::text = l.exit_id::text
          WHERE l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,
    v_edit_connec.arc_id,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS catalog,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code AS feature_code,
    v_edit_connec.sys_type,
    a.state AS arc_state,
    v_edit_connec.state AS feature_state,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM v_edit_connec
     JOIN link l ON v_edit_connec.connec_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id::text = v_edit_connec.arc_id::text
  WHERE v_edit_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.connecat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state AS arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_edit_connec c ON c.connec_id::text = n.feature_id::text
UNION
 SELECT row_number() OVER () + 3000000 AS rid,
    v_edit_gully.arc_id,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.gratecat_id AS catalog,
    v_edit_gully.gully_id AS feature_id,
    v_edit_gully.code AS feature_code,
    v_edit_gully.sys_type,
    a.state AS arc_state,
    v_edit_gully.state AS feature_state,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM v_edit_gully
     JOIN link l ON v_edit_gully.gully_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id::text = v_edit_gully.arc_id::text
  WHERE v_edit_gully.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (g.gully_id) row_number() OVER () + 4000000 AS rid,
    a.arc_id,
    g.gully_type AS featurecat_id,
    g.gratecat_id AS catalog,
    g.gully_id AS feature_id,
    g.code AS feature_code,
    g.sys_type,
    a.state AS arc_state,
    g.state AS feature_state,
    st_x(g.the_geom) AS x,
    st_y(g.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_edit_gully g ON g.gully_id::text = n.feature_id::text;


CREATE OR REPLACE VIEW ve_pol_connec
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN v_edit_connec ON polygon.feature_id::text = v_edit_connec.connec_id::text;


CREATE OR REPLACE VIEW v_rtc_period_hydrometer
AS SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    NULL::character varying(16) AS pjoint_id,
    temp_arc.node_1,
    temp_arc.node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_arc ON v_edit_connec.arc_id::text = temp_arc.arc_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND c.dma_id::integer = v_edit_connec.dma_id
  WHERE ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON concat('VN', v_edit_connec.pjoint_id) = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'VNODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON v_edit_connec.pjoint_id::text = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'NODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text));

CREATE OR REPLACE VIEW v_rtc_period_node
AS SELECT a.node_id,
    a.dma_id,
    a.period_id,
    sum(a.lps_avg) AS lps_avg,
    a.effc,
    sum(a.lps_avg_real) AS lps_avg_real,
    a.minc,
    sum(a.lps_min) AS lps_min,
    a.maxc,
    sum(a.lps_max) AS lps_max,
    sum(a.m3_total_period) AS m3_total_period
   FROM ( SELECT v_rtc_period_hydrometer.node_1 AS node_id,
            v_rtc_period_hydrometer.dma_id,
            v_rtc_period_hydrometer.period_id,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
            v_rtc_period_hydrometer.effc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
            v_rtc_period_hydrometer.minc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
            v_rtc_period_hydrometer.maxc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
            sum(v_rtc_period_hydrometer.m3_total_period * 0.5::double precision) AS m3_total_period
           FROM v_rtc_period_hydrometer
          WHERE v_rtc_period_hydrometer.pjoint_id IS NULL
          GROUP BY v_rtc_period_hydrometer.node_1, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc
        UNION
         SELECT v_rtc_period_hydrometer.node_2 AS node_id,
            v_rtc_period_hydrometer.dma_id,
            v_rtc_period_hydrometer.period_id,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
            v_rtc_period_hydrometer.effc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
            v_rtc_period_hydrometer.minc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
            v_rtc_period_hydrometer.maxc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
            sum(v_rtc_period_hydrometer.m3_total_period * 0.5::double precision) AS m3_total_period
           FROM v_rtc_period_hydrometer
          WHERE v_rtc_period_hydrometer.pjoint_id IS NULL
          GROUP BY v_rtc_period_hydrometer.node_2, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc) a
  GROUP BY a.node_id, a.period_id, a.dma_id, a.effc, a.minc, a.maxc;

CREATE OR REPLACE VIEW v_rtc_period_dma
AS SELECT v_rtc_period_hydrometer.dma_id::integer AS dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.m3_total_period) AS m3_total_period,
    a.pattern_id
   FROM v_rtc_period_hydrometer
     JOIN ext_rtc_dma_period a ON a.dma_id::text = v_rtc_period_hydrometer.dma_id::text AND v_rtc_period_hydrometer.period_id::text = a.cat_period_id::text
  GROUP BY v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.period_id, a.pattern_id;


CREATE OR REPLACE VIEW v_ui_element
AS SELECT element.element_id AS id,
    element.code,
    element.elementcat_id,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.num_elements,
    element.state,
    element.state_type,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.fluid_type,
    element.location_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    element.link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.undelete,
    element.publish,
    element.inventory,
    element.expl_id,
    element.feature_type,
    element.tstamp
   FROM element;


CREATE OR REPLACE VIEW v_edit_inp_conduit
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.matcat_id,
    v_edit_arc.cat_shape,
    v_edit_arc.cat_geom1,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
    inp_conduit.barrels,
    inp_conduit.culvert,
    inp_conduit.kentry,
    inp_conduit.kexit,
    inp_conduit.kavg,
    inp_conduit.flap,
    inp_conduit.q0,
    inp_conduit.qmax,
    inp_conduit.seepage,
    inp_conduit.custom_n,
    v_edit_arc.the_geom
    FROM v_edit_arc
    JOIN inp_conduit USING (arc_id)
	WHERE v_edit_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_conduit
AS SELECT f.dscenario_id,
    arc_id,
    f.arccat_id,
    f.matcat_id,
    f.elev1,
    f.elev2,
    f.custom_n,
    f.barrels,
    f.culvert,
    f.kentry,
    f.kexit,
    f.kavg,
    f.flap,
    f.q0,
    f.qmax,
    f.seepage,
    v_edit_inp_conduit.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_conduit f
    JOIN v_edit_inp_conduit USING (arc_id)
	WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW ve_pol_node
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text;

CREATE OR REPLACE VIEW ve_pol_storage
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text
	WHERE polygon.sys_type::text = 'STORAGE'::text;

CREATE OR REPLACE VIEW ve_pol_wwtp
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text
   WHERE polygon.sys_type::text = 'WWTP'::text;

CREATE OR REPLACE VIEW vi_coverages
AS SELECT v_edit_inp_subcatchment.subc_id,
    inp_coverage.landus_id,
    inp_coverage.percent
   FROM inp_coverage
     JOIN v_edit_inp_subcatchment ON inp_coverage.subc_id::text = v_edit_inp_subcatchment.subc_id::text
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_edit_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
            inp_subcatchment.subc_id,
            inp_subcatchment.outlet_id,
            inp_subcatchment.rg_id,
            inp_subcatchment.area,
            inp_subcatchment.imperv,
            inp_subcatchment.width,
            inp_subcatchment.slope,
            inp_subcatchment.clength,
            inp_subcatchment.snow_id,
            inp_subcatchment.nimp,
            inp_subcatchment.nperv,
            inp_subcatchment.simp,
            inp_subcatchment.sperv,
            inp_subcatchment.zero,
            inp_subcatchment.routeto,
            inp_subcatchment.rted,
            inp_subcatchment.maxrate,
            inp_subcatchment.minrate,
            inp_subcatchment.decay,
            inp_subcatchment.drytime,
            inp_subcatchment.maxinfil,
            inp_subcatchment.suction,
            inp_subcatchment.conduct,
            inp_subcatchment.initdef,
            inp_subcatchment.curveno,
            inp_subcatchment.conduct_2,
            inp_subcatchment.drytime_2,
            inp_subcatchment.sector_id,
            inp_subcatchment.hydrology_id,
            inp_subcatchment.the_geom,
            inp_subcatchment.descript
            FROM inp_subcatchment
            WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
    JOIN v_edit_node ON v_edit_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text;

CREATE OR REPLACE VIEW vi_groundwater
AS SELECT inp_groundwater.subc_id,
    inp_groundwater.aquif_id,
    inp_groundwater.node_id,
    inp_groundwater.surfel,
    inp_groundwater.a1,
    inp_groundwater.b1,
    inp_groundwater.a2,
    inp_groundwater.b2,
    inp_groundwater.a3,
    inp_groundwater.tw,
    inp_groundwater.h
   FROM v_edit_inp_subcatchment
     JOIN inp_groundwater ON inp_groundwater.subc_id::text = v_edit_inp_subcatchment.subc_id::text
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_edit_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
            inp_subcatchment.subc_id,
            inp_subcatchment.outlet_id,
            inp_subcatchment.rg_id,
            inp_subcatchment.area,
            inp_subcatchment.imperv,
            inp_subcatchment.width,
            inp_subcatchment.slope,
            inp_subcatchment.clength,
            inp_subcatchment.snow_id,
            inp_subcatchment.nimp,
            inp_subcatchment.nperv,
            inp_subcatchment.simp,
            inp_subcatchment.sperv,
            inp_subcatchment.zero,
            inp_subcatchment.routeto,
            inp_subcatchment.rted,
            inp_subcatchment.maxrate,
            inp_subcatchment.minrate,
            inp_subcatchment.decay,
            inp_subcatchment.drytime,
            inp_subcatchment.maxinfil,
            inp_subcatchment.suction,
            inp_subcatchment.conduct,
            inp_subcatchment.initdef,
            inp_subcatchment.curveno,
            inp_subcatchment.conduct_2,
            inp_subcatchment.drytime_2,
            inp_subcatchment.sector_id,
            inp_subcatchment.hydrology_id,
            inp_subcatchment.the_geom,
            inp_subcatchment.descript
           FROM inp_subcatchment
          WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
         JOIN v_edit_node ON v_edit_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text;

CREATE OR REPLACE VIEW ve_pol_chamber
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
	JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text
    WHERE polygon.sys_type::text = 'CHAMBER'::text;

CREATE OR REPLACE VIEW ve_pol_netgully
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
	JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text
    WHERE polygon.sys_type::text = 'NETGULLY'::text;

CREATE OR REPLACE VIEW v_plan_node
AS SELECT a.node_id,
    a.nodecat_id,
    a.node_type,
    a.top_elev,
    a.elev,
    a.epa_type,
    a.state,
    a.sector_id,
    a.expl_id,
    a.annotation,
    a.cost_unit,
    a.descript,
    a.cost,
    a.measurement,
    a.budget,
    a.the_geom
   FROM ( SELECT v_edit_node.node_id,
            v_edit_node.nodecat_id,
            v_edit_node.sys_type AS node_type,
            v_edit_node.top_elev,
            v_edit_node.elev,
            v_edit_node.epa_type,
            v_edit_node.state,
            v_edit_node.sector_id,
            v_edit_node.expl_id,
            v_edit_node.annotation,
            v_price_x_catnode.cost_unit,
            v_price_compost.descript,
            v_price_compost.price AS cost,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN 1::numeric
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'STORAGE'::text THEN man_storage.max_volume
                        WHEN v_edit_node.sys_type::text = 'CHAMBER'::text THEN man_chamber.max_volume
                        ELSE NULL::numeric
                    END
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.ymax = 0::numeric THEN v_price_x_catnode.estimated_y
                        WHEN v_edit_node.ymax IS NULL THEN v_price_x_catnode.estimated_y
                        ELSE v_edit_node.ymax
                    END
                    ELSE NULL::numeric
                END::numeric(12,2) AS measurement,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN v_price_x_catnode.cost
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'STORAGE'::text THEN man_storage.max_volume * v_price_x_catnode.cost
                        WHEN v_edit_node.sys_type::text = 'CHAMBER'::text THEN man_chamber.max_volume * v_price_x_catnode.cost
                        ELSE NULL::numeric
                    END
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.ymax = 0::numeric THEN v_price_x_catnode.estimated_y * v_price_x_catnode.cost
                        WHEN v_edit_node.ymax IS NULL THEN v_price_x_catnode.estimated_y * v_price_x_catnode.cost
                        ELSE v_edit_node.ymax * v_price_x_catnode.cost
                    END
                    ELSE NULL::numeric
                END::numeric(12,2) AS budget,
            v_edit_node.the_geom
           FROM v_edit_node
             LEFT JOIN v_price_x_catnode ON v_edit_node.nodecat_id::text = v_price_x_catnode.id::text
             LEFT JOIN man_chamber ON man_chamber.node_id::text = v_edit_node.node_id::text
             LEFT JOIN man_storage ON man_storage.node_id::text = v_edit_node.node_id::text
             LEFT JOIN cat_node ON cat_node.id::text = v_edit_node.nodecat_id::text
             LEFT JOIN v_price_compost ON v_price_compost.id::text = cat_node.cost::text) a;

CREATE OR REPLACE VIEW v_ui_plan_node_cost
AS SELECT node.node_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_node.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost,
    NULL::double precision AS length
   FROM node
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN v_price_compost ON cat_node.cost::text = v_price_compost.id::text
     JOIN v_plan_node ON node.node_id::text = v_plan_node.node_id::text;

CREATE OR REPLACE VIEW v_plan_result_node
AS SELECT plan_rec_result_node.node_id,
    plan_rec_result_node.nodecat_id,
    plan_rec_result_node.node_type,
    plan_rec_result_node.top_elev,
    plan_rec_result_node.elev,
    plan_rec_result_node.epa_type,
    plan_rec_result_node.state,
    plan_rec_result_node.sector_id,
    plan_rec_result_node.expl_id,
    plan_rec_result_node.cost_unit,
    plan_rec_result_node.descript,
    plan_rec_result_node.measurement,
    plan_rec_result_node.cost,
    plan_rec_result_node.budget,
    plan_rec_result_node.the_geom,
    plan_rec_result_node.builtcost,
    plan_rec_result_node.builtdate,
    plan_rec_result_node.age,
    plan_rec_result_node.acoeff,
    plan_rec_result_node.aperiod,
    plan_rec_result_node.arate,
    plan_rec_result_node.amortized,
    plan_rec_result_node.pending
   FROM selector_expl,
    selector_plan_result,
    plan_rec_result_node
  WHERE plan_rec_result_node.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND plan_rec_result_node.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = "current_user"()::text AND plan_rec_result_node.state = 1
UNION
 SELECT v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.node_type,
    v_plan_node.top_elev,
    v_plan_node.elev,
    v_plan_node.epa_type,
    v_plan_node.state,
    v_plan_node.sector_id,
    v_plan_node.expl_id,
    v_plan_node.cost_unit,
    v_plan_node.descript,
    v_plan_node.measurement,
    v_plan_node.cost,
    v_plan_node.budget,
    v_plan_node.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_node
  WHERE v_plan_node.state = 2;

CREATE OR REPLACE VIEW v_plan_psector_budget_node
AS SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
    plan_psector_x_node.psector_id,
    plan_psector.psector_type,
    v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.cost::numeric(12,2) AS cost,
    v_plan_node.measurement,
    v_plan_node.budget AS total_budget,
    v_plan_node.state,
    v_plan_node.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_node.doable,
    plan_psector.priority,
    v_plan_node.the_geom
   FROM v_plan_node
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id
  WHERE plan_psector_x_node.doable = true
  ORDER BY plan_psector_x_node.psector_id;

CREATE OR REPLACE VIEW v_edit_inp_outfall
AS SELECT v_edit_node.node_id,
    v_edit_node.top_elev,
    v_edit_node.custom_top_elev,
    v_edit_node.ymax,
    v_edit_node.custom_ymax,
    v_edit_node.elev,
    v_edit_node.custom_elev,
    v_edit_node.sys_elev,
    v_edit_node.nodecat_id,
    v_edit_node.sector_id,
    v_edit_node.macrosector_id,
    v_edit_node.state,
    v_edit_node.state_type,
    v_edit_node.annotation,
    v_edit_node.expl_id,
    inp_outfall.outfall_type,
    inp_outfall.stage,
    inp_outfall.curve_id,
    inp_outfall.timser_id,
    inp_outfall.gate,
    v_edit_node.the_geom
    FROM v_edit_node
    JOIN inp_outfall USING (node_id)
	WHERE v_edit_node.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_storage
AS SELECT v_edit_node.node_id,
    v_edit_node.top_elev,
    v_edit_node.custom_top_elev,
    v_edit_node.ymax,
    v_edit_node.custom_ymax,
    v_edit_node.elev,
    v_edit_node.custom_elev,
    v_edit_node.sys_elev,
    v_edit_node.nodecat_id,
    v_edit_node.sector_id,
    v_edit_node.macrosector_id,
    v_edit_node.state,
    v_edit_node.state_type,
    v_edit_node.annotation,
    v_edit_node.expl_id,
    inp_storage.storage_type,
    inp_storage.curve_id,
    inp_storage.a1,
    inp_storage.a2,
    inp_storage.a0,
    inp_storage.fevap,
    inp_storage.sh,
    inp_storage.hc,
    inp_storage.imd,
    inp_storage.y0,
    inp_storage.ysur,
    inp_storage.apond,
    v_edit_node.the_geom
    FROM v_edit_node
    JOIN inp_storage USING (node_id)
    WHERE v_edit_node.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_netgully
AS SELECT n.node_id,
    n.code,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.custom_ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.node_type,
    n.nodecat_id,
    man_netgully.gratecat_id,
    (cat_grate.width / 100::numeric)::numeric(12,3) AS grate_width,
    (cat_grate.length / 100::numeric)::numeric(12,3) AS grate_length,
    n.sector_id,
    n.macrosector_id,
    n.expl_id,
    n.state,
    n.state_type,
    n.the_geom,
    man_netgully.units,
    man_netgully.units_placement,
    man_netgully.groove,
    man_netgully.groove_height,
    man_netgully.groove_length,
    cat_grate.a_param,
    cat_grate.b_param,
        CASE
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.length / 100::numeric)::numeric(12,3)
        END AS total_length,
    n.ymax - COALESCE(man_netgully.sander_depth, 0::numeric) AS depth,
    n.annotation,
    i.y0,
    i.ysur,
    i.apond,
    i.outlet_type,
    i.custom_width,
    i.custom_length,
    i.custom_depth,
    i.method,
    i.weir_cd,
    i.orifice_cd,
    i.custom_a_param,
    i.custom_b_param,
    i.efficiency
    FROM v_edit_node n
    JOIN inp_netgully i USING (node_id)
    LEFT JOIN man_netgully USING (node_id)
    LEFT JOIN cat_grate ON man_netgully.gratecat_id::text = cat_grate.id::text
    WHERE n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_divider
AS SELECT v_edit_node.node_id,
    v_edit_node.top_elev,
    v_edit_node.custom_top_elev,
    v_edit_node.ymax,
    v_edit_node.custom_ymax,
    v_edit_node.elev,
    v_edit_node.custom_elev,
    v_edit_node.sys_elev,
    v_edit_node.nodecat_id,
    v_edit_node.sector_id,
    v_edit_node.macrosector_id,
    v_edit_node.state,
    v_edit_node.state_type,
    v_edit_node.annotation,
    v_edit_node.expl_id,
    inp_divider.divider_type,
    inp_divider.arc_id,
    inp_divider.curve_id,
    inp_divider.qmin,
    inp_divider.ht,
    inp_divider.cd,
    inp_divider.y0,
    inp_divider.ysur,
    inp_divider.apond,
    v_edit_node.the_geom
    FROM v_edit_node
    JOIN inp_divider ON v_edit_node.node_id::text = inp_divider.node_id::text
	WHERE is_operative = TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_storage
AS SELECT s.dscenario_id,
    f.node_id,
    f.elev,
    f.ymax,
    f.storage_type,
    f.curve_id,
    f.a1,
    f.a2,
    f.a0,
    f.fevap,
    f.sh,
    f.hc,
    f.imd,
    f.y0,
    f.ysur,
    f.apond,
    v_edit_inp_storage.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_storage f
    JOIN v_edit_inp_storage USING (node_id)
	WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_outfall
AS SELECT s.dscenario_id,
    f.node_id,
    f.elev,
    f.ymax,
    f.outfall_type,
    f.stage,
    f.curve_id,
    f.timser_id,
    f.gate,
    v_edit_inp_outfall.the_geom
    FROM selector_inp_dscenario s,
    inp_dscenario_outfall f
    JOIN v_edit_inp_outfall USING (node_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_edit_inp_junction
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.custom_ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_junction USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_treatment
AS SELECT node_id,
    inp_treatment.poll_id,
    inp_treatment.function
   FROM inp_treatment
     JOIN v_edit_inp_junction USING (node_id);

CREATE OR REPLACE VIEW v_edit_inp_inflows_poll
AS SELECT node_id,
    inp_inflows_poll.poll_id,
    inp_inflows_poll.timser_id,
    inp_inflows_poll.form_type,
    inp_inflows_poll.mfactor,
    inp_inflows_poll.sfactor,
    inp_inflows_poll.base,
    inp_inflows_poll.pattern_id
   FROM inp_inflows_poll
     JOIN v_edit_inp_junction USING (node_id);

CREATE OR REPLACE VIEW v_edit_inp_inflows
AS SELECT node_id,
    inp_inflows.order_id,
    inp_inflows.timser_id,
    inp_inflows.sfactor,
    inp_inflows.base,
    inp_inflows.pattern_id
    FROM inp_inflows
    JOIN v_edit_inp_junction USING (node_id);

CREATE OR REPLACE VIEW v_edit_inp_dwf
AS SELECT i.dwfscenario_id,
    node_id,
    i.value,
    i.pat1,
    i.pat2,
    i.pat3,
    i.pat4
    FROM config_param_user c,  inp_dwf i
    JOIN v_edit_inp_junction USING (node_id)
    WHERE c.cur_user::name = CURRENT_USER AND c.parameter::text = 'inp_options_dwfscenario'::text
    AND c.value::integer = i.dwfscenario_id;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_treatment
AS SELECT s.dscenario_id,
    node_id,
    f.poll_id,
    f.function
    FROM selector_inp_dscenario s,  inp_dscenario_treatment f
    JOIN v_edit_inp_junction USING (node_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_junction
AS SELECT f.dscenario_id,
    node_id,
    f.elev,
    f.ymax,
    f.y0,
    f.ysur,
    f.apond,
    f.outfallparam,
    v_edit_inp_junction.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_junction f
    JOIN v_edit_inp_junction USING (node_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_inflows_poll
AS SELECT s.dscenario_id,
    node_id,
    f.poll_id,
    f.timser_id,
    f.form_type,
    f.mfactor,
    f.sfactor,
    f.base,
    f.pattern_id
    FROM selector_inp_dscenario s, inp_dscenario_inflows_poll f
    JOIN v_edit_inp_junction USING (node_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_inflows
AS SELECT s.dscenario_id,
    node_id,
    f.order_id,
    f.timser_id,
    f.sfactor,
    f.base,
    f.pattern_id
    FROM selector_inp_dscenario s,
    inp_dscenario_inflows f
    JOIN v_edit_inp_junction USING (node_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_edit_inp_flwreg_outlet
AS SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.outlet_type,
    f.offsetval,
    f.curve_id,
    f.cd1,
    f.cd2,
    f.flap,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE) AS the_geom
    FROM inp_flwreg_outlet f
    JOIN v_edit_node n USING (node_id)
    JOIN value_state_type vs ON vs.id = n.state_type
    LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
    WHERE vs.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_flwreg_weir
AS SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.weir_type,
    f.offsetval,
    f.cd,
    f.ec,
    f.cd2,
    f.flap,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.surcharge,
    f.road_width,
    f.road_surf,
    f.coef_curve,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE) AS the_geom
    FROM inp_flwreg_weir f
    JOIN v_edit_node n USING (node_id)
    JOIN value_state_type vs ON vs.id = n.state_type
    LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
    WHERE vs.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_flwreg_pump
AS SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE) AS the_geom
    FROM inp_flwreg_pump f
    JOIN v_edit_node n USING (node_id)
    JOIN value_state_type vs ON vs.id = n.state_type
    LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
    WHERE vs.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_flwreg_orifice
AS SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.ori_type,
    f.offsetval,
    f.cd,
    f.orate,
    f.flap,
    f.shape,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.close_time,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE) AS the_geom
    FROM inp_flwreg_orifice f
    JOIN v_edit_node n USING (node_id)
    JOIN value_state_type vs ON vs.id = n.state_type
    LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
    WHERE vs.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_outlet
AS SELECT s.dscenario_id,
    f.nodarc_id,
    n.node_id,
    f.outlet_type,
    f.offsetval,
    f.curve_id,
    f.cd1,
    f.cd2,
    f.flap,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_flwreg_outlet f
    JOIN v_edit_inp_flwreg_outlet n USING (nodarc_id)
	WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_weir
AS SELECT s.dscenario_id,
    f.nodarc_id,
    n.node_id,
    f.weir_type,
    f.offsetval,
    f.cd,
    f.ec,
    f.cd2,
    f.flap,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.surcharge,
    f.road_width,
    f.road_surf,
    f.coef_curve,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_flwreg_weir f
    JOIN v_edit_inp_flwreg_weir n USING (nodarc_id)
	WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_pump
AS SELECT s.dscenario_id,
    f.nodarc_id,
    n.node_id,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_flwreg_pump f
    JOIN v_edit_inp_flwreg_pump n USING (nodarc_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_orifice
AS SELECT s.dscenario_id,
    f.nodarc_id,
    n.node_id,
    f.ori_type,
    f.offsetval,
    f.cd,
    f.orate,
    f.flap,
    f.shape,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.close_time,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_flwreg_orifice f
    JOIN v_edit_inp_flwreg_orifice n USING (nodarc_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_edit_inp_orifice
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
    inp_orifice.ori_type,
    inp_orifice.offsetval,
    inp_orifice.cd,
    inp_orifice.orate,
    inp_orifice.flap,
    inp_orifice.shape,
    inp_orifice.geom1,
    inp_orifice.geom2,
    inp_orifice.geom3,
    inp_orifice.geom4,
    v_edit_arc.the_geom,
    inp_orifice.close_time
    FROM v_edit_arc
    JOIN inp_orifice USING (arc_id)
    WHERE is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_outlet
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
    inp_outlet.outlet_type,
    inp_outlet.offsetval,
    inp_outlet.curve_id,
    inp_outlet.cd1,
    inp_outlet.cd2,
    inp_outlet.flap,
    v_edit_arc.the_geom
    FROM v_edit_arc
    JOIN inp_outlet USING (arc_id)
	WHERE is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pump
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
    inp_pump.curve_id,
    inp_pump.status,
    inp_pump.startup,
    inp_pump.shutoff,
    v_edit_arc.the_geom
    FROM v_edit_arc
    JOIN inp_pump USING (arc_id)
    WHERE is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_virtual
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.expl_id,
    inp_virtual.fusion_node,
    inp_virtual.add_length,
    v_edit_arc.the_geom
    FROM v_edit_arc
    JOIN inp_virtual USING (arc_id)
    WHERE is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_weir
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
    inp_weir.weir_type,
    inp_weir.offsetval,
    inp_weir.cd,
    inp_weir.ec,
    inp_weir.cd2,
    inp_weir.flap,
    inp_weir.geom1,
    inp_weir.geom2,
    inp_weir.geom3,
    inp_weir.geom4,
    inp_weir.surcharge,
    v_edit_arc.the_geom,
    inp_weir.road_width,
    inp_weir.road_surf,
    inp_weir.coef_curve
    FROM v_edit_arc
    JOIN inp_weir USING (arc_id)
	WHERE is_operative IS TRUE;


CREATE OR REPLACE VIEW v_ui_workcat_x_feature
AS SELECT row_number() OVER (ORDER BY arc.arc_id) + 1000000 AS rid,
    arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    exploitation.name AS expl_name,
    arc.workcat_id,
    exploitation.expl_id
   FROM arc
     JOIN exploitation ON exploitation.expl_id = arc.expl_id
  WHERE arc.state = 1
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    exploitation.name AS expl_name,
    node.workcat_id,
    exploitation.expl_id
   FROM node
     JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE node.state = 1
UNION
 SELECT row_number() OVER (ORDER BY connec.connec_id) + 3000000 AS rid,
    connec.feature_type,
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    exploitation.name AS expl_name,
    connec.workcat_id,
    exploitation.expl_id
   FROM connec
     JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE connec.state = 1
UNION
 SELECT row_number() OVER (ORDER BY gully.gully_id) + 4000000 AS rid,
    gully.feature_type,
    gully.gratecat_id AS featurecat_id,
    gully.gully_id AS feature_id,
    gully.code,
    exploitation.name AS expl_name,
    gully.workcat_id,
    exploitation.expl_id
   FROM gully
     JOIN exploitation ON exploitation.expl_id = gully.expl_id
  WHERE gully.state = 1
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 5000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
    exploitation.expl_id
   FROM element
     JOIN exploitation ON exploitation.expl_id = element.expl_id
  WHERE element.state = 1;

CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end
AS SELECT row_number() OVER (ORDER BY v_edit_arc.arc_id) + 1000000 AS rid,
    'ARC'::character varying AS feature_type,
    v_edit_arc.arccat_id AS featurecat_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code,
    exploitation.name AS expl_name,
    v_edit_arc.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_arc
     JOIN exploitation ON exploitation.expl_id = v_edit_arc.expl_id
  WHERE v_edit_arc.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_node.node_id) + 2000000 AS rid,
    'NODE'::character varying AS feature_type,
    v_edit_node.nodecat_id AS featurecat_id,
    v_edit_node.node_id AS feature_id,
    v_edit_node.code,
    exploitation.name AS expl_name,
    v_edit_node.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_node
     JOIN exploitation ON exploitation.expl_id = v_edit_node.expl_id
  WHERE v_edit_node.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_connec.connec_id) + 3000000 AS rid,
    'CONNEC'::character varying AS feature_type,
    v_edit_connec.connecat_id AS featurecat_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code,
    exploitation.name AS expl_name,
    v_edit_connec.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_connec
     JOIN exploitation ON exploitation.expl_id = v_edit_connec.expl_id
  WHERE v_edit_connec.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_element.element_id) + 4000000 AS rid,
    'ELEMENT'::character varying AS feature_type,
    v_edit_element.elementcat_id AS featurecat_id,
    v_edit_element.element_id AS feature_id,
    v_edit_element.code,
    exploitation.name AS expl_name,
    v_edit_element.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_element
     JOIN exploitation ON exploitation.expl_id = v_edit_element.expl_id
  WHERE v_edit_element.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_gully.gully_id) + 4000000 AS rid,
    'GULLY'::character varying AS feature_type,
    v_edit_gully.gratecat_id AS featurecat_id,
    v_edit_gully.gully_id AS feature_id,
    v_edit_gully.code,
    exploitation.name AS expl_name,
    v_edit_gully.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_gully
     JOIN exploitation ON exploitation.expl_id = v_edit_gully.expl_id
  WHERE v_edit_gully.state = 0;

CREATE OR REPLACE VIEW v_ui_node_x_connection_downstream
AS SELECT row_number() OVER (ORDER BY v_edit_arc.node_1) + 1000000 AS rid,
    v_edit_arc.node_1 AS node_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y2 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type AS downstream_type,
    v_edit_arc.y1 AS downstream_depth,
    v_edit_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc'::text AS sys_table_id
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_2::text = node.node_id::text
     LEFT JOIN cat_arc ON v_edit_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON v_edit_arc.state = value_state.id;

CREATE OR REPLACE VIEW v_ui_node_x_connection_upstream
AS SELECT row_number() OVER (ORDER BY v_edit_arc.node_2) + 1000000 AS rid,
    v_edit_arc.node_2 AS node_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y1 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    v_edit_arc.y2 AS upstream_depth,
    v_edit_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc'::text AS sys_table_id
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_1::text = node.node_id::text
     LEFT JOIN cat_arc ON v_edit_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON v_edit_arc.state = value_state.id
UNION
 SELECT DISTINCT ON (v_edit_connec.connec_id) row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.node_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code::text AS feature_code,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS arccat_id,
    v_edit_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS upstream_id,
    v_edit_connec.code AS upstream_code,
    v_edit_connec.connec_type AS upstream_type,
    v_edit_connec.y2 AS upstream_depth,
    v_edit_connec.sys_type,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_connec'::text AS sys_table_id
   FROM v_edit_connec
     JOIN link ON link.feature_id::text = v_edit_connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text
     JOIN node ON v_edit_connec.pjoint_id::text = node.node_id::text AND v_edit_connec.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON v_edit_connec.connecat_id::text = cat_connec.id::text
     JOIN value_state ON v_edit_connec.state = value_state.id
UNION
 SELECT DISTINCT ON (v_edit_connec.connec_id) row_number() OVER (ORDER BY node.node_id) + 3000000 AS rid,
    node.node_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code::text AS feature_code,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS arccat_id,
    v_edit_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS upstream_id,
    v_edit_connec.code AS upstream_code,
    v_edit_connec.connec_type AS upstream_type,
    v_edit_connec.y2 AS upstream_depth,
    v_edit_connec.sys_type,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_connec'::text AS sys_table_id
   FROM v_edit_connec
     JOIN link ON link.feature_id::text = v_edit_connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text AND link.exit_type::text = 'CONNEC'::text
     JOIN connec ON connec.connec_id::text = link.exit_id::text AND connec.pjoint_type::text = 'NODE'::text
     JOIN node ON connec.pjoint_id::text = node.node_id::text
     LEFT JOIN cat_connec ON v_edit_connec.connecat_id::text = cat_connec.id::text
     JOIN value_state ON v_edit_connec.state = value_state.id
UNION
 SELECT DISTINCT ON (v_edit_gully.gully_id) row_number() OVER (ORDER BY node.node_id) + 4000000 AS rid,
    node.node_id,
    v_edit_gully.gully_id AS feature_id,
    v_edit_gully.code::text AS feature_code,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.connec_arccat_id AS arccat_id,
    v_edit_gully.ymax - v_edit_gully.sandbox AS depth,
    v_edit_gully.connec_length AS length,
    v_edit_gully.gully_id AS upstream_id,
    v_edit_gully.code AS upstream_code,
    v_edit_gully.gully_type AS upstream_type,
    v_edit_gully.connec_depth AS upstream_depth,
    v_edit_gully.sys_type,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_gully'::text AS sys_table_id
   FROM v_edit_gully
     JOIN link ON link.feature_id::text = v_edit_gully.gully_id::text AND link.feature_type::text = 'GULLY'::text
     JOIN node ON v_edit_gully.pjoint_id::text = node.node_id::text AND v_edit_gully.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON v_edit_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON v_edit_gully.state = value_state.id
UNION
 SELECT DISTINCT ON (v_edit_gully.gully_id) row_number() OVER (ORDER BY node.node_id) + 5000000 AS rid,
    node.node_id,
    v_edit_gully.gully_id AS feature_id,
    v_edit_gully.code::text AS feature_code,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.connec_arccat_id AS arccat_id,
    v_edit_gully.ymax - v_edit_gully.sandbox AS depth,
    v_edit_gully.connec_length AS length,
    v_edit_gully.gully_id AS upstream_id,
    v_edit_gully.code AS upstream_code,
    v_edit_gully.gully_type AS upstream_type,
    v_edit_gully.connec_depth AS upstream_depth,
    v_edit_gully.sys_type,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_gully'::text AS sys_table_id
   FROM v_edit_gully
     JOIN link ON link.feature_id::text = v_edit_gully.gully_id::text AND link.feature_type::text = 'GULLY'::text AND link.exit_type::text = 'GULLY'::text
     JOIN gully ON gully.gully_id::text = link.exit_id::text AND gully.pjoint_type::text = 'NODE'::text
     JOIN node ON gully.pjoint_id::text = node.node_id::text
     LEFT JOIN cat_connec ON v_edit_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON v_edit_gully.state = value_state.id;


CREATE OR REPLACE VIEW v_ui_plan_arc_cost
AS WITH p AS (
         SELECT v_plan_arc.arc_id,
            v_plan_arc.node_1,
            v_plan_arc.node_2,
            v_plan_arc.arc_type,
            v_plan_arc.arccat_id,
            v_plan_arc.epa_type,
            v_plan_arc.state,
            v_plan_arc.expl_id,
            v_plan_arc.sector_id,
            v_plan_arc.annotation,
            v_plan_arc.soilcat_id,
            v_plan_arc.y1,
            v_plan_arc.y2,
            v_plan_arc.mean_y,
            v_plan_arc.z1,
            v_plan_arc.z2,
            v_plan_arc.thickness,
            v_plan_arc.width,
            v_plan_arc.b,
            v_plan_arc.bulk,
            v_plan_arc.geom1,
            v_plan_arc.area,
            v_plan_arc.y_param,
            v_plan_arc.total_y,
            v_plan_arc.rec_y,
            v_plan_arc.geom1_ext,
            v_plan_arc.calculed_y,
            v_plan_arc.m3mlexc,
            v_plan_arc.m2mltrenchl,
            v_plan_arc.m2mlbottom,
            v_plan_arc.m2mlpav,
            v_plan_arc.m3mlprotec,
            v_plan_arc.m3mlfill,
            v_plan_arc.m3mlexcess,
            v_plan_arc.m3exc_cost,
            v_plan_arc.m2trenchl_cost,
            v_plan_arc.m2bottom_cost,
            v_plan_arc.m2pav_cost,
            v_plan_arc.m3protec_cost,
            v_plan_arc.m3fill_cost,
            v_plan_arc.m3excess_cost,
            v_plan_arc.cost_unit,
            v_plan_arc.pav_cost,
            v_plan_arc.exc_cost,
            v_plan_arc.trenchl_cost,
            v_plan_arc.base_cost,
            v_plan_arc.protec_cost,
            v_plan_arc.fill_cost,
            v_plan_arc.excess_cost,
            v_plan_arc.arc_cost,
            v_plan_arc.cost,
            v_plan_arc.length,
            v_plan_arc.budget,
            v_plan_arc.other_budget,
            v_plan_arc.total_budget,
            v_plan_arc.the_geom,
            a.id,
            a.matcat_id,
            a.shape,
            a.geom1,
            a.geom2,
            a.geom3,
            a.geom4,
            a.geom5,
            a.geom6,
            a.geom7,
            a.geom8,
            a.geom_r,
            a.descript,
            a.link,
            a.brand,
            a.model,
            a.svg,
            a.z1,
            a.z2,
            a.width,
            a.area,
            a.estimated_depth,
            a.bulk,
            a.cost_unit,
            a.cost,
            a.m2bottom_cost,
            a.m3protec_cost,
            a.active,
            a.label,
            a.tsect_id,
            a.curve_id,
            a.arc_type,
            a.acoeff,
            a.connect_cost,
            s.id,
            s.descript,
            s.link,
            s.y_param,
            s.b,
            s.trenchlining,
            s.m3exc_cost,
            s.m3fill_cost,
            s.m3excess_cost,
            s.m2trenchl_cost,
            s.active,
            a.cost AS cat_cost,
            a.m2bottom_cost AS cat_m2bottom_cost,
            a.connect_cost AS cat_connect_cost,
            a.m3protec_cost AS cat_m3_protec_cost,
            s.m3exc_cost AS cat_m3exc_cost,
            s.m3fill_cost AS cat_m3fill_cost,
            s.m3excess_cost AS cat_m3excess_cost,
            s.m2trenchl_cost AS cat_m2trenchl_cost
           FROM v_plan_arc
             JOIN cat_arc a ON a.id::text = v_plan_arc.arccat_id::text
             JOIN cat_soil s ON s.id::text = v_plan_arc.soilcat_id::text
        )
 SELECT p.arc_id,
    1 AS orderby,
    'element'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    2 AS orderby,
    'm2bottom'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mlbottom AS measurement,
    p.m2mlbottom * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m2bottom_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    3 AS orderby,
    'm3protec'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlprotec AS measurement,
    p.m3mlprotec * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3_protec_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    4 AS orderby,
    'm3exc'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexc AS measurement,
    p.m3mlexc * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3exc_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    5 AS orderby,
    'm3fill'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlfill AS measurement,
    p.m3mlfill * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3fill_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    6 AS orderby,
    'm3excess'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexcess AS measurement,
    p.m3mlexcess * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3excess_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    7 AS orderby,
    'm2trenchl'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mltrenchl AS measurement,
    p.m2mltrenchl * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m2trenchl_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    8 AS orderby,
    'pavement'::text AS identif,
        CASE
            WHEN a.price_id IS NULL THEN 'Various pavements'::character varying
            ELSE a.pavcat_id
        END AS catalog_id,
        CASE
            WHEN a.price_id IS NULL THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS price_id,
    'm2'::character varying AS unit,
        CASE
            WHEN a.price_id IS NULL THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS descript,
    a.m2pav_cost AS cost,
    1 AS measurement,
    a.m2pav_cost AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_plan_aux_arc_pavement a ON a.arc_id::text = p.arc_id::text
     JOIN cat_pavement c ON a.pavcat_id::text = c.id::text
     LEFT JOIN v_price_compost r ON a.price_id::text = c.m2_cost::text
UNION
 SELECT p.arc_id,
    9 AS orderby,
    'connec'::text AS identif,
    'Various connecs'::character varying AS catalog_id,
    'VARIOUS'::character varying AS price_id,
    'PP'::character varying AS unit,
    'Proportional cost of connec connections (pjoint cost)'::character varying AS descript,
    min(v.price) AS cost,
    count(v_edit_connec.connec_id) AS measurement,
    (min(v.price) * count(v_edit_connec.connec_id)::numeric / COALESCE(min(p.length), 1::numeric))::numeric(12,2) AS total_cost,
    min(p.length)::numeric(12,2) AS length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_connec USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
UNION
 SELECT p.arc_id,
    10 AS orderby,
    'connec'::text AS identif,
    'Various connecs'::character varying AS catalog_id,
    'VARIOUS'::character varying AS price_id,
    'PP'::character varying AS unit,
    'Proportional cost of gully connections (pjoint cost)'::character varying AS descript,
    min(v.price) AS cost,
    count(v_edit_gully.gully_id) AS measurement,
    (min(v.price) * count(v_edit_gully.gully_id)::numeric / COALESCE(min(p.length), 1::numeric))::numeric(12,2) AS total_cost,
    min(p.length)::numeric(12,2) AS length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_gully USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
  ORDER BY 1, 2;

CREATE OR REPLACE VIEW v_plan_result_arc
AS SELECT plan_rec_result_arc.arc_id,
    plan_rec_result_arc.node_1,
    plan_rec_result_arc.node_2,
    plan_rec_result_arc.arc_type,
    plan_rec_result_arc.arccat_id,
    plan_rec_result_arc.epa_type,
    plan_rec_result_arc.state,
    plan_rec_result_arc.sector_id,
    plan_rec_result_arc.expl_id,
    plan_rec_result_arc.annotation,
    plan_rec_result_arc.soilcat_id,
    plan_rec_result_arc.y1,
    plan_rec_result_arc.y2,
    plan_rec_result_arc.mean_y,
    plan_rec_result_arc.z1,
    plan_rec_result_arc.z2,
    plan_rec_result_arc.thickness,
    plan_rec_result_arc.width,
    plan_rec_result_arc.b,
    plan_rec_result_arc.bulk,
    plan_rec_result_arc.geom1,
    plan_rec_result_arc.area,
    plan_rec_result_arc.y_param,
    plan_rec_result_arc.total_y,
    plan_rec_result_arc.rec_y,
    plan_rec_result_arc.geom1_ext,
    plan_rec_result_arc.calculed_y,
    plan_rec_result_arc.m3mlexc,
    plan_rec_result_arc.m2mltrenchl,
    plan_rec_result_arc.m2mlbottom,
    plan_rec_result_arc.m2mlpav,
    plan_rec_result_arc.m3mlprotec,
    plan_rec_result_arc.m3mlfill,
    plan_rec_result_arc.m3mlexcess,
    plan_rec_result_arc.m3exc_cost,
    plan_rec_result_arc.m2trenchl_cost,
    plan_rec_result_arc.m2bottom_cost,
    plan_rec_result_arc.m2pav_cost,
    plan_rec_result_arc.m3protec_cost,
    plan_rec_result_arc.m3fill_cost,
    plan_rec_result_arc.m3excess_cost,
    plan_rec_result_arc.cost_unit,
    plan_rec_result_arc.pav_cost,
    plan_rec_result_arc.exc_cost,
    plan_rec_result_arc.trenchl_cost,
    plan_rec_result_arc.base_cost,
    plan_rec_result_arc.protec_cost,
    plan_rec_result_arc.fill_cost,
    plan_rec_result_arc.excess_cost,
    plan_rec_result_arc.arc_cost,
    plan_rec_result_arc.cost,
    plan_rec_result_arc.length,
    plan_rec_result_arc.budget,
    plan_rec_result_arc.other_budget,
    plan_rec_result_arc.total_budget,
    plan_rec_result_arc.the_geom,
    plan_rec_result_arc.builtcost,
    plan_rec_result_arc.builtdate,
    plan_rec_result_arc.age,
    plan_rec_result_arc.acoeff,
    plan_rec_result_arc.aperiod,
    plan_rec_result_arc.arate,
    plan_rec_result_arc.amortized,
    plan_rec_result_arc.pending
   FROM selector_plan_result,
    plan_rec_result_arc
  WHERE plan_rec_result_arc.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = "current_user"()::text AND plan_rec_result_arc.state = 1
UNION
 SELECT v_plan_arc.arc_id,
    v_plan_arc.node_1,
    v_plan_arc.node_2,
    v_plan_arc.arc_type,
    v_plan_arc.arccat_id,
    v_plan_arc.epa_type,
    v_plan_arc.state,
    v_plan_arc.sector_id,
    v_plan_arc.expl_id,
    v_plan_arc.annotation,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.mean_y,
    v_plan_arc.z1,
    v_plan_arc.z2,
    v_plan_arc.thickness,
    v_plan_arc.width,
    v_plan_arc.b,
    v_plan_arc.bulk,
    v_plan_arc.geom1,
    v_plan_arc.area,
    v_plan_arc.y_param,
    v_plan_arc.total_y,
    v_plan_arc.rec_y,
    v_plan_arc.geom1_ext,
    v_plan_arc.calculed_y,
    v_plan_arc.m3mlexc,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.m2mlbottom,
    v_plan_arc.m2mlpav,
    v_plan_arc.m3mlprotec,
    v_plan_arc.m3mlfill,
    v_plan_arc.m3mlexcess,
    v_plan_arc.m3exc_cost,
    v_plan_arc.m2trenchl_cost,
    v_plan_arc.m2bottom_cost,
    v_plan_arc.m2pav_cost,
    v_plan_arc.m3protec_cost,
    v_plan_arc.m3fill_cost,
    v_plan_arc.m3excess_cost,
    v_plan_arc.cost_unit,
    v_plan_arc.pav_cost,
    v_plan_arc.exc_cost,
    v_plan_arc.trenchl_cost,
    v_plan_arc.base_cost,
    v_plan_arc.protec_cost,
    v_plan_arc.fill_cost,
    v_plan_arc.excess_cost,
    v_plan_arc.arc_cost,
    v_plan_arc.cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_arc
  WHERE v_plan_arc.state = 2;

CREATE OR REPLACE VIEW v_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  WHERE plan_psector_x_arc.doable IS TRUE
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  WHERE plan_psector_x_node.doable IS TRUE
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_psector_node
AS SELECT row_number() OVER () AS rid,
    node.node_id,
    plan_psector_x_node.psector_id,
    node.code,
    node.nodecat_id,
    node.node_type,
    cat_feature.system_id,
    node.state AS original_state,
    node.state_type AS original_state_type,
    plan_psector_x_node.state AS plan_state,
    plan_psector_x_node.doable,
    node.the_geom
   FROM selector_psector,
    node
     JOIN plan_psector_x_node USING (node_id)
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = node.node_type::text
  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_psector_connec
AS SELECT row_number() OVER () AS rid,
    connec.connec_id,
    plan_psector_x_connec.psector_id,
    connec.code,
    connec.connecat_id,
    connec.connec_type,
    cat_feature.system_id,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    connec.the_geom
   FROM selector_psector,
    connec
     JOIN plan_psector_x_connec USING (connec_id)
     JOIN cat_connec ON cat_connec.id::text = connec.connecat_id::text
     JOIN cat_feature ON cat_feature.id::text = connec.connec_type::text
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_psector_arc
AS SELECT row_number() OVER () AS rid,
    arc.arc_id,
    plan_psector_x_arc.psector_id,
    arc.code,
    arc.arccat_id,
    arc.arc_type,
    cat_feature.system_id,
    arc.state AS original_state,
    arc.state_type AS original_state_type,
    plan_psector_x_arc.state AS plan_state,
    plan_psector_x_arc.doable,
    plan_psector_x_arc.addparam::text AS addparam,
    arc.the_geom
   FROM selector_psector,
    arc
     JOIN plan_psector_x_arc USING (arc_id)
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN cat_feature ON cat_feature.id::text = arc.arc_type::text
  WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_current_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec,
    plan_psector.vat,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM config_param_user,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE config_param_user.cur_user::text = "current_user"()::text AND config_param_user.parameter::text = 'plan_psector_vdefault'::text AND config_param_user.value::integer = plan_psector.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_all
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2)::double precision + ((100::numeric + plan_psector.vat) / 100::numeric * (plan_psector.other / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.expl_id,
                    v_plan_arc.sector_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_budget
AS SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    'arc'::text AS feature_type,
    v_plan_arc.arccat_id AS featurecat_id,
    v_plan_arc.arc_id AS feature_id,
    v_plan_arc.length,
    (v_plan_arc.total_budget / v_plan_arc.length)::numeric(14,2) AS unitary_cost,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) + 9999 AS rid,
    plan_psector_x_node.psector_id,
    'node'::text AS feature_type,
    v_plan_node.nodecat_id AS featurecat_id,
    v_plan_node.node_id AS feature_id,
    1 AS length,
    v_plan_node.budget AS unitary_cost,
    v_plan_node.budget AS total_budget
   FROM v_plan_node
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
  WHERE plan_psector_x_node.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_edit_plan_psector_x_other.id) + 19999 AS rid,
    v_edit_plan_psector_x_other.psector_id,
    'other'::text AS feature_type,
    v_edit_plan_psector_x_other.price_id AS featurecat_id,
    v_edit_plan_psector_x_other.observ AS feature_id,
    v_edit_plan_psector_x_other.measurement AS length,
    v_edit_plan_psector_x_other.price AS unitary_cost,
    v_edit_plan_psector_x_other.total_budget
   FROM v_edit_plan_psector_x_other
  ORDER BY 1, 2, 4;

CREATE OR REPLACE VIEW v_plan_psector_budget_arc
AS SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    plan_psector.psector_type,
    v_plan_arc.arc_id,
    v_plan_arc.arccat_id,
    v_plan_arc.cost_unit,
    v_plan_arc.cost::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.state,
    plan_psector.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_arc.doable,
    plan_psector.priority,
    v_plan_arc.the_geom
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_budget_detail
AS SELECT v_plan_arc.arc_id,
    plan_psector_x_arc.psector_id,
    v_plan_arc.arccat_id,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.arc_cost AS mlarc_cost,
    v_plan_arc.m3mlexc,
    v_plan_arc.exc_cost AS mlexc_cost,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.trenchl_cost AS mltrench_cost,
    v_plan_arc.m2mlbottom AS m2mlbase,
    v_plan_arc.base_cost AS mlbase_cost,
    v_plan_arc.m2mlpav,
    v_plan_arc.pav_cost AS mlpav_cost,
    v_plan_arc.m3mlprotec,
    v_plan_arc.protec_cost AS mlprotec_cost,
    v_plan_arc.m3mlfill,
    v_plan_arc.fill_cost AS mlfill_cost,
    v_plan_arc.m3mlexcess,
    v_plan_arc.excess_cost AS mlexcess_cost,
    v_plan_arc.cost AS mltotal_cost,
    v_plan_arc.length,
    v_plan_arc.budget AS other_budget,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id, v_plan_arc.soilcat_id, v_plan_arc.arccat_id;


-- gully and link views
CREATE OR REPLACE VIEW v_edit_inp_gully
AS SELECT g.gully_id,
    g.code,
    g.top_elev,
    g.gully_type,
    g.gratecat_id,
    (g.grate_width / 100::numeric)::numeric(12,2) AS grate_width,
    (g.grate_length / 100::numeric)::numeric(12,2) AS grate_length,
    g.arc_id,
    g.sector_id,
    g.expl_id,
    g.state,
    g.state_type,
    g.the_geom,
    g.units,
    g.units_placement,
    g.groove,
    g.groove_height,
    g.groove_length,
    g.pjoint_id,
    g.pjoint_type,
    cat_grate.a_param,
    cat_grate.b_param,
        CASE
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.length / 100::numeric)::numeric(12,3)
        END AS total_length,
    g.ymax - COALESCE(g.sandbox, 0::numeric) AS depth,
    g.annotation,
    i.outlet_type,
    i.custom_top_elev,
    i.custom_width,
    i.custom_length,
    i.custom_depth,
    i.method,
    i.weir_cd,
    i.orifice_cd,
    i.custom_a_param,
    i.custom_b_param,
    i.efficiency
    FROM v_edit_gully g
    JOIN inp_gully i USING (gully_id)
    JOIN cat_grate ON g.gratecat_id::text = cat_grate.id::text
    WHERE is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_pol_gully
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    v_edit_gully.fluid_type,
    polygon.trace_featuregeom
    FROM polygon
    JOIN v_edit_gully ON polygon.feature_id::text = v_edit_gully.gully_id::text;

CREATE OR REPLACE VIEW vi_gully2node
AS SELECT a.gully_id,
    n.node_id,
    st_makeline(a.the_geom, n.the_geom) AS the_geom
   FROM ( SELECT g.gully_id,
                CASE
                    WHEN g.pjoint_type::text = 'NODE'::text THEN g.pjoint_id
                    ELSE a_1.node_2
                END AS node_id,
            a_1.expl_id,
            g.the_geom
           FROM v_edit_inp_gully g
             LEFT JOIN arc a_1 USING (arc_id)) a
     JOIN node n USING (node_id);


CREATE OR REPLACE VIEW v_edit_raingage AS
 SELECT raingage.rg_id,
    raingage.form_type,
    raingage.intvl,
    raingage.scf,
    raingage.rgage_type,
    raingage.timser_id,
    raingage.fname,
    raingage.sta,
    raingage.units,
    raingage.the_geom,
    raingage.expl_id,
	raingage.muni_id
    FROM selector_expl, raingage
    LEFT JOIN selector_municipality m USING (muni_id)
    WHERE raingage.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
    AND (m.cur_user = current_user or raingage.muni_id is null);


CREATE OR REPLACE VIEW v_plan_psector_gully AS
SELECT row_number() OVER () AS rid,
gully.gully_id,
plan_psector_x_gully.psector_id,
gully.code,
gully.gratecat_id,
gully.gully_type,
cat_feature.system_id,
gully.state AS original_state,
gully.state_type AS original_state_type,
plan_psector_x_gully.state AS plan_state,
plan_psector_x_gully.doable,
gully.the_geom
FROM selector_psector, gully
JOIN plan_psector_x_gully USING (gully_id)
JOIN cat_grate ON cat_grate.id=gully.gratecat_id
JOIN cat_feature ON cat_feature.id=gully.gully_type
WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_anl_pgrouting_arc;
DROP VIEW IF EXISTS v_anl_pgrouting_node;


DROP VIEW IF EXISTS v_rpt_lidperfomance_sum;
CREATE OR REPLACE VIEW v_rpt_lidperformance_sum AS
 SELECT rpt_lidperformance_sum.id,
    rpt_lidperformance_sum.result_id,
    rpt_lidperformance_sum.subc_id,
    rpt_lidperformance_sum.lidco_id,
    rpt_lidperformance_sum.tot_inflow,
    rpt_lidperformance_sum.evap_loss,
    rpt_lidperformance_sum.infil_loss,
    rpt_lidperformance_sum.surf_outf,
    rpt_lidperformance_sum.drain_outf,
    rpt_lidperformance_sum.init_stor,
    rpt_lidperformance_sum.final_stor,
    rpt_lidperformance_sum.per_error,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom
   FROM selector_rpt_main,
    (inp_subcatchment
     JOIN rpt_lidperformance_sum ON (((rpt_lidperformance_sum.subc_id)::text = (inp_subcatchment.subc_id)::text)))
  WHERE (((rpt_lidperformance_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));

DROP VIEW IF EXISTS v_rpt_comp_lidperfomance_sum;
CREATE OR REPLACE VIEW v_rpt_comp_lidperformance_sum AS
 SELECT rpt_lidperformance_sum.id,
    rpt_lidperformance_sum.result_id,
    rpt_lidperformance_sum.subc_id,
    rpt_lidperformance_sum.lidco_id,
    rpt_lidperformance_sum.tot_inflow,
    rpt_lidperformance_sum.evap_loss,
    rpt_lidperformance_sum.infil_loss,
    rpt_lidperformance_sum.surf_outf,
    rpt_lidperformance_sum.drain_outf,
    rpt_lidperformance_sum.init_stor,
    rpt_lidperformance_sum.final_stor,
    rpt_lidperformance_sum.per_error,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom
   FROM selector_rpt_compare,
    (inp_subcatchment
     JOIN rpt_lidperformance_sum ON (((rpt_lidperformance_sum.subc_id)::text = (inp_subcatchment.subc_id)::text)))
  WHERE (((rpt_lidperformance_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));

DROP VIEW IF EXISTS v_rpt_subcatchwasoff_sum;
CREATE OR REPLACE VIEW v_rpt_subcatchwashoff_sum AS
 SELECT rpt_subcatchwashoff_sum.id,
    rpt_subcatchwashoff_sum.result_id,
    rpt_subcatchwashoff_sum.subc_id,
    rpt_subcatchwashoff_sum.poll_id,
    rpt_subcatchwashoff_sum.value,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom
   FROM selector_rpt_main,
    (inp_subcatchment
     JOIN rpt_subcatchwashoff_sum ON (((rpt_subcatchwashoff_sum.subc_id)::text = (inp_subcatchment.subc_id)::text)))
  WHERE (((rpt_subcatchwashoff_sum.result_id)::text = (selector_rpt_main.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()));

DROP VIEW IF EXISTS v_rpt_comp_subcatchwasoff_sum;
CREATE OR REPLACE VIEW v_rpt_comp_subcatchwashoff_sum AS
 SELECT rpt_subcatchwashoff_sum.id,
    rpt_subcatchwashoff_sum.result_id,
    rpt_subcatchwashoff_sum.subc_id,
    rpt_subcatchwashoff_sum.poll_id,
    rpt_subcatchwashoff_sum.value,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom
   FROM selector_rpt_compare,
    (inp_subcatchment
     JOIN rpt_subcatchwashoff_sum ON (((rpt_subcatchwashoff_sum.subc_id)::text = (inp_subcatchment.subc_id)::text)))
  WHERE (((rpt_subcatchwashoff_sum.result_id)::text = (selector_rpt_compare.result_id)::text) AND (selector_rpt_compare.cur_user = "current_user"()));

UPDATE sys_fprocess SET project_type = 'ud' where fid = 522;


-- tabs arc
UPDATE config_form_tabs
    SET orderby=2
    WHERE formname='v_edit_arc' AND tabname='tab_elements';

UPDATE config_form_tabs
    SET orderby=3
    WHERE formname='v_edit_arc' AND tabname='tab_relations';

UPDATE config_form_tabs
    SET orderby=4
    WHERE formname='v_edit_arc' AND tabname='tab_event';

UPDATE config_form_tabs
    SET orderby=5
    WHERE formname='v_edit_arc' AND tabname='tab_documents';

UPDATE config_form_tabs
    SET orderby=6
    WHERE formname='v_edit_arc' AND tabname='tab_plan';

-- tabs connec
UPDATE config_form_tabs
    SET orderby=1
    WHERE formname='v_edit_connec' AND tabname='tab_elements';

UPDATE config_form_tabs
    SET orderby=2
    WHERE formname='v_edit_connec' AND tabname='tab_hydrometer';

UPDATE config_form_tabs
    SET orderby=3
    WHERE formname='v_edit_connec' AND tabname='tab_hydrometer_val';

UPDATE config_form_tabs
    SET orderby=4
    WHERE formname='v_edit_connec' AND tabname='tab_event';

UPDATE config_form_tabs
    SET orderby=5
    WHERE formname='v_edit_connec' AND tabname='tab_documents';

-- tabs node
UPDATE config_form_tabs
    SET orderby=2
    WHERE formname='v_edit_node' AND tabname='tab_connections';

UPDATE config_form_tabs
    SET orderby=3
    WHERE formname='v_edit_arc' AND tabname='tab_elements';

UPDATE config_form_tabs
    SET orderby=4
    WHERE formname='v_edit_arc' AND tabname='tab_event';

UPDATE config_form_tabs
    SET orderby=5
    WHERE formname='v_edit_arc' AND tabname='tab_documents';

UPDATE config_form_tabs
    SET orderby=6
    WHERE formname='v_edit_arc' AND tabname='tab_plan';

-- tabs gully
UPDATE config_form_tabs
	SET orderby=2
	WHERE formname='v_edit_gully' AND tabname='tab_elements';
UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='v_edit_gully' AND tabname='tab_documents';
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='v_edit_gully' AND tabname='tab_event';


UPDATE config_form_tabs
	SET "label"='Connections' WHERE tabname='tab_connections';



INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype,
label,  tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields
where layoutname ='lyt_data_2' and formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'placement_type', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Placement Type', 'Placement Type', NULL, false, false, true, false, false
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully')
AND columnname='adate'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('cat_arc_visibility_vdef', '1', 'NO VISITABLE', 'The arc is not visitable', NULL);
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('cat_arc_visibility_vdef', '2', 'SEMI VISITABLE', 'The arc is semi visitable, in some cases you can visit in others not', NULL);
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('cat_arc_visibility_vdef', '3', 'VISITABLE', 'The arc is visitable', NULL);

UPDATE cat_arc SET visitability_vdef=3 WHERE visitability_vdef = 1; -- VISITABLE
UPDATE cat_arc SET visitability_vdef=1 WHERE visitability_vdef = 0; -- NO VISITABLE
UPDATE config_form_fields SET "datatype" = 'integer', widgettype = 'combo', iseditable = true,
hidden = false, dv_querytext = 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''cat_arc_visibility_vdef'''
WHERE columnname = 'visitability' AND "datatype" = 'boolean';

UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector_x_gully';


UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_node_shape WHERE id IS NOT NULL' WHERE formname='cat_node' AND formtype='form_feature' AND columnname='shape' AND tabname='tab_none';


INSERT INTO config_style VALUES (101, 'GwBasic', NULL, 'role_basic', '{"orderBy":1}', false, true);
INSERT INTO config_style VALUES (102, 'GwEpa', NULL, 'role_basic', '{"orderBy":2}', false, true);
INSERT INTO config_style VALUES (103, 'GwGraphConfig', NULL, NULL, NULL, true, true);
INSERT INTO config_style VALUES (104, 'GwInpLog', NULL, NULL, NULL, true, true);
INSERT INTO config_style VALUES (105, 'GwFlowTrace', NULL, NULL, NULL, true, true);
INSERT INTO config_style VALUES (106, 'GwFlowExit', NULL, NULL, NULL, true, true);

UPDATE sys_style SET layername='line', styleconfig_id = 104 WHERE layername='INP result line';
UPDATE sys_style SET layername='point', styleconfig_id = 104 WHERE layername='INP result point';
UPDATE sys_style SET layername='line', styleconfig_id = 105 WHERE layername='Flow trace arc';
UPDATE sys_style SET layername='point', styleconfig_id = 105 WHERE layername='Flow trace node';
UPDATE sys_style SET layername='line', styleconfig_id = 106 WHERE layername='Flow exit arc';
UPDATE sys_style SET layername='point', styleconfig_id = 106 WHERE layername='Flow exit node';

UPDATE sys_style SET layername='v_edit_arc', styleconfig_id = 102 WHERE layername='v_edit_arc SWMM point of view';
UPDATE sys_style SET layername='v_edit_connec', styleconfig_id = 102 WHERE layername='v_edit_gully SWMM point of view';
UPDATE sys_style SET layername='v_edit_node', styleconfig_id = 102 WHERE layername='v_edit_node SWMM point of view';
UPDATE sys_style SET layername='v_edit_link', styleconfig_id = 102 WHERE layername='v_edit_link SWMM point of view';

UPDATE sys_style SET styleconfig_id = 101 WHERE styleconfig_id is null;

ALTER TABLE sys_style ALTER COLUMN styleconfig_id SET NOT NULL;

UPDATE link SET muni_id = g.muni_id FROM gully g WHERE gully_id =  feature_id;

INSERT INTO sys_function VALUES
(3054,'gw_fct_setmapzoneconfig','utils','function','json','json',
'Function that changes configuration of a mapzone after using node replace, arc fusion or divide tool on features that are involved in a mapzone',
'role_edit','','core');

UPDATE config_form_tableview SET columnindex=4 WHERE objectname='v_ui_rpt_cat_result' AND columnname='status';
UPDATE config_form_tableview SET columnindex=6 WHERE objectname='v_ui_rpt_cat_result' AND columnname='descript';
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('epa_toolbar', 'utils', 'v_ui_rpt_cat_result', 'iscorporate', 5, true, NULL, NULL, NULL, NULL);


DELETE FROM sys_table WHERE id = 'v_anl_pgrouting_arc';
DELETE FROM sys_table WHERE id = 'v_anl_pgrouting_node';

DELETE FROM sys_table WHERE id = 'v_edit_man_netelement';


DELETE FROM sys_function WHERE function_name = 'gw_fct_graphanalytics_downstream_recursive';
DELETE FROM sys_function WHERE function_name = 'gw_fct_graphanalytics_upstream_recursive';

drop view if exists vi_parent_arc;



INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('rpt_node', NULL, 'role_epa', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('rpt_arc', NULL, 'role_epa', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('selector_period', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_ui_hydroval', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_ui_drainzone', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;

UPDATE sys_table SET id='v_rpt_lidperformance_sum' WHERE id='v_rpt_lidperfomance_sum';
UPDATE sys_table SET id='v_rpt_comp_lidperformance_sum' WHERE id='v_rpt_comp_lidperfomance_sum';
UPDATE sys_style SET layername='v_rpt_lidperformance_sum' WHERE layername='v_rpt_lidperfomance_sum';
UPDATE sys_style SET layername='v_rpt_comp_lidperformance_sum' WHERE layername='v_rpt_comp_lidperfomance_sum';

UPDATE sys_table SET id='v_rpt_subcatchwashoff_sum' WHERE id='v_rpt_subcatchwasoff_sum';
UPDATE sys_table SET id='v_rpt_comp_subcatchwashoff_sum' WHERE id='v_rpt_comp_subcatchwasoff_sum';
UPDATE sys_style SET layername='v_rpt_subcatchwashoff_sum' WHERE layername='v_rpt_subcatchwasoff_sum';
UPDATE sys_style SET layername='v_rpt_comp_subcatchwashoff_sum' WHERE layername='v_rpt_comp_subcatchwasoff_sum';
UPDATE config_form_fields SET formname='v_rpt_subcatchwashoff_sum' WHERE formname='v_rpt_subcatchwasoff_sum';
UPDATE config_form_fields SET formname='v_rpt_comp_subcatchwashoff_sum' WHERE formname='v_rpt_comp_subcatchwasoff_sum';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('gully', 'form_feature', 'tab_none', 'btn_accept', 'lyt_buttons', 0, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{"functionName": "accept", "params": {}}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('gully', 'form_feature', 'tab_none', 'btn_apply', 'lyt_buttons', 0, NULL, 'button', NULL, 'Apply', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Apply"}'::json, '{"functionName": "apply", "params": {}}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('gully', 'form_feature', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Cancel"}'::json, '{"functionName": "cancel", "params": {}}'::json, NULL, false, 2);


INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_result_status', '3', 'ARCHIVED', NULL, NULL);

-- get values by intersection


DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
        UPDATE raingage r SET muni_id = a.muni_id FROM (
        SELECT r.rg_id, m.muni_id FROM raingage r LEFT JOIN utils.municipality m ON st_dwithin (m.the_geom, r.the_geom, 0.01)
        ) a
        WHERE r.rg_id = a.rg_id;
    ELSE
        UPDATE raingage r SET muni_id = a.muni_id FROM (
        SELECT r.rg_id, m.muni_id FROM raingage r LEFT JOIN ext_municipality m ON st_dwithin (m.the_geom, r.the_geom, 0.01)
        ) a
        WHERE r.rg_id = a.rg_id;
    END IF;
END; $$;

update "element" e set muni_id = a.muni_id, sector_id = a.sector_id from (
select element_id, gully_id, g.muni_id, g.sector_id from element_x_gully
left join gully g using (gully_id)
)a where e.element_id = a.element_id;

update "element" set sector_id = 0 where sector_id is null;

update link b set sector_id = a.sector_id, muni_id = a.muni_id from (
select feature_id, c.sector_id, c.muni_id from link l
left join gully c on l.feature_id = c.gully_id where l.feature_type = 'GULLY'
)a where b.feature_id = a.feature_id;


update om_visit e set muni_id = a.muni_id, sector_id = a.sector_id from (
select visit_id, gully_id, n.muni_id, n.sector_id from om_visit_x_gully
    left join gully n using (gully_id)
)a where e.id = a.visit_id;

update om_visit set sector_id = 0 where sector_id is null;


UPDATE config_function
	SET "style"='{"style":{"point":{"style":"qml","id":"106"},"line":{"style":"qml","id":"106"}}}'::json
	WHERE id=2214;
UPDATE config_function
	SET "style"='{"style":{"point":{"style":"qml","id":"105"},"line":{"style":"qml","id":"105"}}}'::json
	WHERE id=2218;
UPDATE config_function
	SET "style"='{"style":{"point":{"style":"qml", "id":"104"}, "line":{"style":"qml", "id":"104"}}}'::json
	WHERE id=2858;



DELETE FROM config_form_fields WHERE formname='visit_arc_leak' AND formtype='form_visit' AND columnname='acceptbutton' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='visit_arc_leak' AND formtype='form_visit' AND columnname='backbutton' AND tabname='tab_file';
DELETE FROM config_form_fields WHERE formname='visit_connec_leak' AND formtype='form_visit' AND columnname='acceptbutton' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='visit_connec_leak' AND formtype='form_visit' AND columnname='backbutton' AND tabname='tab_file';
DELETE FROM config_form_fields WHERE formname='visit_node_insp' AND formtype='form_visit' AND columnname='acceptbutton' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='visit_node_insp' AND formtype='form_visit' AND columnname='backbutton' AND tabname='tab_file';
DELETE FROM config_form_fields WHERE formname='incident_node' AND formtype='form_visit' AND columnname='acceptbutton' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='incident_node' AND formtype='form_visit' AND columnname='backbutton' AND tabname='tab_file';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
    VALUES('generic', 'form_visit', 'tab_file', 'btn_apply', 'lyt_buttons', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false,"text": "Apply"}'::json, '{"functionName": "apply"}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
    VALUES('generic', 'form_visit', 'tab_data', 'btn_accept', 'lyt_buttons', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Accept"}'::json, '{"functionName": "accept"}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
    VALUES('generic', 'form_visit', 'tab_file', 'btn_cancel', 'lyt_buttons', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Cancel"}'::json, '{"functionName": "cancel"}'::json, NULL, false, 2);

UPDATE config_form_list
SET addparam='{"enableGlobalFilter": false,"enableStickyHeader": true,"positionToolbarAlertBanner": "bottom","enableGrouping": false,"enablePinning": true,"enableColumnOrdering": true,"enableColumnFilterModes": true,"enableFullScreenToggle": false,"enablePagination": true,"enableExporting": true,"muiTablePaginationProps": {"rowsPerPageOptions": [5,10,15,20,50,100],"showFirstButton": true,"showLastButton": true},"enableRowSelection": true,"multipleRowSelection": true,"initialState": {"showColumnFilters": false,"pagination": {"pageSize": 10,"pageIndex": 0},"density": "compact","columnFilters": [],"sorting": [{"id": "id","desc": true}]},"modifyTopToolBar": true,"renderTopToolbarCustomActions": [{"widgetfunction": {"functionName": "open","params": {}},"color": "success","text": "Open","disableOnSelect": true,"moreThanOneDisable": true},{"widgetfunction": {"functionName": "delete","params": {}},"color": "error","text": "Delete","disableOnSelect": true},{"widgetfunction": {"functionName": "refresh","params": {}},"color": "info","text": "Refresh"}],"enableRowActions": false,"renderRowActionMenuItems": [{"widgetfunction": {"functionName": "open","params": {}},"icon": "OpenInBrowser","text": "Open"},{"widgetfunction": {"functionName": "delete","params": {}},"icon": "Delete","text": "Delete"}]}'::json
WHERE listname='tbl_visit_manager' AND device=5;

INSERT INTO edit_typevalue (typevalue, id, idval)
VALUES('drainzone_type', 'UNDEFINED', 'UNDEFINED')
ON CONFLICT(typevalue, id) DO NOTHING;

INSERT INTO edit_typevalue (typevalue, id, idval)
VALUES('sector_type', 'UNDEFINED', 'UNDEFINED'), ('sector_type', 'URBAN DRAINAGE', 'URBAN DRAINAGE'), ('sector_type', 'MAIN SEWER NETWORK', 'MAIN SEWER NETWORK')
ON CONFLICT(typevalue, id) DO NOTHING;

INSERT INTO edit_typevalue (typevalue, id, idval)
VALUES('dma_type', 'UNDEFINED', 'UNDEFINED')
ON CONFLICT(typevalue, id) DO NOTHING;


INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, active)
VALUES('edit_typevalue', 'drainzone_type', 'drainzone', 'drainzone_type', true)
ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, active)
VALUES('edit_typevalue', 'sector_type', 'sector', 'sector_type', true)
ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, active)
VALUES('edit_typevalue', 'dma_type', 'dma', 'dma_type', true)
ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('minsector', 'Table of minsectors', 'role_edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);

INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('macrominsector', 'Table of macrominsectors', 'role_edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);

UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology|Labeling" labelsEnabled="1">
  <renderer-v2 enableorderby="0" forceraster="0" symbollevels="0" type="RuleRenderer" referencescale="-1">
    <rules key="{4cb3e952-bd79-40ee-9f19-dc8fa18f2452}">
      <rule key="{294ddb79-aff2-4244-a83c-29b1c7e34366}" label="CONDUIT" filter="&quot;inp_type&quot; = ''CONDUIT''" symbol="0"/>
      <rule key="{bd4ace4b-318d-428c-a3c1-0ce17445beda}" label="VIRTUAL" filter="&quot;inp_type&quot; = ''VIRTUAL''" symbol="1"/>
      <rule key="{2f673a7d-f319-42d8-a666-36380c3a0818}" label="PUMP" filter="&quot;inp_type&quot; = ''PUMP''" symbol="2"/>
      <rule key="{dde3a32f-0f78-4ca9-b6c5-6ca0f43a7cec}" label="WEIR" filter="&quot;inp_type&quot; = ''WEIR''" symbol="3"/>
      <rule key="{3ca1f4ff-af9b-4c83-beb6-5e924bcac7ec}" label="ORIFICE" filter="&quot;inp_type&quot; = ''ORIFICE''" symbol="4"/>
      <rule key="{4007a203-30ed-448e-8322-65999b1f7a07}" label="OUTLET" filter="&quot;inp_type&quot; = ''OUTLET''" symbol="5"/>
      <rule key="{9c3b163a-25f9-44cc-a324-c05147612097}" label="NOT USED" filter="&quot;inp_type&quot; IS NULL" symbol="6"/>
    </rules>
    <symbols>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="31,120,180,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.56" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="MarkerLine">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="@0@1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="31,120,180,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="filled_arrowhead" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0,0,0,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="1.56" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="size" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="1" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="31,120,180,255" name="line_color" type="QString"/>
            <Option value="dot" name="line_style" type="QString"/>
            <Option value="0.56" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="MarkerLine">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="@1@1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="31,120,180,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="filled_arrowhead" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0,0,0,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="1.56" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="size" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="2" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="31,120,180,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.483636" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="MarkerLine">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="@2@1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="237,124,89,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="50,87,128,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0.4" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="3.8" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer locked="0" enabled="1" pass="0" class="FontMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="P" name="chr" type="QString"/>
                <Option value="0,0,0,255" name="color" type="QString"/>
                <Option value="MS Shell Dlg 2" name="font" type="QString"/>
                <Option value="" name="font_style" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255" name="outline_color" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="1.9" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="3" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="31,120,180,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.483636" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="MarkerLine">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="@3@1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="234,237,205,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="50,87,128,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0.4" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="3.8" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer locked="0" enabled="1" pass="0" class="FontMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="W" name="chr" type="QString"/>
                <Option value="0,0,0,255" name="color" type="QString"/>
                <Option value="MS Shell Dlg 2" name="font" type="QString"/>
                <Option value="" name="font_style" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255" name="outline_color" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="1.9" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="4" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="31,120,180,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.483636" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="MarkerLine">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="@4@1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="197,203,117,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="50,87,128,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0.4" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="3.8" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer locked="0" enabled="1" pass="0" class="FontMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="O" name="chr" type="QString"/>
                <Option value="0,0,0,255" name="color" type="QString"/>
                <Option value="MS Shell Dlg 2" name="font" type="QString"/>
                <Option value="" name="font_style" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255" name="outline_color" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="1.9" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="5" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="31,120,180,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.483636" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="MarkerLine">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="true" name="place_on_every_part" type="bool"/>
            <Option value="CentralPoint" name="placements" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="@5@1" type="marker">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="175,186,23,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="50,87,128,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0.4" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="3.8" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer locked="0" enabled="1" pass="0" class="FontMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="L" name="chr" type="QString"/>
                <Option value="0,0,0,255" name="color" type="QString"/>
                <Option value="MS Shell Dlg 2" name="font" type="QString"/>
                <Option value="" name="font_style" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255" name="outline_color" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="1.9" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="6" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="206,206,206,255" name="line_color" type="QString"/>
            <Option value="dot" name="line_style" type="QString"/>
            <Option value="0.5" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="rule-based">
    <rules key="{f96d42ed-df7b-4835-bc75-8f164901703a}">
      <rule key="{db03fb0f-aeb8-4739-af9a-08695a449805}" filter="&quot;inp_type&quot; IS NOT NULL">
        <settings calloutType="simple">
          <text-style multilineHeightUnit="Percentage" fontUnderline="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" blendMode="0" useSubstitutions="0" fontLetterSpacing="0" fontKerning="1" legendString="Aa" fontWordSpacing="0" fontWeight="50" textOrientation="horizontal" multilineHeight="1" allowHtml="0" textOpacity="1" forcedItalic="0" textColor="0,0,0,255" namedStyle="Normal" previewBkgrdColor="255,255,255,255" fontItalic="0" capitalization="0" fontFamily="MS Shell Dlg 2" fontStrikeout="0" fontSize="8.25" forcedBold="0" isExpression="0" fontSizeUnit="Point" fieldName="arccat_id">
            <families/>
            <text-buffer bufferColor="255,255,255,255" bufferOpacity="1" bufferBlendMode="0" bufferNoFill="0" bufferSize="1" bufferDraw="0" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSizeUnits="MM" bufferJoinStyle="128"/>
            <text-mask maskType="0" maskedSymbolLayers="" maskSize="0" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskSizeUnits="MM" maskJoinStyle="128" maskOpacity="1" maskEnabled="0"/>
            <background shapeSizeX="0" shapeBorderColor="128,128,128,255" shapeRotationType="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetUnit="MM" shapeRadiiUnit="MM" shapeFillColor="255,255,255,255" shapeBorderWidthUnit="MM" shapeType="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeBlendMode="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeUnit="MM" shapeDraw="0" shapeJoinStyle="64" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetY="0" shapeSVGFile="" shapeSizeType="0" shapeRotation="0" shapeRadiiX="0" shapeRadiiY="0" shapeOffsetX="0" shapeSizeY="0" shapeBorderWidth="0" shapeOpacity="1">
              <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="markerSymbol" type="marker">
                <data_defined_properties>
                  <Option type="Map">
                    <Option value="" name="name" type="QString"/>
                    <Option name="properties"/>
                    <Option value="collection" name="type" type="QString"/>
                  </Option>
                </data_defined_properties>
                <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
                  <Option type="Map">
                    <Option value="0" name="angle" type="QString"/>
                    <Option value="square" name="cap_style" type="QString"/>
                    <Option value="231,113,72,255" name="color" type="QString"/>
                    <Option value="1" name="horizontal_anchor_point" type="QString"/>
                    <Option value="bevel" name="joinstyle" type="QString"/>
                    <Option value="circle" name="name" type="QString"/>
                    <Option value="0,0" name="offset" type="QString"/>
                    <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                    <Option value="MM" name="offset_unit" type="QString"/>
                    <Option value="35,35,35,255" name="outline_color" type="QString"/>
                    <Option value="solid" name="outline_style" type="QString"/>
                    <Option value="0" name="outline_width" type="QString"/>
                    <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                    <Option value="MM" name="outline_width_unit" type="QString"/>
                    <Option value="diameter" name="scale_method" type="QString"/>
                    <Option value="2" name="size" type="QString"/>
                    <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                    <Option value="MM" name="size_unit" type="QString"/>
                    <Option value="1" name="vertical_anchor_point" type="QString"/>
                  </Option>
                  <data_defined_properties>
                    <Option type="Map">
                      <Option value="" name="name" type="QString"/>
                      <Option name="properties"/>
                      <Option value="collection" name="type" type="QString"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
              <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="fillSymbol" type="fill">
                <data_defined_properties>
                  <Option type="Map">
                    <Option value="" name="name" type="QString"/>
                    <Option name="properties"/>
                    <Option value="collection" name="type" type="QString"/>
                  </Option>
                </data_defined_properties>
                <layer locked="0" enabled="1" pass="0" class="SimpleFill">
                  <Option type="Map">
                    <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
                    <Option value="255,255,255,255" name="color" type="QString"/>
                    <Option value="bevel" name="joinstyle" type="QString"/>
                    <Option value="0,0" name="offset" type="QString"/>
                    <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                    <Option value="MM" name="offset_unit" type="QString"/>
                    <Option value="128,128,128,255" name="outline_color" type="QString"/>
                    <Option value="no" name="outline_style" type="QString"/>
                    <Option value="0" name="outline_width" type="QString"/>
                    <Option value="MM" name="outline_width_unit" type="QString"/>
                    <Option value="solid" name="style" type="QString"/>
                  </Option>
                  <data_defined_properties>
                    <Option type="Map">
                      <Option value="" name="name" type="QString"/>
                      <Option name="properties"/>
                      <Option value="collection" name="type" type="QString"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowOffsetAngle="135" shadowUnder="0" shadowOffsetGlobal="1" shadowOffsetUnit="MM" shadowRadiusAlphaOnly="0" shadowRadius="1.5" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOpacity="0.69999999999999996" shadowColor="0,0,0,255" shadowDraw="0" shadowRadiusUnit="MM" shadowBlendMode="6" shadowOffsetDist="1" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowScale="100"/>
            <dd_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format reverseDirectionSymbol="0" autoWrapLength="0" placeDirectionSymbol="0" addDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" rightDirectionSymbol=">" multilineAlign="0" decimals="3" plussign="0" formatNumbers="0" wrapChar="" leftDirectionSymbol="&lt;"/>
          <placement centroidInside="0" polygonPlacementFlags="2" distUnits="MM" maxCurvedCharAngleOut="-25" fitInPolygonOnly="0" yOffset="0" overrunDistanceUnit="MM" overrunDistance="0" centroidWhole="0" priority="5" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" overlapHandling="PreventOverlap" repeatDistanceUnits="MM" lineAnchorType="0" preserveRotation="1" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" distMapUnitScale="3x:0,0,0,0,0,0" offsetType="0" lineAnchorPercent="0.5" geometryGeneratorEnabled="0" lineAnchorTextPoint="CenterOfText" maxCurvedCharAngleIn="25" placementFlags="10" allowDegraded="0" repeatDistance="0" geometryGenerator="" placement="2" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" lineAnchorClipping="0" dist="0" rotationUnit="AngleDegrees" offsetUnits="MapUnit" geometryGeneratorType="PointGeometry" rotationAngle="0" xOffset="0" layerType="LineGeometry"/>
          <rendering obstacleType="0" zIndex="0" scaleMin="1" mergeLines="0" unplacedVisibility="0" fontLimitPixelSize="0" scaleVisibility="1" obstacleFactor="1" labelPerPart="0" maxNumLabels="2000" minFeatureSize="0" fontMinPixelSize="3" scaleMax="1000" limitNumLabels="0" upsidedownLabels="0" fontMaxPixelSize="10000" drawLabels="1" obstacle="1"/>
          <dd_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </dd_properties>
          <callout type="simple">
            <Option type="Map">
              <Option value="pole_of_inaccessibility" name="anchorPoint" type="QString"/>
              <Option value="0" name="blendMode" type="int"/>
              <Option name="ddProperties" type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
              <Option value="false" name="drawToAllParts" type="bool"/>
              <Option value="0" name="enabled" type="QString"/>
              <Option value="point_on_exterior" name="labelAnchorPoint" type="QString"/>
              <Option value="&lt;symbol force_rhr=&quot;0&quot; alpha=&quot;1&quot; clip_to_extent=&quot;1&quot; is_animated=&quot;0&quot; frame_rate=&quot;10&quot; name=&quot;symbol&quot; type=&quot;line&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer locked=&quot;0&quot; enabled=&quot;1&quot; pass=&quot;0&quot; class=&quot;SimpleLine&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;0&quot; name=&quot;align_dash_pattern&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;square&quot; name=&quot;capstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;5;2&quot; name=&quot;customdash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;customdash_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;customdash_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;dash_pattern_offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;dash_pattern_offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;draw_inside_polygon&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;bevel&quot; name=&quot;joinstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;60,60,60,255&quot; name=&quot;line_color&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;solid&quot; name=&quot;line_style&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0.3&quot; name=&quot;line_width&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;line_width_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;ring_filter&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_end&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_end_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_end_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_start&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_start_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_start_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;tweak_dash_pattern_on_corners&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;use_custom_dash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;width_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
              <Option value="0" name="minLength" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale" type="QString"/>
              <Option value="MM" name="minLengthUnit" type="QString"/>
              <Option value="0" name="offsetFromAnchor" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale" type="QString"/>
              <Option value="MM" name="offsetFromAnchorUnit" type="QString"/>
              <Option value="0" name="offsetFromLabel" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale" type="QString"/>
              <Option value="MM" name="offsetFromLabelUnit" type="QString"/>
            </Option>
          </callout>
        </settings>
      </rule>
    </rules>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>' WHERE styleconfig_id=102 and layername='v_edit_arc';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology">
  <renderer-v2 enableorderby="0" forceraster="0" symbollevels="0" type="RuleRenderer" referencescale="-1">
    <rules key="{2b70c7cf-3215-47bb-be52-2168a74bf823}">
      <rule key="{3c19d0bd-e4a9-460c-8e13-d4ebabe76cde}" label="JUNCTION" filter="&quot;inp_type&quot; = ''JUNCTION''" symbol="0"/>
      <rule key="{53ff0c3f-982c-414b-9b96-5c2191b0da78}" label="NETGULLY" filter="&quot;inp_type&quot; = ''NETGULLY''" symbol="1"/>
      <rule key="{dc169491-eb61-4958-894f-6224db06045c}" label="OUTFALL" filter="&quot;inp_type&quot; = ''OUTFALL''" symbol="2"/>
      <rule key="{09224b9c-f6fe-4624-aea0-bc86a447066e}" label="STORAGE" filter="&quot;inp_type&quot; = ''STORAGE''" symbol="3"/>
      <rule key="{35746168-286d-42fa-b920-573a171f6484}" label="DIVIDER" filter="&quot;inp_type&quot; = ''DIVIDER''" symbol="4"/>
      <rule key="{a8309ef2-dcc4-402a-90eb-522eb5bdeb56}" label="NOT USED" filter="&quot;inp_type&quot; IS NULL" symbol="5"/>
    </rules>
    <symbols>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="31,120,180,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.2" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="1" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,255,255,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.2" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="area" name="scale_method" type="QString"/>
            <Option value="2.4" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="0,0,0,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="area" name="scale_method" type="QString"/>
            <Option value="0.525" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="2" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="72,123,182,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="triangle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="50,87,128,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2.4" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="3" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="31,120,180,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="square" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2.7" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="false" name="active" type="bool"/>
                  <Option value="1" name="type" type="int"/>
                  <Option value="" name="val" type="QString"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="4" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="72,123,182,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="diamond" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="50,87,128,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" alpha="1" clip_to_extent="1" is_animated="0" frame_rate="10" name="5" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="215,215,215,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="215,215,215,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>' WHERE styleconfig_id=102 and layername='v_edit_node';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.28.4-Firenze">
  <renderer-v2 type="nullSymbol" symbollevels="0" forceraster="0" referencescale="-1" enableorderby="0"/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>' WHERE styleconfig_id=102 and layername='v_edit_connec';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.28.4-Firenze">
  <renderer-v2 type="RuleRenderer" symbollevels="0" forceraster="0" referencescale="-1" enableorderby="0">
    <rules key="{f409d5eb-3e1c-4ad5-a144-856e7968cdb5}">
      <rule key="{dff7f0b4-0963-45c8-b446-deb20b67eeda}" symbol="0" filter=" &quot;feature_type&quot;  = ''GULLY''"/>
    </rules>
    <symbols>
      <symbol frame_rate="10" type="line" name="0" clip_to_extent="1" force_rhr="0" is_animated="0" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" pass="0" enabled="1" locked="0">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="31,120,180,255"/>
            <Option type="QString" name="line_style" value="dash"/>
            <Option type="QString" name="line_width" value="0.26"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="GeometryGenerator" pass="0" enabled="1" locked="0">
          <Option type="Map">
            <Option type="QString" name="SymbolType" value="Marker"/>
            <Option type="QString" name="geometryModifier" value="end_point($geometry)"/>
            <Option type="QString" name="units" value="MapUnit"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
          <symbol frame_rate="10" type="marker" name="@0@1" clip_to_extent="1" force_rhr="0" is_animated="0" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" name="name" value=""/>
                <Option name="properties"/>
                <Option type="QString" name="type" value="collection"/>
              </Option>
            </data_defined_properties>
            <layer class="SimpleMarker" pass="0" enabled="1" locked="0">
              <Option type="Map">
                <Option type="QString" name="angle" value="0"/>
                <Option type="QString" name="cap_style" value="square"/>
                <Option type="QString" name="color" value="255,0,0,255"/>
                <Option type="QString" name="horizontal_anchor_point" value="1"/>
                <Option type="QString" name="joinstyle" value="bevel"/>
                <Option type="QString" name="name" value="cross2"/>
                <Option type="QString" name="offset" value="0,0"/>
                <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="offset_unit" value="MM"/>
                <Option type="QString" name="outline_color" value="35,35,35,255"/>
                <Option type="QString" name="outline_style" value="solid"/>
                <Option type="QString" name="outline_width" value="0"/>
                <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="outline_width_unit" value="MM"/>
                <Option type="QString" name="scale_method" value="diameter"/>
                <Option type="QString" name="size" value="1.8"/>
                <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
                <Option type="QString" name="size_unit" value="MM"/>
                <Option type="QString" name="vertical_anchor_point" value="1"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" name="name" value=""/>
                  <Option name="properties"/>
                  <Option type="QString" name="type" value="collection"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>' WHERE styleconfig_id=102 and layername='v_edit_link';

ALTER TABLE sys_style ADD CONSTRAINT sys_style_pkey PRIMARY KEY (layername, styleconfig_id);
ALTER TABLE sys_style ALTER COLUMN styleconfig_id SET NOT NULL;


DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
        ALTER TABLE raingage ADD CONSTRAINT raingage_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);
    ELSE
        ALTER TABLE raingage ADD CONSTRAINT raingage_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);
    END IF;
END; $$;

CREATE INDEX gully_muni ON gully USING btree (muni_id);

ALTER TABLE sector ALTER COLUMN graphconfig SET DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::JSON;
ALTER TABLE dma ALTER COLUMN graphconfig SET DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::JSON;

CREATE TRIGGER gw_trg_ui_rpt_cat_result INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_rpt_cat_result FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_rpt_cat_result();


CREATE trigger gw_trg_ui_doc_x_gully instead OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_gully FOR each row EXECUTE function gw_trg_ui_doc('doc_x_gully');


CREATE TRIGGER gw_trg_edit_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element('element');

CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_samplepoint
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_samplepoint('samplepoint');

CREATE TRIGGER gw_trg_edit_streetaxis INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ext_streetaxis
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_streetaxis();

CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_gully('parent');

CREATE TRIGGER gw_trg_edit_element_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element_pol();

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_node');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_connec');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_arc');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_gully');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_storage
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('STORAGE');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_outfall
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('OUTFALL');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_outfall
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_outfall');

CREATE TRIGGER gw_trg_edit_inp_treatment INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_treatment
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_treatment();

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_inflows_poll
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_inflows
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_dwf INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dwf
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dwf();

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_treatment
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('TREATMENT');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('JUNCTION');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_inflows_poll
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_inflows
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_flwreg_outlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-OUTLET');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_flwreg_weir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-WEIR');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_flwreg_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-PUMP');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_flwreg_orifice
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-ORIFICE');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_flwreg_outlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-OUTLET');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_flwreg_weir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-WEIR');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_flwreg_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-PUMP');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_flwreg_orifice
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-ORIFICE');

CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_orifice
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_orifice');

CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_outlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_outlet');

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_pump');

CREATE TRIGGER gw_trg_edit_inp_arc_virtual INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_virtual
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtual');

CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_weir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_weir');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_conduit
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONDUIT');

CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_conduit
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_conduit');

CREATE TRIGGER gw_trg_edit_pol_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_gully_pol();

CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_link
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_link();

CREATE TRIGGER gw_trg_edit_dma INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_dma
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('dma');

CREATE trigger gw_trg_edit_drainzone INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_drainzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_drainzone();

CREATE trigger gw_trg_edit_sector INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('sector');

CREATE TRIGGER gw_trg_edit_address INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ext_address
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_address();
