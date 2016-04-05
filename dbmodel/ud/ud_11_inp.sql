/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




-- ----------------------------
-- temporals
-- ----------------------------

CREATE SEQUENCE "sample_ud"."temp_node_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "sample_ud"."temp_arc_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "sample_ud"."temp_arcnodearc_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "sample_ud"."temp_nodearcnode_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE "sample_ud"."temp_node" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"nodecat_id" varchar(30) COLLATE "default" NOT NULL,
"epa_type" varchar(16) COLLATE "default" NOT NULL,
"sector_id" varchar(30) COLLATE "default" NOT NULL,
"state" character varying(16) NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(16) COLLATE "default" NOT NULL,
"the_geom" public.geometry (POINT, 25831),
CONSTRAINT temp_node_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "sample_ud"."temp_arc" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"node_1" varchar(16) COLLATE "default",
"node_2" varchar(16) COLLATE "default",
"arccat_id" varchar(30) COLLATE "default" NOT NULL,
"epa_type" varchar(16) COLLATE "default" NOT NULL,
"sector_id" varchar(30) COLLATE "default" NOT NULL,
"state" character varying(16) NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"custom_length" numeric (12,2),
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(16) COLLATE "default" NOT NULL,
"the_geom" public.geometry (LINESTRING, 25831),
CONSTRAINT temp_arc_pkey PRIMARY KEY (arc_id)
);


CREATE TABLE "sample_ud"."temp_nodearcnode" (
node_id varchar(16) COLLATE "default",
arc_id varchar(16) COLLATE "default",
node_2 varchar(16) COLLATE "default",
CONSTRAINT temp_nodearcnode_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "sample_ud"."temp_arcnodearc" (
node_id varchar(16) COLLATE "default",
arc_1 varchar(16) COLLATE "default",
arc_2 varchar(16) COLLATE "default",
CONSTRAINT temp_arcnodearc_pkey PRIMARY KEY (node_id)
);

  
-- ----------------------------
-- Sequence structure
-- ----------------------------

CREATE SEQUENCE "sample_ud"."inp_adjustments_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."inp_aquifer_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_backdrop_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_controls_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_curve_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_files_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_hydrograph_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_inflows_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_lid_control_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_mapdim_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_mapunits_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_options_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_project_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_report_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_sector_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_timeseries_rel_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_transects_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."inp_vertice_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."rpt_arcflow_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  
CREATE SEQUENCE "sample_ud"."rpt_arcpolload_sum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "sample_ud"."rpt_condsurcharge_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_continuity_errors_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_critical_elements_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_flowclass_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_flowrouting_cont_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_groundwater_cont_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_high_conterrors_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_high_flowinest_ind_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_instability_index_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_lidperformance_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_nodedepth_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_nodeflooding_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_nodeinflow_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_nodesurcharge_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_outfallflow_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_outfallload_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_pumping_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_qualrouting_cont_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_rainfall_dep_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_result_cat_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_routing_timestep_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_runoff_qual_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_runoff_quant_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_storagevol_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_subcatchwashoff_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_subcathrunoff_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


CREATE SEQUENCE "sample_ud"."rpt_timestep_critelem_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
 
 




-- ----------------------------
-- Table structure (with geom)
-- ----------------------------

CREATE TABLE "sample_ud"."raingage" (
"rg_id" varchar(16) COLLATE "default" NOT NULL,
"form_type" varchar(12) COLLATE "default",
"intvl" varchar(10) COLLATE "default",
"scf" numeric(12,4),
"rgage_type" varchar(18) COLLATE "default",
"timser_id" varchar(16) COLLATE "default",
"fname" varchar(254) COLLATE "default",
"sta" varchar(12) COLLATE "default",
"units" varchar(3) COLLATE "default",
"the_geom" public.geometry (POINT, 25831)
);


CREATE TABLE "sample_ud"."subcatchment" (
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"node_id" varchar(50) COLLATE "default",
"rg_id" varchar(16) COLLATE "default",
"area" numeric(16,6),
"imperv" numeric(12,4),
"width" numeric(12,4),
"slope" numeric(12,4),
"clength" numeric(12,4),
"snow_id" varchar(16) COLLATE "default",
"nimp" numeric(12,4),
"nperv" numeric(12,4),
"simp" numeric(12,4),
"sperv" numeric(12,4),
"zero" numeric(12,4) DEFAULT 0.00,
"routeto" varchar(20) COLLATE "default",
"rted" numeric(12,4) DEFAULT 100.00,
"maxrate" numeric(12,4),
"minrate" numeric(12,4),
"decay" numeric(12,4),
"drytime" numeric(12,4),
"maxinfil" numeric(12,4),
"suction" numeric(12,4),
"conduct" numeric(12,4),
"initdef" numeric(12,4),
"curveno" numeric(12,4),
"conduct_2" numeric(12,4),
"drytime_2" numeric(12,4),
"sector_id" varchar(30) COLLATE "default",
"hydrology_id" varchar(20),
"the_geom" public.geometry (MULTIPOLYGON, 25831)
);



-- ----------------------------
-- Table CATALOG
-- ----------------------------

CREATE TABLE "sample_ud"."cat_hydrology" (
"id" varchar(20) COLLATE "default" NOT NULL,
"infiltration" varchar(20) COLLATE "default" NOT NULL,
"descript" varchar(255) COLLATE "default",
CONSTRAINT "cat_hydrology_pkey" PRIMARY KEY ("id")
);




-- ----------------------------
-- Table structure
-- ----------------------------

CREATE TABLE "sample_ud"."inp_arc_type" (
"id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT inp_arc_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."inp_node_type" (
"id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT inp_node_type_pkey PRIMARY KEY (id)
);



CREATE TABLE "sample_ud"."inp_adjustments" (
"id" varchar(16) DEFAULT nextval('"sample_ud".inp_adjustments_seq'::regclass) NOT NULL,
"adj_type" varchar(16) COLLATE "default" NOT NULL,
"value_1" numeric(12,4),
"value_2" numeric(12,4),
"value_3" numeric(12,4),
"value_4" numeric(12,4),
"value_5" numeric(12,4),
"value_6" numeric(12,4),
"value_7" numeric(12,4),
"value_8" numeric(12,4),
"value_9" numeric(12,4),
"value_10" numeric(12,4),
"value_11" numeric(12,4),
"value_12" numeric(12,4),
CONSTRAINT inp_adjustments_pkey PRIMARY KEY (id)
);


CREATE TABLE "sample_ud"."inp_aquifer" (
"aquif_id" varchar(16) DEFAULT nextval('"sample_ud".inp_aquifer_id_seq'::regclass) NOT NULL,
"por" numeric(12,4),
"wp" numeric(12,4),
"fc" numeric(12,4),
"k" numeric(12,4),
"ks" numeric(12,4),
"ps" numeric(12,4),
"uef" numeric(12,4),
"led" numeric(12,4),
"gwr" numeric(12,4),
"be" numeric(12,4),
"wte" numeric(12,4),
"umc" numeric(12,4),
"pattern_id" varchar (16)
) WITH (OIDS=FALSE)
;


CREATE TABLE "sample_ud"."inp_backdrop" (
"id" int4 DEFAULT nextval('"sample_ud".inp_backdrop_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_buildup_land_x_pol" (
"landus_id" varchar(16) COLLATE "default" NOT NULL,
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"funcb_type" varchar(18) COLLATE "default",
"c1" numeric(12,4),
"c2" numeric(12,4),
"c3" numeric(12,4),
"perunit" varchar(10) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_conduit" (
"arc_id" varchar(50) COLLATE "default" NOT NULL,
"barrels" int2,
"culvert" varchar(10) COLLATE "default",
"kentry" numeric(12,4),
"kexit" numeric(12,4),
"kavg" numeric(12,4),
"flap" varchar(3) COLLATE "default",
"q0" numeric(12,4),
"qmax" numeric(12,4),
"seepage" numeric (12,4)
);


CREATE TABLE "sample_ud"."inp_controls" (
"id" int4 DEFAULT nextval('"sample_ud".inp_controls_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_coverage_land_x_subc" (
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"landus_id" varchar(16) COLLATE "default" NOT NULL,
"percent" numeric(12,4)
);


CREATE TABLE "sample_ud"."inp_curve" (
"id" int4 DEFAULT nextval('"sample_ud".inp_curve_id_seq'::regclass) NOT NULL,
"curve_id" varchar(16) COLLATE "default",
"x_value" numeric(18,6),
"y_value" numeric(18,6)
);


CREATE TABLE "sample_ud"."inp_curve_id" (
"id" varchar(16) COLLATE "default" NOT NULL,
"curve_type" varchar(20) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_divider" (
"node_id" varchar(50) COLLATE "default" NOT NULL,
"divider_type" varchar(18) COLLATE "default",
"arc_id" varchar(50) COLLATE "default",
"curve_id" varchar(16) COLLATE "default",
"qmin" numeric(16,6),
"ht" numeric(12,4),
"cd" numeric(12,4),
"y0" numeric(12,4),
"ysur" numeric(12,4),
"apond" numeric(12,4)
);


CREATE TABLE "sample_ud"."inp_dwf" (
"id" int4 NOT NULL,
"node_id" varchar(50) COLLATE "default",
"value" numeric(12,5),
"pat1" varchar(16) COLLATE "default",
"pat2" varchar(16) COLLATE "default",
"pat3" varchar(16) COLLATE "default",
"pat4" varchar(16) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_dwf_pol_x_node" (
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"node_id" varchar(50) COLLATE "default" NOT NULL,
"value" numeric(12,4),
"pat1" varchar(16) COLLATE "default",
"pat2" varchar(16) COLLATE "default",
"pat3" varchar(16) COLLATE "default",
"pat4" varchar(16) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_evaporation" (
"evap_type" varchar(16) COLLATE "default" NOT NULL,
"evap" numeric(12,4),
"timser_id" varchar(16) COLLATE "default",
"value_1" numeric(12,4),
"value_2" numeric(12,4),
"value_3" numeric(12,4),
"value_4" numeric(12,4),
"value_5" numeric(12,4),
"value_6" numeric(12,4),
"value_7" numeric(12,4),
"value_8" numeric(12,4),
"value_9" numeric(12,4),
"value_10" numeric(12,4),
"value_11" numeric(12,4),
"value_12" numeric(12,4),
"pan_1" numeric(12,4),
"pan_2" numeric(12,4),
"pan_3" numeric(12,4),
"pan_4" numeric(12,4),
"pan_5" numeric(12,4),
"pan_6" numeric(12,4),
"pan_7" numeric(12,4),
"pan_8" numeric(12,4),
"pan_9" numeric(12,4),
"pan_10" numeric(12,4),
"pan_11" numeric(12,4),
"pan_12" numeric(12,4),
"recovery" varchar(16) COLLATE "default",
"dry_only" varchar(3) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_files" (
"id" int4 DEFAULT nextval('"sample_ud".inp_files_id_seq'::regclass) NOT NULL,
"actio_type" varchar(18) COLLATE "default",
"file_type" varchar(18) COLLATE "default",
"fname" varchar(254) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_groundwater" (
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"aquif_id" varchar(16) NOT NULL,
"node_id" varchar(50) COLLATE "default",
"surfel" numeric(10,4),
"a1" numeric(10,4),
"b1" numeric(10,4),
"a2" numeric(10,4),
"b2" numeric(10,4),
"a3" numeric(10,4),
"tw" numeric(10,4),
"h" numeric(10,4),
"fl_eq_lat" varchar (50),
"fl_eq_deep" varchar (50)
);


CREATE TABLE "sample_ud"."inp_hydrograph" (
"id" int4 DEFAULT nextval('"sample_ud".inp_hydrograph_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_inflows" (
"id" int4 DEFAULT nextval('"sample_ud".inp_inflows_id_seq'::regclass) NOT NULL,
"node_id" varchar(50) COLLATE "default",
"timser_id" varchar(16) COLLATE "default",
"sfactor" numeric(12,4),
"base" numeric(12,4),
"pattern_id" varchar(16) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_inflows_pol_x_node" (
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"node_id" varchar(50) COLLATE "default" NOT NULL,
"timser_id" varchar(16) COLLATE "default",
"form_type" varchar(18) COLLATE "default",
"mfactor" numeric(12,4),
"sfactor" numeric(12,4),
"base" numeric(12,4),
"pattern_id" varchar(16) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_junction" (
"node_id" varchar(50) COLLATE "default" NOT NULL,
"y0" numeric(12,4),
"ysur" numeric(12,4),
"apond" numeric(12,4)
);


CREATE TABLE "sample_ud"."inp_label" (
"label" varchar(16) COLLATE "default" NOT NULL,
"xcoord" numeric(18,6),
"ycoord" numeric(18,6),
"anchor" varchar(16) COLLATE "default",
"font" varchar(50) COLLATE "default",
"size" numeric(12,4),
"bold" varchar(3) COLLATE "default",
"italic" varchar(3) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_landuses" (
"landus_id" varchar(16) COLLATE "default" NOT NULL,
"sweepint" numeric(12,4),
"availab" numeric(12,4),
"lastsweep" numeric(12,4)
);


CREATE TABLE "sample_ud"."inp_lid_control" (
"id" int4 DEFAULT nextval('"sample_ud".inp_lid_control_id_seq'::regclass) NOT NULL,
"lidco_id" varchar(16) COLLATE "default",
"lidco_type" varchar(10) COLLATE "default",
"value_2" numeric(12,4),
"value_3" numeric(12,4),
"value_4" numeric(12,4),
"value_5" numeric(12,4),
"value_6" numeric(12,4),
"value_7" numeric(12,4),
"value_8" numeric(12,4)
);


CREATE TABLE "sample_ud"."inp_lidusage_subc_x_lidco" (
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"lidco_id" varchar(16) COLLATE "default" NOT NULL,
"number" int2,
"area" numeric(16,6),
"width" numeric(12,4),
"initsat" numeric(12,4),
"fromimp" numeric(12,4),
"toperv" int2,
"rptfile" varchar(10) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_loadings_pol_x_subc" (
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"ibuildup" numeric(12,4)
);


CREATE TABLE "sample_ud"."inp_mapdim" (
"type_dim" varchar(18) COLLATE "default",
"x1" numeric(18,6),
"y1" numeric(18,6),
"x2" numeric(18,6),
"y2" numeric(18,6)
);


CREATE TABLE "sample_ud"."inp_mapunits" (
"type_units" varchar(18) COLLATE "default",
"map_type" varchar(18) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_options" (
"flow_units" varchar(20) COLLATE "default" NOT NULL,
"flow_routing" varchar(12) COLLATE "default",
"link_offsets" varchar(12) COLLATE "default",
"force_main_equation" varchar(3) COLLATE "default",
"ignore_rainfall" varchar(3) COLLATE "default",
"ignore_snowmelt" varchar(3) COLLATE "default",
"ignore_groundwater" varchar(3) COLLATE "default",
"ignore_routing" varchar(3) COLLATE "default",
"ignore_quality" varchar(3) COLLATE "default",
"skip_steady_state" varchar(3) COLLATE "default",
"start_date" varchar(12) COLLATE "default",
"start_time" varchar(12) COLLATE "default",
"end_date" varchar(12) COLLATE "default",
"end_time" varchar(12) COLLATE "default",
"report_start_date" varchar(12) COLLATE "default",
"report_start_time" varchar(12) COLLATE "default",
"sweep_start" varchar(12) COLLATE "default",
"sweep_end" varchar(12) COLLATE "default",
"dry_days" numeric(12),
"report_step" varchar(12) COLLATE "default",
"wet_step" varchar(12) COLLATE "default",
"dry_step" varchar(12) COLLATE "default",
"routing_step" varchar(12) COLLATE "default",
"lengthening_step" numeric(12,6),
"variable_step" numeric(12,6),
"inertial_damping" varchar(12) COLLATE "default",
"normal_flow_limited" varchar(12) COLLATE "default",
"min_surfarea" numeric(12,6),
"min_slope" numeric(12,6),
"allow_ponding" varchar(3) COLLATE "default",
"tempdir" varchar(254) COLLATE "default",
"max_trials" int4,
"head_tolerance" numeric(12,4),
"sys_flow_tol" int4,
"lat_flow_tol" int4
);


CREATE TABLE "sample_ud"."inp_orifice" (
"arc_id" varchar(50) COLLATE "default" NOT NULL,
"ori_type" varchar(18) COLLATE "default",
"offset" numeric(12,4),
"cd" numeric(12,4),
"orate" numeric(12,4),
"flap" varchar(3) COLLATE "default",
"shape" varchar(18) COLLATE "default",
"to_arc" varchar(16) COLLATE "default",
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00
);



CREATE TABLE "sample_ud"."inp_outfall" (
"node_id" varchar(50) COLLATE "default" NOT NULL,
"outfall_type" varchar(16) COLLATE "default",
"stage" numeric(12,4),
"curve_id" varchar(16) COLLATE "default",
"timser_id" varchar(16) COLLATE "default",
"gate" varchar(3) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_outlet" (
"arc_id" varchar(50) COLLATE "default" NOT NULL,
"outlet_type" varchar(16) COLLATE "default",
"offset" numeric(12,4),
"curve_id" varchar(16) COLLATE "default",
"cd1" numeric(12,4),
"cd2" numeric(12,4),
"flap" varchar(3) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_pattern" (
"pattern_id" varchar(16) COLLATE "default" NOT NULL,
"pattern_type" varchar(16) COLLATE "default",
"factor_1" numeric(12,4),
"factor_2" numeric(12,4),
"factor_3" numeric(12,4),
"factor_4" numeric(12,4),
"factor_5" numeric(12,4),
"factor_6" numeric(12,4),
"factor_7" numeric(12,4),
"factor_8" numeric(12,4),
"factor_9" numeric(12,4),
"factor_10" numeric(12,4),
"factor_11" numeric(12,4),
"factor_12" numeric(12,4),
"factor_13" numeric(12,4),
"factor_14" numeric(12,4),
"factor_15" numeric(12,4),
"factor_16" numeric(12,4),
"factor_17" numeric(12,4),
"factor_18" numeric(12,4),
"factor_19" numeric(12,4),
"factor_20" numeric(12,4),
"factor_21" numeric(12,4),
"factor_22" numeric(12,4),
"factor_23" numeric(12,4),
"factor_24" numeric(12,4)
);


CREATE TABLE "sample_ud"."inp_pollutant" (
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"units_type" varchar(18) COLLATE "default",
"crain" numeric(12,4),
"cgw" numeric(12,4),
"cii" numeric(12,4),
"kd" numeric(12,4),
"sflag" varchar(3) COLLATE "default",
"copoll_id" varchar(16) COLLATE "default",
"cofract" numeric(12,4),
"cdwf" numeric(12,4)
);


CREATE TABLE "sample_ud"."inp_project_id" (
"title" varchar(254) COLLATE "default",
"author" varchar(50) COLLATE "default",
"date" varchar(12) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_pump" (
"arc_id" varchar(50) COLLATE "default" NOT NULL,
"curve_id" varchar(16) COLLATE "default",
"to_arc" varchar(16) COLLATE "default",
"status" varchar(3) COLLATE "default",
"startup" numeric(12,4),
"shutoff" numeric(12,4)
);



CREATE TABLE "sample_ud"."inp_rdii" (
"node_id" varchar(50) COLLATE "default" NOT NULL,
"hydro_id" varchar(16) COLLATE "default",
"sewerarea" numeric(16,6)
)
WITH (OIDS=FALSE);


CREATE TABLE "sample_ud"."inp_report" (
"input" varchar(18) COLLATE "default" NOT NULL,
"continuity" varchar(20) COLLATE "default",
"flowstats" varchar(3) COLLATE "default",
"controls" varchar(3) COLLATE "default",
"subcatchments" varchar(4) COLLATE "default",
"nodes" varchar(4) COLLATE "default",
"links" varchar(4) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_snowmelt" (
"stemp" numeric(12,4) NOT NULL,
"atiwt" numeric(12,4),
"rnm" numeric(12,4),
"elev" numeric(12,4),
"lat" numeric(12,4),
"dtlong" numeric(12,4),
"i_f0" numeric(12,4),
"i_f1" numeric(12,4),
"i_f2" numeric(12,4),
"i_f3" numeric(12,4),
"i_f4" numeric(12,4),
"i_f5" numeric(12,4),
"i_f6" numeric(12,4),
"i_f7" numeric(12,4),
"i_f8" numeric(12,4),
"i_f9" numeric(12,4),
"p_f0" numeric(12,4),
"p_f1" numeric(12,4),
"p_f2" numeric(12,4),
"p_f3" numeric(12,4),
"p_f4" numeric(12,4),
"p_f5" numeric(12,4),
"p_f6" numeric(12,4),
"p_f7" numeric(12,4),
"p_f8" numeric(12,4),
"p_f9" numeric(12,4)
);


CREATE TABLE "sample_ud"."inp_snowpack" (
"snow_id" varchar(16) COLLATE "default" NOT NULL,
"cmin_1" numeric(12,4),
"cmax_1" numeric(12,4),
"tbase_1" numeric(12,4),
"fwf_1" numeric(12,4),
"sd0_1" numeric(12,4),
"fw0_1" numeric(12,4),
"snn0_1" numeric(12,4),
"cmin_2" numeric(12,4),
"cmax_2" numeric(12,4),
"tbase_2" numeric(12,4),
"fwf_2" numeric(12,4),
"sd0_2" numeric(12,4),
"fw0_2" numeric(12,4),
"sd100_1" numeric(12,4),
"cmin_3" numeric(12,4),
"cmax_3" numeric(12,4),
"tbase_3" numeric(12,4),
"fwf_3" numeric(12,4),
"sd0_3" numeric(12,4),
"fw0_3" numeric(12,4),
"sd100_2" numeric(12,4),
"sdplow" numeric(12,4),
"fout" numeric(12,4),
"fimp" numeric(12,4),
"fperv" numeric(12,4),
"fimelt" numeric(12,4),
"fsub" numeric(12,4),
"subc_id" varchar(16) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_storage" (
"node_id" varchar(50) COLLATE "default" NOT NULL,
"storage_type" varchar(18) COLLATE "default",
"curve_id" varchar(16) COLLATE "default",
"a1" numeric(12,4),
"a2" numeric(12,4),
"a0" numeric(12,4),
"fevap" numeric(12,4),
"sh" numeric(12,4),
"hc" numeric(12,4),
"imd" numeric(12,4),
"y0" numeric(12,4),
"ysur" numeric(12,4),
"apond" numeric(12,4)
);


CREATE TABLE "sample_ud"."inp_temperature" (
"temp_type" varchar(16) COLLATE "default" NOT NULL,
"timser_id" varchar(16) COLLATE "default",
"fname" varchar(254) COLLATE "default",
"start" varchar(12) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_timeseries" (
"id" int4 DEFAULT nextval('"sample_ud".inp_timeseries_rel_id_seq'::regclass) NOT NULL,
"timser_id" varchar(16) COLLATE "default",
"date" varchar(12) COLLATE "default",
"hour" varchar(10) COLLATE "default",
"time" varchar(10) COLLATE "default",
"value" numeric(12,4),
"fname" varchar(254) COLLATE "default"
);



CREATE TABLE "sample_ud"."inp_timser_id" (
"id" varchar(16) COLLATE "default" NOT NULL,
"timser_type" varchar(20) COLLATE "default",
"times_type" varchar(16) COLLATE "default"
);



CREATE TABLE "sample_ud"."inp_transects" (
"id" int4 DEFAULT nextval('"sample_ud".inp_transects_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
);



CREATE TABLE "sample_ud"."inp_treatment_node_x_pol" (
"node_id" varchar(50) COLLATE "default" NOT NULL,
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"function" varchar(100) COLLATE "default"
);




CREATE TABLE "sample_ud"."inp_washoff_land_x_pol" (
"landus_id" varchar(16) COLLATE "default" NOT NULL,
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"funcw_type" varchar(18) COLLATE "default",
"c1" numeric(12,4),
"c2" numeric(12,4),
"sweepeffic" numeric(12,4),
"bmpeffic" numeric(12,4)
);



CREATE TABLE "sample_ud"."inp_weir" (
"arc_id" varchar(50) COLLATE "default" NOT NULL,
"weir_type" varchar(18) COLLATE "default",
"offset" numeric(12,4),
"cd" numeric(12,4),
"ec" numeric(12,4),
"cd2" numeric(12,4),
"flap" varchar(3) COLLATE "default",
"to_arc" varchar(16) COLLATE "default",
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00,
"surcharge" varchar (3)
);



CREATE TABLE "sample_ud"."inp_windspeed" (
"wind_type" varchar(16) COLLATE "default" NOT NULL,
"value_1" numeric(12,4),
"value_2" numeric(12,4),
"value_3" numeric(12,4),
"value_4" numeric(12,4),
"value_5" numeric(12,4),
"value_6" numeric(12,4),
"value_7" numeric(12,4),
"value_8" numeric(12,4),
"value_9" numeric(12,4),
"value_10" numeric(12,4),
"value_11" numeric(12,4),
"value_12" numeric(12,4),
"fname" varchar(254) COLLATE "default"
);





-- ----------------------------
-- Table structure for inp_typevalue & value
-- ----------------------------

CREATE TABLE "sample_ud"."inp_typevalue_divider" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_typevalue_evap" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_typevalue_orifice" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_typevalue_outfall" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_typevalue_outlet" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_typevalue_pattern" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_typevalue_raingage" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_typevalue_storage" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_typevalue_temp" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_typevalue_timeseries" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);


CREATE TABLE "sample_ud"."inp_typevalue_windsp" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);



CREATE TABLE "sample_ud"."inp_value_allnone" (
"id" varchar(18) COLLATE "default" NOT NULL
);


CREATE TABLE "sample_ud"."inp_value_buildup" (
"id" varchar(18) COLLATE "default" NOT NULL
);



CREATE TABLE "sample_ud"."inp_value_catarc" (
"id" varchar(18) COLLATE "default" NOT NULL
);



CREATE TABLE "sample_ud"."inp_value_curve" (
"id" varchar(18) COLLATE "default" NOT NULL
);



CREATE TABLE "sample_ud"."inp_value_files_actio" (
"id" varchar(18) COLLATE "default" NOT NULL
);



CREATE TABLE "sample_ud"."inp_value_files_type" (
"id" varchar(18) COLLATE "default" NOT NULL
);



CREATE TABLE "sample_ud"."inp_value_inflows" (
"id" varchar(18) COLLATE "default" NOT NULL
);




CREATE TABLE "sample_ud"."inp_value_lidcontrol" (
"id" varchar(18) COLLATE "default" NOT NULL
);



CREATE TABLE "sample_ud"."inp_value_mapunits" (
"id" varchar(18) COLLATE "default" NOT NULL
);




CREATE TABLE "sample_ud"."inp_value_options_fme" (
"id" varchar(16) COLLATE "default" NOT NULL
);




CREATE TABLE "sample_ud"."inp_value_options_fr" (
"id" varchar(16) COLLATE "default" NOT NULL
);




CREATE TABLE "sample_ud"."inp_value_options_fu" (
"id" varchar(16) COLLATE "default" NOT NULL
);




CREATE TABLE "sample_ud"."inp_value_options_id" (
"id" varchar(16) COLLATE "default" NOT NULL
);



CREATE TABLE "sample_ud"."inp_value_options_in" (
"id" varchar(16) COLLATE "default" NOT NULL
);




CREATE TABLE "sample_ud"."inp_value_options_lo" (
"id" varchar(16) COLLATE "default" NOT NULL
);



CREATE TABLE "sample_ud"."inp_value_options_nfl" (
"id" varchar(16) COLLATE "default" NOT NULL
);




CREATE TABLE "sample_ud"."inp_value_orifice" (
"id" varchar(18) COLLATE "default" NOT NULL
);




CREATE TABLE "sample_ud"."inp_value_pollutants" (
"id" varchar(18) COLLATE "default" NOT NULL
);




CREATE TABLE "sample_ud"."inp_value_raingage" (
"id" varchar(18) COLLATE "default" NOT NULL
);




CREATE TABLE "sample_ud"."inp_value_routeto" (
"id" varchar(18) COLLATE "default" NOT NULL
);




CREATE TABLE "sample_ud"."inp_value_status" (
"id" varchar(6) COLLATE "default" NOT NULL
);



CREATE TABLE "sample_ud"."inp_value_timserid" (
"id" varchar(20) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
);




CREATE TABLE "sample_ud"."inp_value_treatment" (
"id" varchar(18) COLLATE "default" NOT NULL
);



CREATE TABLE "sample_ud"."inp_value_washoff" (
"id" varchar(18) COLLATE "default" NOT NULL
);



CREATE TABLE "sample_ud"."inp_value_weirs" (
"id" varchar(18) COLLATE "default" NOT NULL,
"shape" varchar(18) COLLATE "default"
);



CREATE TABLE "sample_ud"."inp_value_yesno" (
"id" varchar(3) COLLATE "default" NOT NULL
);










-- ----------------------------
-- Table structure RPT
-- --------------------------

CREATE TABLE "sample_ud"."rpt_arcflow_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_arcflow_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"arc_id" varchar(50) COLLATE "default",
"arc_type" varchar(18) COLLATE "default",
"max_flow" numeric(12,4),
"time_days" varchar(10) COLLATE "default",
"time_hour" varchar(10) COLLATE "default",
"max_veloc" numeric(12,4),
"mfull_flow" numeric(12,4),
"mfull_dept" numeric(12,4),
"max_shear" numeric(12,4),
"max_hr" numeric(12,4),
"max_slope" numeric(12,4),
"day_max" varchar(10) COLLATE "default",
"time_max" varchar(10) COLLATE "default",
"min_shear" numeric(12,4),
"day_min" varchar(10) COLLATE "default",
 "time_min" varchar(10) COLLATE "default"
);



CREATE TABLE "sample_ud"."rpt_arcpolload_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_arcpolload_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"arc_id" varchar(16) COLLATE "default",
"poll_id" varchar(16) COLLATE "default",
CONSTRAINT "rpt_arcpolload_pkey" PRIMARY KEY ("id")
) WITH (OIDS=FALSE);



CREATE TABLE "sample_ud"."rpt_condsurcharge_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_condsurcharge_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"arc_id" varchar(50) COLLATE "default",
"both_ends" numeric(12,4),
"upstream" numeric(12,4),
"dnstream" numeric(12,4),
"hour_nflow" numeric(12,4),
"hour_limit" numeric(12,4)
);



CREATE TABLE "sample_ud"."rpt_continuity_errors" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_continuity_errors_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
);



CREATE TABLE "sample_ud"."rpt_critical_elements" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_critical_elements_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
);




CREATE TABLE "sample_ud"."rpt_flowclass_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_flowclass_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"arc_id" varchar(50) COLLATE "default",
"length" numeric(12,4),
"dry" numeric(12,4),
"up_dry" numeric(12,4),
"down_dry" numeric(12,4),
"sub_crit" numeric(12,4),
"sub_crit_1" numeric(12,4),
"up_crit" numeric(12,4),
"down_crit" numeric(12,4),
"froud_numb" numeric(12,4),
"flow_chang" numeric(12,4)
);




CREATE TABLE "sample_ud"."rpt_flowrouting_cont" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_flowrouting_cont_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"dryw_inf" numeric(12,4),
"wetw_inf" numeric(12,4),
"ground_inf" numeric(12,4),
"rdii_inf" numeric(12,4),
"ext_inf" numeric(12,4),
"ext_out" numeric(12,4),
"int_out" numeric(12,4),
"stor_loss" numeric(12,4),
"initst_vol" numeric(12,4),
"finst_vol" numeric(12,4),
"cont_error" numeric(12,4),
"evap_losses" numeric(6,4),
"seepage_losses" numeric(6,4)
);




CREATE TABLE "sample_ud"."rpt_groundwater_cont" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_groundwater_cont_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"init_stor" numeric(12,4),
"infilt" numeric(12,4),
"upzone_et" numeric(12,4),
"lowzone_et" numeric(12,4),
"deep_perc" numeric(12,4),
"groundw_fl" numeric(12,4),
"final_stor" numeric(12,4),
"cont_error" numeric(12,4)
);




CREATE TABLE "sample_ud"."rpt_high_conterrors" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_high_conterrors_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
);



CREATE TABLE "sample_ud"."rpt_high_flowinest_ind" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_high_flowinest_ind_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
);




CREATE TABLE "sample_ud"."rpt_instability_index" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_instability_index_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
);




CREATE TABLE "sample_ud"."rpt_lidperformance_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_lidperformance_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"subc_id" varchar(16) COLLATE "default",
"lidco_id" varchar(16) COLLATE "default",
"tot_inflow" numeric(12,4),
"evap_loss" numeric(12,4),
"infil_loss" numeric(12,4),
"surf_outf" numeric(12,4),
"drain_outf" numeric(12,4),
"init_stor" numeric(12,4),
"final_stor" numeric(12,4),
"per_error" numeric(12,4)
);





CREATE TABLE "sample_ud"."rpt_nodedepth_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_nodedepth_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(50) COLLATE "default",
"swnod_type" varchar(18) COLLATE "default",
"aver_depth" numeric(12,4),
"max_depth" numeric(12,4),
"max_hgl" numeric(12,4),
"time_days" varchar(10) COLLATE "default",
"time_hour" varchar(10) COLLATE "default"
);




CREATE TABLE "sample_ud"."rpt_nodeflooding_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_nodeflooding_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(50) COLLATE "default",
"hour_flood" numeric(12,4),
"max_rate" numeric(12,4),
"time_days" varchar(10) COLLATE "default",
"time_hour" varchar(10) COLLATE "default",
"tot_flood" numeric(12,4),
"max_ponded" numeric(12,4)
);




CREATE TABLE "sample_ud"."rpt_nodeinflow_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_nodeinflow_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(50) COLLATE "default",
"swnod_type" varchar(18) COLLATE "default",
"max_latinf" numeric(12,4),
"max_totinf" numeric(12,4),
"time_days" varchar(10) COLLATE "default",
"time_hour" varchar(10) COLLATE "default",
"latinf_vol" numeric(12,4),
"totinf_vol" numeric(12,4),
"flow_balance_error" numeric(12,2),
"other_info" varchar (12) COLLATE "default"
);




CREATE TABLE "sample_ud"."rpt_nodesurcharge_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_nodesurcharge_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(50) COLLATE "default",
"swnod_type" varchar(18) COLLATE "default",
"hour_surch" numeric(12,4),
"max_height" numeric(12,4),
"min_depth" numeric(12,4)
);




CREATE TABLE "sample_ud"."rpt_outfallflow_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_outfallflow_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(50) COLLATE "default",
"flow_freq" numeric(12,4),
"avg_flow" numeric(12,4),
"max_flow" numeric(12,4),
"total_vol" numeric(12,4)
);




CREATE TABLE "sample_ud"."rpt_outfallload_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_outfallload_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"poll_id" varchar(16) COLLATE "default",
"node_id" varchar(50) COLLATE "default",
"value" numeric(12,4)
);



CREATE TABLE "sample_ud"."rpt_pumping_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_pumping_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"arc_id" varchar(50) COLLATE "default",
"percent" numeric(12,4),
"num_startup" int4,
"min_flow" numeric(12,4),
"avg_flow" numeric(12,4),
"max_flow" numeric(12,4),
"vol_ltr" numeric(12,4),
"powus_kwh" numeric(12,4),
"timoff_min" numeric(12,4),
"timoff_max" numeric(12,4)
);




CREATE TABLE "sample_ud"."rpt_qualrouting_cont" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_qualrouting_cont_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"poll_id" varchar(16) COLLATE "default",
"dryw_inf" numeric(12,4),
"wetw_inf" numeric(12,4),
"ground_inf" numeric(12,4),
"rdii_inf" numeric(12,4),
"ext_inf" numeric(12,4),
"int_inf" numeric(12,4),
"ext_out" numeric(12,4),
"mass_reac" numeric(12,4),
"initst_mas" numeric(12,4),
"finst_mas" numeric(12,4),
"cont_error" numeric(12,4)
);




CREATE TABLE "sample_ud"."rpt_rainfall_dep" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_rainfall_dep_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"sewer_rain" numeric(12,4),
"rdiip_prod" numeric(12,4),
"rdiir_rat" numeric(12,4)
);




CREATE TABLE "sample_ud"."rpt_result_cat" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_result_cat_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"flow_units" varchar(3) COLLATE "default",
"rain_runof" varchar(3) COLLATE "default",
"snowmelt" varchar(3) COLLATE "default",
"groundw" varchar(3) COLLATE "default",
"flow_rout" varchar(3) COLLATE "default",
"pond_all" varchar(3) COLLATE "default",
"water_q" varchar(3) COLLATE "default",
"infil_m" varchar(18) COLLATE "default",
"flowrout_m" varchar(18) COLLATE "default",
"start_date" varchar(25) COLLATE "default",
"end_date" varchar(25) COLLATE "default",
"dry_days" numeric(12,4),
"rep_tstep" varchar(10) COLLATE "default",
"wet_tstep" varchar(10) COLLATE "default",
"dry_tstep" varchar(10) COLLATE "default",
"rout_tstep" varchar(10) COLLATE "default",
"var_time_step" varchar(3) COLLATE "default",
"max_trials" numeric(4,2), 
"head_tolerance" varchar(12) COLLATE "default",
"exec_date" timestamp(6) DEFAULT now()
);




CREATE TABLE "sample_ud"."rpt_routing_timestep" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_routing_timestep_id_seq'::regclass) NOT NULL,
"result_id" varchar(254) COLLATE "default",
"text" varchar(255) COLLATE "default"
);




CREATE TABLE "sample_ud"."rpt_runoff_qual" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_runoff_qual_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"poll_id" varchar(16) COLLATE "default",
"init_buil" numeric(12,4),
"surf_buil" numeric(12,4),
"wet_dep" numeric(12,4),
"sweep_re" numeric(12,4),
"infil_loss" numeric(12,4),
"bmp_re" numeric(12,4),
"surf_runof" numeric(12,4),
"rem_buil" numeric(12,4),
"cont_error" numeric(12,4)
);



CREATE TABLE "sample_ud"."rpt_runoff_quant" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_runoff_quant_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"initsw_co" numeric(12,4),
"total_prec" numeric(12,4),
"evap_loss" numeric(12,4),
"infil_loss" numeric(12,4),
"surf_runof" numeric(12,4),
"snow_re" numeric(12,4),
"finalsw_co" numeric(12,4),
"finals_sto" numeric(12,4),
"cont_error" numeric(16,4),
"initlid_sto" numeric(12,4)
);



CREATE TABLE "sample_ud"."rpt_storagevol_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_storagevol_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(50) COLLATE "default",
"aver_vol" numeric(12,4),
"avg_full" numeric(12,4),
"ei_loss" numeric(12,4),
"max_vol" numeric(12,4),
"max_full" numeric(12,4),
"time_days" varchar(10) COLLATE "default",
"time_hour" varchar(10) COLLATE "default",
"max_out" numeric(12,4)
);




CREATE TABLE "sample_ud"."rpt_subcatchwashoff_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_subcatchwashoff_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"value" numeric
);




CREATE TABLE "sample_ud"."rpt_subcathrunoff_sum" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_subcathrunoff_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"subc_id" varchar(16) COLLATE "default",
"tot_precip" numeric(12,4),
"tot_runon" numeric(12,4),
"tot_evap" numeric(12,4),
"tot_infil" numeric(12,4),
"tot_runoff" numeric(12,4),
"tot_runofl" numeric(12,4),
"peak_runof" numeric(12,4),
"runoff_coe" numeric(12,4),
"vxmax" numeric(12,4),
"vymax" numeric(12,4),
"depth" numeric(12,4),
"vel" numeric(12,4),
"vhmax" numeric(12,6)
);




CREATE TABLE "sample_ud"."rpt_timestep_critelem" (
"id" int4 DEFAULT nextval('"sample_ud".rpt_timestep_critelem_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
);





-- ----------------------------
-- Table structure for SELECTORS
-- ----------------------------

CREATE TABLE "sample_ud"."result_selection" (
"result_id" varchar(16) COLLATE "default" NOT NULL
)WITH (OIDS=FALSE)
;


CREATE TABLE "sample_ud"."sector_selection" (
"sector_id" varchar(30) COLLATE "default" NOT NULL
)WITH (OIDS=FALSE)
;



CREATE TABLE "sample_ud"."state_selection" (
"id" varchar(16) COLLATE "default" NOT NULL,
"observ" varchar(254) COLLATE "default",
CONSTRAINT state_selection_pkey PRIMARY KEY (id)
)WITH (OIDS=FALSE)
;



CREATE TABLE "sample_ud"."hydrology_selection" (
"hydrology_id" varchar(20) COLLATE "default" NOT NULL,
CONSTRAINT "hydrology_selection_pkey" PRIMARY KEY ("hydrology_id")
)
WITH (OIDS=FALSE);




-- ----------------------------
-- Primary Key structure
-- ----------------------------
ALTER TABLE "sample_ud"."inp_aquifer" ADD PRIMARY KEY ("aquif_id");
ALTER TABLE "sample_ud"."inp_backdrop" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_buildup_land_x_pol" ADD PRIMARY KEY ("landus_id", "poll_id");
ALTER TABLE "sample_ud"."inp_conduit" ADD PRIMARY KEY ("arc_id");
ALTER TABLE "sample_ud"."inp_controls" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_coverage_land_x_subc" ADD PRIMARY KEY ("subc_id", "landus_id");
ALTER TABLE "sample_ud"."inp_curve" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_curve_id" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_divider" ADD PRIMARY KEY ("node_id");
ALTER TABLE "sample_ud"."inp_dwf" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_dwf_pol_x_node" ADD PRIMARY KEY ("poll_id", "node_id");
ALTER TABLE "sample_ud"."inp_evaporation" ADD PRIMARY KEY ("evap_type");
ALTER TABLE "sample_ud"."inp_files" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_groundwater" ADD PRIMARY KEY ("subc_id", "aquif_id");
ALTER TABLE "sample_ud"."inp_hydrograph" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_inflows" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_inflows_pol_x_node" ADD PRIMARY KEY ("poll_id", "node_id");
ALTER TABLE "sample_ud"."inp_junction" ADD PRIMARY KEY ("node_id");
ALTER TABLE "sample_ud"."inp_label" ADD PRIMARY KEY ("label");
ALTER TABLE "sample_ud"."inp_landuses" ADD PRIMARY KEY ("landus_id");
ALTER TABLE "sample_ud"."inp_lid_control" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_lidusage_subc_x_lidco" ADD PRIMARY KEY ("subc_id", "lidco_id");
ALTER TABLE "sample_ud"."inp_loadings_pol_x_subc" ADD PRIMARY KEY ("poll_id", "subc_id");
ALTER TABLE "sample_ud"."inp_options" ADD PRIMARY KEY ("flow_units");
ALTER TABLE "sample_ud"."inp_orifice" ADD PRIMARY KEY ("arc_id");
ALTER TABLE "sample_ud"."inp_outfall" ADD PRIMARY KEY ("node_id");
ALTER TABLE "sample_ud"."inp_outlet" ADD PRIMARY KEY ("arc_id");
ALTER TABLE "sample_ud"."inp_pattern" ADD PRIMARY KEY ("pattern_id");
ALTER TABLE "sample_ud"."inp_pollutant" ADD PRIMARY KEY ("poll_id");
ALTER TABLE "sample_ud"."inp_project_id" ADD PRIMARY KEY ("title");
ALTER TABLE "sample_ud"."inp_pump" ADD PRIMARY KEY ("arc_id");
ALTER TABLE "sample_ud"."inp_rdii" ADD PRIMARY KEY ("node_id");
ALTER TABLE "sample_ud"."inp_report" ADD PRIMARY KEY ("input");
ALTER TABLE "sample_ud"."inp_snowmelt" ADD PRIMARY KEY ("stemp");
ALTER TABLE "sample_ud"."inp_snowpack" ADD PRIMARY KEY ("snow_id");
ALTER TABLE "sample_ud"."inp_storage" ADD PRIMARY KEY ("node_id");
ALTER TABLE "sample_ud"."inp_temperature" ADD PRIMARY KEY ("temp_type");
ALTER TABLE "sample_ud"."inp_timeseries" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_timser_id" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_transects" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_treatment_node_x_pol" ADD PRIMARY KEY ("node_id", "poll_id");
ALTER TABLE "sample_ud"."inp_typevalue_divider" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_typevalue_evap" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_typevalue_orifice" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_typevalue_outfall" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_typevalue_outlet" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_typevalue_pattern" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_typevalue_raingage" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_typevalue_storage" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_typevalue_temp" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_typevalue_timeseries" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_typevalue_windsp" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_allnone" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_buildup" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_curve" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_files_actio" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_files_type" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_inflows" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_lidcontrol" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_mapunits" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_options_fme" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_options_fr" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_options_fu" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_options_id" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_options_in" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_options_lo" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_options_nfl" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_orifice" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_pollutants" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_raingage" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_timserid" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_treatment" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_washoff" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_weirs" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_value_yesno" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."inp_washoff_land_x_pol" ADD PRIMARY KEY ("landus_id", "poll_id");
ALTER TABLE "sample_ud"."inp_weir" ADD PRIMARY KEY ("arc_id");
ALTER TABLE "sample_ud"."inp_windspeed" ADD PRIMARY KEY ("wind_type");
ALTER TABLE "sample_ud"."raingage" ADD PRIMARY KEY ("rg_id");
ALTER TABLE "sample_ud"."result_selection" ADD PRIMARY KEY ("result_id");
ALTER TABLE "sample_ud"."rpt_arcflow_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_condsurcharge_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_continuity_errors" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_critical_elements" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_flowclass_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_flowrouting_cont" ADD PRIMARY KEY ("result_id");
ALTER TABLE "sample_ud"."rpt_groundwater_cont" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_high_conterrors" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_high_flowinest_ind" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_instability_index" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_lidperformance_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_nodedepth_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_nodeflooding_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_nodeinflow_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_nodesurcharge_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_outfallflow_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_outfallload_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_pumping_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_qualrouting_cont" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_rainfall_dep" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_result_cat" ADD PRIMARY KEY ("result_id");
ALTER TABLE "sample_ud"."rpt_routing_timestep" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_runoff_qual" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_runoff_quant" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_storagevol_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_subcatchwashoff_sum" ADD PRIMARY KEY ("result_id", "subc_id", "poll_id");
ALTER TABLE "sample_ud"."rpt_subcathrunoff_sum" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."rpt_timestep_critelem" ADD PRIMARY KEY ("id");
ALTER TABLE "sample_ud"."sector_selection" ADD PRIMARY KEY ("sector_id");
ALTER TABLE "sample_ud"."subcatchment" ADD PRIMARY KEY ("subc_id");



-- ----------------------------
-- Foreign Key system structure
-- ----------------------------
ALTER TABLE "sample_ud"."arc" ADD FOREIGN KEY ("epa_type") REFERENCES "sample_ud"."inp_arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."node" ADD FOREIGN KEY ("epa_type") REFERENCES "sample_ud"."inp_node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- ----------------------------
-- Foreign Key structure 
-- ----------------------------

ALTER TABLE "sample_ud"."inp_conduit" ADD FOREIGN KEY ("arc_id") REFERENCES "sample_ud"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_curve" ADD FOREIGN KEY ("curve_id") REFERENCES "sample_ud"."inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_divider" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_dwf" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_dwf_pol_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_inflows" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_inflows_pol_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_junction" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_orifice" ADD FOREIGN KEY ("arc_id") REFERENCES "sample_ud"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("allow_ponding") REFERENCES "sample_ud"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("normal_flow_limited") REFERENCES "sample_ud"."inp_value_options_nfl" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("inertial_damping") REFERENCES "sample_ud"."inp_value_options_id" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("skip_steady_state") REFERENCES "sample_ud"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("ignore_quality") REFERENCES "sample_ud"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("ignore_routing") REFERENCES "sample_ud"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("ignore_groundwater") REFERENCES "sample_ud"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("ignore_snowmelt") REFERENCES "sample_ud"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("ignore_rainfall") REFERENCES "sample_ud"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("force_main_equation") REFERENCES "sample_ud"."inp_value_options_fme" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("link_offsets") REFERENCES "sample_ud"."inp_value_options_lo" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("flow_routing") REFERENCES "sample_ud"."inp_value_options_fr" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_options" ADD FOREIGN KEY ("flow_units") REFERENCES "sample_ud"."inp_value_options_fu" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_outfall" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_outlet" ADD FOREIGN KEY ("arc_id") REFERENCES "sample_ud"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_pump" ADD FOREIGN KEY ("arc_id") REFERENCES "sample_ud"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_rdii" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_report" ADD FOREIGN KEY ("controls") REFERENCES "sample_ud"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_report" ADD FOREIGN KEY ("input") REFERENCES "sample_ud"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_report" ADD FOREIGN KEY ("continuity") REFERENCES "sample_ud"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."inp_report" ADD FOREIGN KEY ("flowstats") REFERENCES "sample_ud"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_storage" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_timeseries" ADD FOREIGN KEY ("timser_id") REFERENCES "sample_ud"."inp_timser_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_treatment_node_x_pol" ADD FOREIGN KEY ("node_id") REFERENCES "sample_ud"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."inp_weir" ADD FOREIGN KEY ("arc_id") REFERENCES "sample_ud"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_arcflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_condsurcharge_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_continuity_errors" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_critical_elements" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_flowclass_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_flowrouting_cont" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_groundwater_cont" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_high_conterrors" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_high_flowinest_ind" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_instability_index" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_lidperformance_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_nodedepth_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_nodeflooding_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_nodeinflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_nodesurcharge_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_outfallflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_outfallload_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_pumping_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_qualrouting_cont" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_rainfall_dep" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_routing_timestep" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_runoff_qual" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_runoff_quant" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_storagevol_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_subcatchwashoff_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_subcathrunoff_sum" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."rpt_timestep_critelem" ADD FOREIGN KEY ("result_id") REFERENCES "sample_ud"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sample_ud"."subcatchment" ADD FOREIGN KEY ("sector_id") REFERENCES "sample_ud"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "sample_ud"."subcatchment" ADD FOREIGN KEY ("hydrology_id") REFERENCES "sample_ud"."cat_hydrology" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

