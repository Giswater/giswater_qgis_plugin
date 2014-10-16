/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- ----------------------------
-- Sequence structure for inp_node_id_seq
-- --------------------------

CREATE SEQUENCE "SCHEMA_NAME".inp_node_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
	
	
-- ----------------------------
-- Sequence structure for inp_arc_id_seq
-- --------------------------

CREATE SEQUENCE "SCHEMA_NAME".inp_arc_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


-- ----------------------------
-- Sequence structure for version_seq
-- ---------------------------
CREATE SEQUENCE "SCHEMA_NAME"."version_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_aquifer_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_aquifer_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_backdrop_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_backdrop_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_controls_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_controls_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_curve_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_curve_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_files_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_files_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_hydrograph_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_hydrograph_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_inflows_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_inflows_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
-- ----------------------------
-- Sequence structure for inp_lid_control_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_lid_control_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_mapdim_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_mapdim_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_mapunits_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_mapunits_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_options_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_options_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_project_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_project_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_report_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_report_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_sector_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_sector_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_timeseries_rel_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_timeseries_rel_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_transects_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_transects_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for inp_vertice_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_vertice_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_arcflow_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_arcflow_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_condsurcharge_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_condsurcharge_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_continuity_errors_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_continuity_errors_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_critical_elements_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_critical_elements_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_flowclass_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_flowclass_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_flowrouting_cont_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_flowrouting_cont_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_groundwater_cont_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_groundwater_cont_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_high_conterrors_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_high_conterrors_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_high_flowinest_ind_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_high_flowinest_ind_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_instability_index_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_instability_index_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_lidperformance_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_lidperformance_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_nodedepth_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_nodedepth_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_nodeflooding_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_nodeflooding_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_nodeinflow_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_nodeinflow_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_nodesurcharge_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_nodesurcharge_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
-- ----------------------------
-- Sequence structure for rpt_outfallflow_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_outfallflow_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_outfallload_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_outfallload_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_pumping_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_pumping_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_qualrouting_cont_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_qualrouting_cont_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_rainfall_dep_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_rainfall_dep_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_result_cat_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_result_cat_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_routing_timestep_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_routing_timestep_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_runoff_qual_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_runoff_qual_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_runoff_quant_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_runoff_quant_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_storagevol_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_storagevol_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_subcatchwashoff_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_subcatchwashoff_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_subcathrunoff_sum_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_subcathrunoff_sum_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_timestep_critelem_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_timestep_critelem_id_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
 
  -- ----------------------------
-- Table structure for version
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."version" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".version_seq'::regclass) NOT NULL,
"giswater" varchar(16) COLLATE "default",
"wsoftware" varchar(16) COLLATE "default",
"postgres" varchar(512) COLLATE "default",
"postgis" varchar(512) COLLATE "default",
"date" timestamp(6) DEFAULT now()
)
WITH (OIDS=FALSE)
;

-- ----------------------------
-- Table structure for arc
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."arc" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"node_1" varchar(16) COLLATE "default",
"node_2" varchar(16) COLLATE "default",
"z1" numeric(12,4) DEFAULT 0.00,
"z2" numeric(12,4) DEFAULT 0.00,
"arccat_id" varchar(16) COLLATE "default",
"matcat_id" varchar(16) COLLATE "default",
"swmm_type" varchar(18) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"the_geom" geometry (LINESTRING, SRID_VALUE)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for cat_arc
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."cat_arc" (
"id" varchar(16) COLLATE "default" NOT NULL,
"shape" varchar(16) COLLATE "default",
"tsect_id" varchar(16) COLLATE "default",
"curve_id" varchar(16) COLLATE "default",
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00,
"geom_r" varchar(20) COLLATE "default",
"short_des" varchar(16) COLLATE "default",
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for cat_mat
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."cat_mat" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default",
"n" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_aquifer
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_aquifer" (
"aquif_id" varchar(16) DEFAULT nextval('"SCHEMA_NAME".inp_aquifer_id_seq'::regclass) NOT NULL,
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
"umc" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_backdrop
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_backdrop" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_backdrop_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_buildup_land_x_pol
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_buildup_land_x_pol" (
"landus_id" varchar(16) COLLATE "default" NOT NULL,
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"funcb_type" varchar(18) COLLATE "default",
"c1" numeric(12,4),
"c2" numeric(12,4),
"c3" numeric(12,4),
"perunit" varchar(10) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_conduit
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_conduit" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"barrels" int2,
"culvert" varchar(10) COLLATE "default",
"kentry" numeric(12,4),
"kexit" numeric(12,4),
"kavg" numeric(12,4),
"flap" varchar(3) COLLATE "default",
"q0" numeric(12,4),
"qmax" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_controls
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_controls" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_controls_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_coverage_land_x_subc
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_coverage_land_x_subc" (
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"landus_id" varchar(16) COLLATE "default" NOT NULL,
"percent" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_curve
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_curve" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_curve_id_seq'::regclass) NOT NULL,
"curve_id" varchar(16) COLLATE "default",
"x_value" numeric(18,6),
"y_value" numeric(18,6)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_curve_id
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_curve_id" (
"id" varchar(16) COLLATE "default" NOT NULL,
"curve_type" varchar(20) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_divider
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_divider" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"divider_type" varchar(18) COLLATE "default",
"arc_id" varchar(16) COLLATE "default",
"curve_id" varchar(16) COLLATE "default",
"qmin" numeric(16,6),
"ht" numeric(12,4),
"cd" numeric(12,4),
"y0" numeric(12,4),
"ysur" numeric(12,4),
"apond" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_dwf
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_dwf" (
"id" int4 NOT NULL,
"node_id" varchar(16) COLLATE "default",
"value" numeric(12,5),
"pat1" varchar(16) COLLATE "default",
"pat2" varchar(16) COLLATE "default",
"pat3" varchar(16) COLLATE "default",
"pat4" varchar(16) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_dwf_pol_x_node
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_dwf_pol_x_node" (
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"node_id" varchar(16) COLLATE "default" NOT NULL,
"value" numeric(12,4),
"pat1" varchar(16) COLLATE "default",
"pat2" varchar(16) COLLATE "default",
"pat3" varchar(16) COLLATE "default",
"pat4" varchar(16) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_evaporation
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_evaporation" (
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
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_files
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_files" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_files_id_seq'::regclass) NOT NULL,
"actio_type" varchar(18) COLLATE "default",
"file_type" varchar(18) COLLATE "default",
"fname" varchar(254) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_groundwater
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_groundwater" (
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"aquif_id" varchar(16) NOT NULL,
"node_id" varchar(16) COLLATE "default",
"surfel" numeric(10,4),
"a1" numeric(10,4),
"b1" numeric(10,4),
"a2" numeric(10,4),
"b2" numeric(10,4),
"a3" numeric(10,4),
"tw" numeric(10,4),
"h" numeric(10,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_hydrograph
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_hydrograph" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_hydrograph_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_inflows
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_inflows" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_inflows_id_seq'::regclass) NOT NULL,
"node_id" varchar(16) COLLATE "default",
"timser_id" varchar(16) COLLATE "default",
"sfactor" numeric(12,4),
"base" numeric(12,4),
"pattern_id" varchar(16) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_inflows_pol_x_node
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_inflows_pol_x_node" (
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"node_id" varchar(16) COLLATE "default" NOT NULL,
"timser_id" varchar(16) COLLATE "default",
"form_type" varchar(18) COLLATE "default",
"mfactor" numeric(12,4),
"sfactor" numeric(12,4),
"base" numeric(12,4),
"pattern_id" varchar(16) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_junction
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_junction" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"y0" numeric(12,4),
"ysur" numeric(12,4),
"apond" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_label
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_label" (
"label" varchar(16) COLLATE "default" NOT NULL,
"xcoord" numeric(18,6),
"ycoord" numeric(18,6),
"anchor" varchar(16) COLLATE "default",
"font" varchar(50) COLLATE "default",
"size" numeric(12,4),
"bold" varchar(3) COLLATE "default",
"italic" varchar(3) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_landuses
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_landuses" (
"landus_id" varchar(16) COLLATE "default" NOT NULL,
"sweepint" numeric(12,4),
"availab" numeric(12,4),
"lastsweep" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_lid_control
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_lid_control" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_lid_control_id_seq'::regclass) NOT NULL,
"lidco_id" varchar(16) COLLATE "default",
"lidco_type" varchar(10) COLLATE "default",
"value_2" numeric(12,4),
"value_3" numeric(12,4),
"value_4" numeric(12,4),
"value_5" numeric(12,4),
"value_6" numeric(12,4),
"value_7" numeric(12,4),
"value_8" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_lidusage_subc_x_lidco
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_lidusage_subc_x_lidco" (
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"lidco_id" varchar(16) COLLATE "default" NOT NULL,
"number" int2,
"area" numeric(16,6),
"width" numeric(12,4),
"initsat" numeric(12,4),
"fromimp" numeric(12,4),
"toperv" int2,
"rptfile" varchar(10) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_loadings_pol_x_subc
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_loadings_pol_x_subc" (
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"ibuildup" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_mapdim
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_mapdim" (
"type_dim" varchar(18) COLLATE "default",
"x1" numeric(18,6),
"y1" numeric(18,6),
"x2" numeric(18,6),
"y2" numeric(18,6)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_mapunits
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_mapunits" (
"type_units" varchar(18) COLLATE "default",
"map_type" varchar(18) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_options
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_options" (
"flow_units" varchar(20) COLLATE "default" NOT NULL,
"infiltration" varchar(20) COLLATE "default",
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
"lengthening_step" numeric,
"variable_step" numeric,
"inertial_damping" varchar(12) COLLATE "default",
"normal_flow_limited" varchar(12) COLLATE "default",
"min_surfarea" numeric,
"min_slope" numeric,
"allow_ponding" varchar(3) COLLATE "default",
"tempdir" varchar(254) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_orifice
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_orifice" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"ori_type" varchar(18) COLLATE "default",
"offset" numeric(12,4),
"cd" numeric(12,4),
"orate" numeric(12,4),
"flap" varchar(3) COLLATE "default",
"shape" varchar(18) COLLATE "default",
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_outfall
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_outfall" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"outfall_type" varchar(16) COLLATE "default",
"stage" numeric(6,4),
"curve_id" varchar(16) COLLATE "default",
"timser_id" varchar(16) COLLATE "default",
"gate" varchar(3) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_outlet
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_outlet" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"outlet_type" varchar(16) COLLATE "default",
"offset" numeric(12,4),
"curve_id" varchar(16) COLLATE "default",
"cd1" numeric(12,4),
"cd2" numeric(12,4),
"flap" varchar(3) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_pattern
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_pattern" (
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
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_pollutant
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_pollutant" (
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
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_project_id
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_project_id" (
"title" varchar(254) COLLATE "default",
"author" varchar(50) COLLATE "default",
"date" varchar(12) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_pump
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_pump" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"curve_id" varchar(16) COLLATE "default",
"status" varchar(3) COLLATE "default",
"startup" numeric(12,4),
"shutoff" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_rdii
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_rdii" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"hydro_id" varchar(16) COLLATE "default",
"sewerarea" numeric(16,6)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_report
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_report" (
"input" varchar(18) COLLATE "default" NOT NULL,
"continuity" varchar(20) COLLATE "default",
"flowstats" varchar(3) COLLATE "default",
"controls" varchar(3) COLLATE "default",
"subcatchments" varchar(4) COLLATE "default",
"nodes" varchar(4) COLLATE "default",
"links" varchar(4) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_snowmelt
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_snowmelt" (
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
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_snowpack
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_snowpack" (
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
)
WITH (OIDS=FALSE)

;


-- ----------------------------
-- Table structure for inp_storage
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_storage" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
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
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_temperature
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_temperature" (
"temp_type" varchar(16) COLLATE "default" NOT NULL,
"timser_id" varchar(16) COLLATE "default",
"fname" varchar(254) COLLATE "default",
"start" varchar(12) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_timeseries
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_timeseries" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_timeseries_rel_id_seq'::regclass) NOT NULL,
"timser_id" varchar(16) COLLATE "default",
"date" varchar(12) COLLATE "default",
"hour" varchar(10) COLLATE "default",
"time" varchar(10) COLLATE "default",
"value" numeric(12,4),
"fname" varchar(254) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_timser_id
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_timser_id" (
"id" varchar(16) COLLATE "default" NOT NULL,
"timser_type" varchar(20) COLLATE "default",
"times_type" varchar(16) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_transects
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_transects" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_transects_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_treatment_node_x_pol
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_treatment_node_x_pol" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"function" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_type_arc
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_type_arc" (
"id" varchar(18) COLLATE "default" NOT NULL,
"table" varchar(30) COLLATE "default",
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_type_node
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_type_node" (
"id" varchar(18) COLLATE "default" NOT NULL,
"table" varchar(30) COLLATE "default",
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_divider
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_divider" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_evap
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_evap" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_orifice
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_orifice" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_outfall
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_outfall" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;


-- ----------------------------
-- Table structure for inp_typevalue_outlet
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_outlet" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_pattern
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_pattern" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_raingage
-- ----------------------------




CREATE TABLE "SCHEMA_NAME"."inp_typevalue_raingage" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_storage
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_storage" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_temp
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_temp" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_timeseries
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_timeseries" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_windsp
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_windsp" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_allnone
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_allnone" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;


-- ----------------------------
-- Table structure for inp_value_buildup
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_buildup" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_catarc
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_catarc" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)
;


-- ----------------------------
-- Table structure for inp_value_curve
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_curve" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_files_actio
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_files_actio" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_files_type
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_files_type" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_inflows
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_inflows" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_lidcontrol
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_lidcontrol" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_mapunits
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_mapunits" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_options_fme
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_options_fme" (
"id" varchar(16) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_options_fr
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_options_fr" (
"id" varchar(16) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_options_fu
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_options_fu" (
"id" varchar(16) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_options_id
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_options_id" (
"id" varchar(16) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_options_in
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_options_in" (
"id" varchar(16) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_options_lo
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_options_lo" (
"id" varchar(16) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_options_nfl
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_options_nfl" (
"id" varchar(16) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_orifice
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_orifice" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_pollutants
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_pollutants" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_raingage
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_raingage" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_routeto
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_routeto" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_status
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_status" (
"id" varchar(6) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_timserid
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_timserid" (
"id" varchar(20) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_treatment
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_treatment" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_washoff
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_washoff" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_weirs
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_weirs" (
"id" varchar(18) COLLATE "default" NOT NULL,
"shape" varchar(18) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_yesno
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_yesno" (
"id" varchar(3) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_washoff_land_x_pol
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_washoff_land_x_pol" (
"landus_id" varchar(16) COLLATE "default" NOT NULL,
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"funcw_type" varchar(18) COLLATE "default",
"c1" numeric(12,4),
"c2" numeric(12,4),
"sweepeffic" numeric(12,4),
"bmpeffic" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_weir
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_weir" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"weir_type" varchar(18) COLLATE "default",
"offset" numeric(12,4),
"cd" numeric(12,4),
"ec" numeric(12,4),
"cd2" numeric(12,4),
"flap" varchar(3) COLLATE "default",
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_windspeed
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_windspeed" (
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
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for node
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."node" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"top_elev" numeric(12,4) DEFAULT 0.00,
"ymax" numeric(12,4) DEFAULT 0.00,
"swmm_type" varchar(18) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"the_geom" geometry (POINT, SRID_VALUE)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for raingage
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."raingage" (
"rg_id" varchar(16) COLLATE "default" NOT NULL,
"form_type" varchar(12) COLLATE "default",
"intvl" varchar(10) COLLATE "default",
"scf" numeric(12,4),
"rgage_type" varchar(18) COLLATE "default",
"timser_id" varchar(16) COLLATE "default",
"fname" varchar(254) COLLATE "default",
"sta" varchar(12) COLLATE "default",
"units" varchar(3) COLLATE "default",
"the_geom" geometry (POINT, SRID_VALUE)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for result_selection
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."result_selection" (
"result_id" varchar(16) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_arcflow_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_arcflow_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_arcflow_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"arc_id" varchar(16) COLLATE "default",
"arc_type" varchar(18) COLLATE "default",
"max_flow" numeric(12,4),
"time_days" varchar(10) COLLATE "default",
"time_hour" varchar(10) COLLATE "default",
"max_veloc" numeric(12,4),
"mfull_flow" numeric(12,4),
"mfull_dept" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_condsurcharge_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_condsurcharge_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_condsurcharge_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"arc_id" varchar(16) COLLATE "default",
"both_ends" numeric(12,4),
"upstream" numeric(12,4),
"dnstream" numeric(12,4),
"hour_nflow" numeric(12,4),
"hour_limit" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_continuity_errors
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_continuity_errors" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_continuity_errors_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_critical_elements
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_critical_elements" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_critical_elements_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_flowclass_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_flowclass_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_flowclass_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"arc_id" varchar(16) COLLATE "default",
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
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_flowrouting_cont
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_flowrouting_cont" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_flowrouting_cont_id_seq'::regclass) NOT NULL,
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
"cont_error" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_groundwater_cont
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_groundwater_cont" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_groundwater_cont_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"init_stor" numeric(12,4),
"infilt" numeric(12,4),
"upzone_et" numeric(12,4),
"lowzone_et" numeric(12,4),
"deep_perc" numeric(12,4),
"groundw_fl" numeric(12,4),
"final_stor" numeric(12,4),
"cont_error" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_high_conterrors
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_high_conterrors" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_high_conterrors_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_high_flowinest_ind
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_high_flowinest_ind" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_high_flowinest_ind_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_instability_index
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_instability_index" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_instability_index_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_lidperformance_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_lidperformance_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_lidperformance_sum_id_seq'::regclass) NOT NULL,
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
)
WITH (OIDS=FALSE)

;


-- ----------------------------
-- Table structure for rpt_nodedepth_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_nodedepth_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_nodedepth_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(16) COLLATE "default",
"swnod_type" varchar(18) COLLATE "default",
"aver_depth" numeric(12,4),
"max_depth" numeric(12,4),
"max_hgl" numeric(12,4),
"time_days" varchar(10) COLLATE "default",
"time_hour" varchar(10) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_nodeflooding_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_nodeflooding_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_nodeflooding_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(16) COLLATE "default",
"hour_flood" numeric(12,4),
"max_rate" numeric(12,4),
"time_days" varchar(10) COLLATE "default",
"time_hour" varchar(10) COLLATE "default",
"tot_flood" numeric(12,4),
"max_ponded" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_nodeinflow_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_nodeinflow_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_nodeinflow_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(16) COLLATE "default",
"swnod_type" varchar(18) COLLATE "default",
"max_latinf" numeric(12,4),
"max_totinf" numeric(12,4),
"time_days" varchar(10) COLLATE "default",
"time_hour" varchar(10) COLLATE "default",
"latinf_vol" numeric(12,4),
"totinf_vol" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_nodesurcharge_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_nodesurcharge_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_nodesurcharge_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(16) COLLATE "default",
"swnod_type" varchar(18) COLLATE "default",
"hour_surch" numeric(12,4),
"max_height" numeric(12,4),
"min_depth" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_outfallflow_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_outfallflow_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_outfallflow_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(16) COLLATE "default",
"flow_freq" numeric(12,4),
"avg_flow" numeric(12,4),
"max_flow" numeric(12,4),
"total_vol" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_outfallload_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_outfallload_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_outfallload_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"poll_id" varchar(16) COLLATE "default",
"node_id" varchar(16) COLLATE "default",
"value" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_pumping_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_pumping_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_pumping_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"arc_id" varchar(16) COLLATE "default",
"percent" numeric(12,4),
"max_flow" numeric(12,4),
"avg_flow" numeric(12,4),
"vol_ltr" numeric(12,4),
"powus_kwh" numeric(12,4),
"timoff_cur" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_qualrouting_cont
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_qualrouting_cont" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_qualrouting_cont_id_seq'::regclass) NOT NULL,
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
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_rainfall_dep
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_rainfall_dep" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_rainfall_dep_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"sewer_rain" numeric(12,4),
"rdiip_prod" numeric(12,4),
"rdiir_rat" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_result_cat
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_result_cat" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_result_cat_id_seq'::regclass) NOT NULL,
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
"exec_date" timestamp(6) DEFAULT now()
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_routing_timestep
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_routing_timestep" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_routing_timestep_id_seq'::regclass) NOT NULL,
"result_id" varchar(254) COLLATE "default",
"text" varchar(255) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_runoff_qual
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_runoff_qual" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_runoff_qual_id_seq'::regclass) NOT NULL,
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
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_runoff_quant
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_runoff_quant" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_runoff_quant_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"initsw_co" numeric(12,4),
"total_prec" numeric(12,4),
"evap_loss" numeric(12,4),
"infil_loss" numeric(12,4),
"surf_runof" numeric(12,4),
"snow_re" numeric(12,4),
"finalsw_co" numeric(12,4),
"finals_sto" numeric(12,4),
"cont_error" numeric(16,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_storagevol_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_storagevol_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_storagevol_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"node_id" varchar(16) COLLATE "default",
"aver_vol" numeric(12,4),
"avg_full" numeric(12,4),
"ei_loss" numeric(12,4),
"max_vol" numeric(12,4),
"max_full" numeric(12,4),
"time_days" varchar(10) COLLATE "default",
"time_hour" varchar(10) COLLATE "default",
"max_out" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_subcatchwashoff_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_subcatchwashoff_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_subcatchwashoff_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"poll_id" varchar(16) COLLATE "default" NOT NULL,
"value" numeric
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_subcathrunoff_sum
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_subcathrunoff_sum" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_subcathrunoff_sum_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"subc_id" varchar(16) COLLATE "default",
"tot_precip" numeric(12,4),
"tot_runon" numeric(12,4),
"tot_evap" numeric(12,4),
"tot_infil" numeric(12,4),
"tot_runoff" numeric(12,4),
"tot_runofl" numeric(12,4),
"peak_runof" numeric(12,4),
"runoff_coe" numeric(12,4)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_timestep_critelem
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_timestep_critelem" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_timestep_critelem_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default",
"text" varchar(255) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for sector
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."sector" (
"sector_id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default",
"the_geom" geometry (MULTIPOLYGON, SRID_VALUE)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for sector_selection
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."sector_selection" (
"sector_id" varchar(30) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for subcatchment
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."subcatchment" (
"subc_id" varchar(16) COLLATE "default" NOT NULL,
"node_id" varchar(16) COLLATE "default",
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
"the_geom" geometry (MULTIPOLYGON, SRID_VALUE)
)
WITH (OIDS=FALSE)

;


-- ----------------------------
-- View structure for v_inp_arc_x_node
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_arc_x_node" AS 
SELECT arc_id, node_1, node_2 FROM SCHEMA_NAME.arc;



-- ----------------------------
-- View structure for v_inp_buildup
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_buildup" AS 
SELECT inp_buildup_land_x_pol.landus_id, inp_buildup_land_x_pol.poll_id, inp_buildup_land_x_pol.funcb_type, inp_buildup_land_x_pol.c1, inp_buildup_land_x_pol.c2, inp_buildup_land_x_pol.c3, inp_buildup_land_x_pol.perunit FROM SCHEMA_NAME.inp_buildup_land_x_pol;

-- ----------------------------
-- View structure for v_inp_conduit_cu
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_conduit_cu" AS 
SELECT arc.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, (st_length2d(arc.the_geom))::numeric(16,3) AS length, arc.z1, arc.z2, cat_mat.n, inp_conduit.q0, inp_conduit.qmax, cat_arc.shape, cat_arc.geom1, cat_arc.curve_id, cat_arc.geom3, cat_arc.geom4, inp_conduit.barrels, inp_conduit.culvert, sector_selection.sector_id FROM (((((SCHEMA_NAME.arc JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))) JOIN SCHEMA_NAME.inp_conduit ON (((arc.arc_id)::text = (inp_conduit.arc_id)::text))) JOIN SCHEMA_NAME.cat_mat ON (((arc.matcat_id)::text = (cat_mat.id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text))) WHERE ((cat_arc.shape)::text = 'CUSTOM'::text);

-- ----------------------------
-- View structure for v_inp_conduit_no
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_conduit_no" AS 
SELECT arc.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, (st_length2d(arc.the_geom))::numeric(16,3) AS length, arc.z1, arc.z2, mat_cat.n, conduit.q0, conduit.qmax, arc_cat.shape, arc_cat.geom1, arc_cat.geom2, arc_cat.geom3, arc_cat.geom4, conduit.barrels, conduit.culvert, sector_selection.sector_id FROM ((((((SCHEMA_NAME.arc JOIN SCHEMA_NAME.cat_arc arc_cat ON ((((arc.arccat_id)::text = (arc_cat.id)::text) AND ((arc.arccat_id)::text = (arc_cat.id)::text)))) JOIN SCHEMA_NAME.inp_conduit conduit ON ((((arc.arc_id)::text = (conduit.arc_id)::text) AND ((arc.arc_id)::text = (conduit.arc_id)::text)))) JOIN SCHEMA_NAME.cat_mat mat_cat ON ((((arc.matcat_id)::text = (mat_cat.id)::text) AND ((arc.matcat_id)::text = (mat_cat.id)::text)))) JOIN SCHEMA_NAME.sector ON (((sector.sector_id)::text = (arc.sector_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((sector_selection.sector_id)::text = (sector.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text))) WHERE ((((arc_cat.shape)::text < 'CUSTOM'::text) OR (((arc_cat.shape)::text > 'CUSTOM'::text) AND ((arc_cat.shape)::text < 'IRREGULAR'::text))) OR ((arc_cat.shape)::text > 'IRREGULAR'::text));

-- ----------------------------
-- View structure for v_inp_conduit_xs
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_conduit_xs" AS 
SELECT arc.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, (st_length2d(arc.the_geom))::numeric(16,3) AS length, arc.z1, arc.z2, mat_cat.n, conduit.q0, conduit.qmax, cat_arc.shape, cat_arc.tsect_id, cat_arc.geom2, cat_arc.geom3, cat_arc.geom4, conduit.barrels, conduit.culvert, sector_selection.sector_id FROM ((((((SCHEMA_NAME.arc JOIN SCHEMA_NAME.cat_arc ON ((((arc.arccat_id)::text = (cat_arc.id)::text) AND ((arc.arccat_id)::text = (cat_arc.id)::text)))) JOIN SCHEMA_NAME.inp_conduit conduit ON ((((arc.arc_id)::text = (conduit.arc_id)::text) AND ((arc.arc_id)::text = (conduit.arc_id)::text)))) JOIN SCHEMA_NAME.cat_mat mat_cat ON ((((arc.matcat_id)::text = (mat_cat.id)::text) AND ((arc.matcat_id)::text = (mat_cat.id)::text)))) JOIN SCHEMA_NAME.sector ON (((sector.sector_id)::text = (arc.sector_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((sector_selection.sector_id)::text = (sector.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text))) WHERE ((cat_arc.shape)::text = 'IRREGULAR'::text);

-- ----------------------------
-- View structure for v_inp_controls
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_controls" AS 
SELECT inp_controls.id, inp_controls.text FROM SCHEMA_NAME.inp_controls ORDER BY inp_controls.id;

-- ----------------------------
-- View structure for v_inp_coverages
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_coverages" AS 
SELECT subcatchment.subc_id, inp_coverage_land_x_subc.landus_id, inp_coverage_land_x_subc.percent, sector_selection.sector_id FROM ((SCHEMA_NAME.inp_coverage_land_x_subc JOIN SCHEMA_NAME.subcatchment ON (((inp_coverage_land_x_subc.subc_id)::text = (subcatchment.subc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((subcatchment.sector_id)::text = (sector_selection.sector_id)::text)));

-- ----------------------------
-- View structure for v_inp_curve
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_curve" AS 
SELECT inp_curve.id, inp_curve.curve_id, inp_curve_id.curve_type, inp_curve.x_value, inp_curve.y_value FROM SCHEMA_NAME.inp_curve JOIN SCHEMA_NAME.inp_curve_id ON ((inp_curve_id. ID) :: TEXT = (inp_curve.curve_id) :: TEXT)ORDER BY inp_curve.id;

-- ----------------------------
-- View structure for v_inp_divider_cu
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_divider_cu" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_divider.arc_id, inp_divider.divider_type AS type_dicu, inp_divider.qmin, node.ymax, inp_divider.y0, inp_divider.ysur, inp_divider.apond, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_divider ON (((node.node_id)::text = (inp_divider.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) WHERE ((inp_divider.divider_type)::text = 'CUTOFF'::text);

-- ----------------------------
-- View structure for v_inp_divider_ov
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_divider_ov" AS 
SELECT node.node_id, inp_divider.arc_id, (node.top_elev - node.ymax) AS elev, inp_divider.divider_type AS type_diov, node.ymax, inp_divider.y0, inp_divider.ysur, inp_divider.apond, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_divider ON (((node.node_id)::text = (inp_divider.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) WHERE ((inp_divider.divider_type)::text = 'OVERFLOW'::text);

-- ----------------------------
-- View structure for v_inp_divider_tb
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_divider_tb" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_divider.arc_id, inp_divider.divider_type AS type_ditb, inp_divider.curve_id, node.ymax, inp_divider.y0, inp_divider.ysur, inp_divider.apond, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_divider ON (((node.node_id)::text = (inp_divider.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) WHERE ((inp_divider.divider_type)::text = 'TABULAR'::text);

-- ----------------------------
-- View structure for v_inp_divider_wr
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_divider_wr" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_divider.arc_id, inp_divider.divider_type AS type_diwr, inp_divider.qmin, inp_divider.ht, inp_divider.cd, node.ymax, inp_divider.y0, inp_divider.ysur, inp_divider.apond, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_divider ON (((node.node_id)::text = (inp_divider.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) WHERE ((inp_divider.divider_type)::text = 'WEIR'::text);

-- ----------------------------
-- View structure for v_inp_dwf_flow
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_dwf_flow" AS 
SELECT node.node_id, 'FLOW'::text AS type_dwf, inp_dwf.value, inp_dwf.pat1, inp_dwf.pat2, inp_dwf.pat3, inp_dwf.pat4, sector_selection.sector_id FROM ((SCHEMA_NAME.sector_selection JOIN SCHEMA_NAME.node ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_dwf ON (((inp_dwf.node_id)::text = (node.node_id)::text)));

-- ----------------------------
-- View structure for v_inp_dwf_load
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_dwf_load" AS 
SELECT inp_dwf_pol_x_node.poll_id, node.node_id, inp_dwf_pol_x_node.value, inp_dwf_pol_x_node.pat1, inp_dwf_pol_x_node.pat2, inp_dwf_pol_x_node.pat3, inp_dwf_pol_x_node.pat4, sector_selection.sector_id FROM ((SCHEMA_NAME.sector_selection JOIN SCHEMA_NAME.node ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_dwf_pol_x_node ON (((inp_dwf_pol_x_node.node_id)::text = (node.node_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_conduit
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_conduit" AS 
SELECT arc.arc_id, arc.z1, arc.z2, arc.arccat_id, arc.matcat_id, inp_conduit.barrels, inp_conduit.culvert, inp_conduit.kentry, inp_conduit.kexit, inp_conduit.kavg, inp_conduit.flap, inp_conduit.q0, inp_conduit.qmax, arc.sector_id, arc.the_geom FROM (SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_conduit ON (((arc.arc_id)::text = (inp_conduit.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_divider

-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_divider" AS 
SELECT node.node_id, node.top_elev, node.ymax, inp_divider.divider_type, inp_divider.arc_id, inp_divider.curve_id, inp_divider.qmin, inp_divider.ht, inp_divider.cd, inp_divider.y0, inp_divider.ysur, inp_divider.apond, node.sector_id, node.the_geom FROM (SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_divider ON (((node.node_id)::text = (inp_divider.node_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_junction
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_junction" AS 
SELECT node.node_id, node.top_elev, node.ymax, inp_junction.y0, inp_junction.ysur, inp_junction.apond, node.sector_id, node.the_geom FROM (SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_junction ON (((inp_junction.node_id)::text = (node.node_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_orifice
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_orifice" AS 
SELECT arc.arc_id, arc.z1, arc.z2, inp_orifice.ori_type, inp_orifice."offset", inp_orifice.cd, inp_orifice.orate, inp_orifice.flap, inp_orifice.shape, inp_orifice.geom1, inp_orifice.geom2, inp_orifice.geom3, inp_orifice.geom4, arc.sector_id, arc.the_geom FROM (SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_orifice ON (((arc.arc_id)::text = (inp_orifice.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_outfall
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_outfall" AS 
SELECT node.node_id, node.top_elev, node.ymax, inp_outfall.outfall_type, inp_outfall.stage, inp_outfall.curve_id, inp_outfall.timser_id, inp_outfall.gate, node.sector_id, node.the_geom FROM (SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_outfall ON (((node.node_id)::text = (inp_outfall.node_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_outlet
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_outlet" AS 
SELECT arc.arc_id, arc.z1, arc.z2, inp_outlet.outlet_type, inp_outlet."offset", inp_outlet.curve_id, inp_outlet.cd1, inp_outlet.cd2, inp_outlet.flap, arc.sector_id, arc.the_geom FROM (SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_outlet ON (((arc.arc_id)::text = (inp_outlet.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_pump
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_pump" AS 
SELECT arc.arc_id, arc.z1, arc.z2, inp_pump.curve_id, inp_pump.status, inp_pump.startup, inp_pump.shutoff, arc.sector_id, arc.the_geom FROM (SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_pump ON (((arc.arc_id)::text = (inp_pump.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_storage
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_storage" AS 
SELECT node.node_id, node.top_elev, node.ymax, inp_storage.storage_type, inp_storage.curve_id, inp_storage.a1, inp_storage.a2, inp_storage.a0, inp_storage.fevap, inp_storage.sh, inp_storage.hc, inp_storage.imd, inp_storage.y0, inp_storage.ysur, inp_storage.apond, node.sector_id, node.the_geom FROM (SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_storage ON (((node.node_id)::text = (inp_storage.node_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_weir
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_weir" AS 
SELECT arc.arc_id, arc.z1, arc.z2, inp_weir.weir_type, inp_weir."offset", inp_weir.cd, inp_weir.ec, inp_weir.cd2, inp_weir.flap, inp_weir.geom1, inp_weir.geom2, inp_weir.geom3, inp_weir.geom4, arc.sector_id, arc.the_geom FROM (SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_weir ON (((arc.arc_id)::text = (inp_weir.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_evap_co
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_evap_co" AS 
SELECT inp_evaporation.evap_type AS type_evco, inp_evaporation.evap FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.evap_type)::text = 'CONSTANT'::text);

-- ----------------------------
-- View structure for v_inp_evap_do
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_evap_do" AS 
SELECT 'DRY_ONLY'::text AS type_evdo, inp_evaporation.dry_only FROM SCHEMA_NAME.inp_evaporation;

-- ----------------------------
-- View structure for v_inp_evap_fl
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_evap_fl" AS 
SELECT inp_evaporation.evap_type AS type_evfl, inp_evaporation.pan_1, inp_evaporation.pan_2, inp_evaporation.pan_3, inp_evaporation.pan_4, inp_evaporation.pan_5, inp_evaporation.pan_6, inp_evaporation.pan_7, inp_evaporation.pan_8, inp_evaporation.pan_9, inp_evaporation.pan_10, inp_evaporation.pan_11, inp_evaporation.pan_12 FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.evap_type)::text = 'FILE'::text);

-- ----------------------------
-- View structure for v_inp_evap_mo
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_evap_mo" AS 
SELECT inp_evaporation.evap_type AS type_evmo, inp_evaporation.value_1, inp_evaporation.value_2, inp_evaporation.value_3, inp_evaporation.value_4, inp_evaporation.value_5, inp_evaporation.value_6, inp_evaporation.value_7, inp_evaporation.value_8, inp_evaporation.value_9, inp_evaporation.value_10, inp_evaporation.value_11, inp_evaporation.value_12 FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.evap_type)::text = 'MONTHLY'::text);

-- ----------------------------
-- View structure for v_inp_evap_pa
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_evap_pa" AS 
SELECT 'RECOVERY'::text AS type_evpa, inp_evaporation.recovery FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.recovery)::text > '0'::text);

-- ----------------------------
-- View structure for v_inp_evap_te
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_evap_te" AS 
SELECT inp_evaporation.evap_type AS type_evte FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.evap_type)::text = 'TEMPERATURE'::text);

-- ----------------------------
-- View structure for v_inp_evap_ts
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_evap_ts" AS 
SELECT inp_evaporation.evap_type AS type_evts, inp_evaporation.timser_id FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.evap_type)::text = 'TIMESERIES'::text);

-- ----------------------------
-- View structure for v_inp_groundwater
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_groundwater" AS 
SELECT inp_groundwater.subc_id, inp_groundwater.aquif_id, inp_groundwater.node_id, inp_groundwater.surfel, inp_groundwater.a1, inp_groundwater.b1, inp_groundwater.a2, inp_groundwater.b2, inp_groundwater.a3, inp_groundwater.tw, inp_groundwater.h, sector_selection.sector_id FROM ((SCHEMA_NAME.subcatchment JOIN SCHEMA_NAME.inp_groundwater ON (((inp_groundwater.subc_id)::text = (subcatchment.subc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((subcatchment.sector_id)::text = (sector_selection.sector_id)::text)));

-- ----------------------------
-- View structure for v_inp_hydrograph
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_hydrograph" AS 
SELECT inp_hydrograph.id, inp_hydrograph.text FROM SCHEMA_NAME.inp_hydrograph ORDER BY inp_hydrograph.id;

-- ----------------------------
-- View structure for v_inp_infiltration_cu
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_infiltration_cu" AS 
SELECT subcatchment.subc_id, subcatchment.curveno, subcatchment.conduct_2, subcatchment.drytime_2, sector_selection.sector_id, inp_options.infiltration FROM (SCHEMA_NAME.subcatchment JOIN SCHEMA_NAME.sector_selection ON (((subcatchment.sector_id)::text = (sector_selection.sector_id)::text))), SCHEMA_NAME.inp_options WHERE ((inp_options.infiltration)::text = 'CURVE_NUMBER'::text);

-- ----------------------------
-- View structure for v_inp_infiltration_gr
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_infiltration_gr" AS 
SELECT subcatchment.subc_id, subcatchment.suction, subcatchment.conduct, subcatchment.initdef, sector_selection.sector_id, inp_options.infiltration FROM (SCHEMA_NAME.subcatchment JOIN SCHEMA_NAME.sector_selection ON (((subcatchment.sector_id)::text = (sector_selection.sector_id)::text))), SCHEMA_NAME.inp_options WHERE ((inp_options.infiltration)::text = 'GREEN_APT'::text);

-- ----------------------------
-- View structure for v_inp_infiltration_ho
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_infiltration_ho" AS 
SELECT subcatchment.subc_id, subcatchment.maxrate, subcatchment.minrate, subcatchment.decay, subcatchment.drytime, subcatchment.maxinfil, sector_selection.sector_id, inp_options.infiltration FROM (SCHEMA_NAME.subcatchment JOIN SCHEMA_NAME.sector_selection ON (((subcatchment.sector_id)::text = (sector_selection.sector_id)::text))), SCHEMA_NAME.inp_options WHERE ((inp_options.infiltration)::text = 'HORTON'::text);

-- ----------------------------
-- View structure for v_inp_inflows_flow
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_inflows_flow" AS 
SELECT inp_inflows.node_id, 'FLOW'::text AS type_flow1, inp_inflows.timser_id, 'FLOW'::text AS type_flow2, '1'::text AS type_n1, inp_inflows.sfactor, inp_inflows.base, inp_inflows.pattern_id, sector_selection.sector_id FROM ((SCHEMA_NAME.sector_selection JOIN SCHEMA_NAME.node ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_inflows ON (((inp_inflows.node_id)::text = (node.node_id)::text)));

-- ----------------------------
-- View structure for v_inp_inflows_load
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_inflows_load" AS 
SELECT inp_inflows_pol_x_node.poll_id, node.node_id, inp_inflows_pol_x_node.timser_id, inp_inflows_pol_x_node.form_type, inp_inflows_pol_x_node.mfactor, inp_inflows_pol_x_node.sfactor, inp_inflows_pol_x_node.base, inp_inflows_pol_x_node.pattern_id, sector_selection.sector_id FROM ((SCHEMA_NAME.sector_selection JOIN SCHEMA_NAME.node ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_inflows_pol_x_node ON (((inp_inflows_pol_x_node.node_id)::text = (node.node_id)::text)));

-- ----------------------------
-- View structure for v_inp_junction
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_junction" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, node.ymax, inp_junction.y0, inp_junction.ysur, inp_junction.apond, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.inp_junction JOIN SCHEMA_NAME.node ON (((inp_junction.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)));

-- ----------------------------
-- View structure for v_inp_landuses
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_landuses" AS 
SELECT inp_landuses.landus_id, inp_landuses.sweepint, inp_landuses.availab, inp_landuses.lastsweep FROM SCHEMA_NAME.inp_landuses;

-- ----------------------------
-- View structure for v_inp_lidcontrol
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_lidcontrol" AS 
SELECT inp_lid_control.lidco_id, inp_lid_control.lidco_type, inp_lid_control.value_2, inp_lid_control.value_3, inp_lid_control.value_4, inp_lid_control.value_5, inp_lid_control.value_6, inp_lid_control.value_7, inp_lid_control.value_8 FROM SCHEMA_NAME.inp_lid_control ORDER BY inp_lid_control.id;

-- ----------------------------
-- View structure for v_inp_lidusage
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_lidusage" AS 
SELECT inp_lidusage_subc_x_lidco.subc_id, inp_lidusage_subc_x_lidco.lidco_id, inp_lidusage_subc_x_lidco.number, inp_lidusage_subc_x_lidco.area, inp_lidusage_subc_x_lidco.width, inp_lidusage_subc_x_lidco.initsat, inp_lidusage_subc_x_lidco.fromimp, inp_lidusage_subc_x_lidco.toperv, inp_lidusage_subc_x_lidco.rptfile, sector_selection.sector_id FROM ((SCHEMA_NAME.sector_selection JOIN SCHEMA_NAME.subcatchment ON (((subcatchment.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_lidusage_subc_x_lidco ON (((inp_lidusage_subc_x_lidco.subc_id)::text = (subcatchment.subc_id)::text)));

-- ----------------------------
-- View structure for v_inp_loadings
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_loadings" AS 
SELECT inp_loadings_pol_x_subc.poll_id, inp_loadings_pol_x_subc.subc_id, inp_loadings_pol_x_subc.ibuildup, sector_selection.sector_id FROM ((SCHEMA_NAME.sector_selection JOIN SCHEMA_NAME.subcatchment ON (((subcatchment.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_loadings_pol_x_subc ON (((inp_loadings_pol_x_subc.subc_id)::text = (subcatchment.subc_id)::text)));

-- ----------------------------
-- View structure for v_inp_losses
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_losses" AS 
SELECT inp_conduit.arc_id, inp_conduit.kentry, inp_conduit.kexit, inp_conduit.kavg, inp_conduit.flap, sector_selection.sector_id FROM ((SCHEMA_NAME.inp_conduit JOIN SCHEMA_NAME.arc ON (((inp_conduit.arc_id)::text = (arc.arc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) WHERE ((((inp_conduit.kentry > (0)::numeric) OR (inp_conduit.kexit > (0)::numeric)) OR (inp_conduit.kavg > (0)::numeric)) OR ((inp_conduit.flap)::text = 'YES'::text));

-- ----------------------------
-- View structure for v_inp_options
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_options" AS 
SELECT inp_options.flow_units, inp_options.infiltration, inp_options.flow_routing, inp_options.link_offsets, inp_options.force_main_equation, inp_options.ignore_rainfall, inp_options.ignore_snowmelt, inp_options.ignore_groundwater, inp_options.ignore_routing, inp_options.ignore_quality, inp_options.skip_steady_state, inp_options.start_date, inp_options.start_time, inp_options.end_date, inp_options.end_time, inp_options.report_start_date, inp_options.report_start_time, inp_options.sweep_start, inp_options.sweep_end, inp_options.dry_days, inp_options.report_step, inp_options.wet_step, inp_options.dry_step, inp_options.routing_step, inp_options.lengthening_step, inp_options.variable_step, inp_options.inertial_damping, inp_options.normal_flow_limited, inp_options.min_surfarea, inp_options.min_slope, inp_options.allow_ponding, inp_options.tempdir FROM SCHEMA_NAME.inp_options;

-- ----------------------------
-- View structure for v_inp_orifice
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_orifice" AS 
SELECT inp_orifice.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, inp_orifice.ori_type, inp_orifice."offset", inp_orifice.cd, inp_orifice.flap, inp_orifice.orate, inp_orifice.shape, inp_orifice.geom1, inp_orifice.geom2, inp_orifice.geom3, inp_orifice.geom4, sector_selection.sector_id FROM (((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_orifice ON (((inp_orifice.arc_id)::text = (arc.arc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_outfall_fi
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_outfall_fi" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_outfall.outfall_type AS type_otlfi, inp_outfall.stage, inp_outfall.gate, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_outfall ON (((inp_outfall.node_id)::text = (node.node_id)::text))) WHERE ((inp_outfall.outfall_type)::text = 'FIXED'::text);

-- ----------------------------
-- View structure for v_inp_outfall_fr
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_outfall_fr" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_outfall.outfall_type AS type_otlfr, inp_outfall.gate, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_outfall ON (((node.node_id)::text = (inp_outfall.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) WHERE ((inp_outfall.outfall_type)::text = 'FREE'::text);

-- ----------------------------
-- View structure for v_inp_outfall_nm
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_outfall_nm" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_outfall.outfall_type AS type_otlnm, inp_outfall.gate, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_outfall ON (((node.node_id)::text = (inp_outfall.node_id)::text))) WHERE ((inp_outfall.outfall_type)::text = 'NORMAL'::text);

-- ----------------------------
-- View structure for v_inp_outfall_ti
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_outfall_ti" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_outfall.outfall_type AS type_otlti, inp_outfall.curve_id, inp_outfall.gate, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_outfall ON (((node.node_id)::text = (inp_outfall.node_id)::text))) WHERE ((inp_outfall.outfall_type)::text = 'TIDAL'::text);

-- ----------------------------
-- View structure for v_inp_outfall_ts
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_outfall_ts" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_outfall.outfall_type AS type_otlts, inp_outfall.timser_id, inp_outfall.gate, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_outfall ON (((node.node_id)::text = (inp_outfall.node_id)::text))) WHERE ((inp_outfall.outfall_type)::text = 'TIMESERIES'::text);

-- ----------------------------
-- View structure for v_inp_outlet_fcd
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_outlet_fcd" AS 
SELECT arc.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, inp_outlet.outlet_type AS type_oufcd, inp_outlet."offset", inp_outlet.cd1, inp_outlet.cd2, inp_outlet.flap, sector_selection.sector_id FROM (((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_outlet ON ((((arc.arc_id)::text = (inp_outlet.arc_id)::text) AND ((arc.arc_id)::text = (inp_outlet.arc_id)::text)))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text))) WHERE ((inp_outlet.outlet_type)::text = 'FUNCTIONAL/DEPTH'::text);

-- ----------------------------
-- View structure for v_inp_outlet_fch
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_outlet_fch" AS 
SELECT arc.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, inp_outlet.outlet_type AS type_oufch, inp_outlet."offset", inp_outlet.cd1, inp_outlet.cd2, inp_outlet.flap, sector_selection.sector_id FROM (((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_outlet ON (((arc.arc_id)::text = (inp_outlet.arc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text))) WHERE ((inp_outlet.outlet_type)::text = 'FUNCTIONAL/HEAD'::text);

-- ----------------------------
-- View structure for v_inp_outlet_tbd
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_outlet_tbd" AS 
SELECT arc.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, inp_outlet.outlet_type AS type_outbd, inp_outlet."offset", inp_outlet.curve_id, inp_outlet.flap, sector_selection.sector_id FROM (((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_outlet ON (((arc.arc_id)::text = (inp_outlet.arc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text))) WHERE ((inp_outlet.outlet_type)::text = 'TABULAR/DEPTH'::text);

-- ----------------------------
-- View structure for v_inp_outlet_tbh
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_outlet_tbh" AS 
SELECT arc.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, inp_outlet.outlet_type AS type_outbh, inp_outlet."offset", inp_outlet.curve_id, inp_outlet.flap, sector_selection.sector_id FROM (((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_outlet ON (((arc.arc_id)::text = (inp_outlet.arc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text))) WHERE ((inp_outlet.outlet_type)::text = 'TABULAR/HEAD'::text);

-- ----------------------------
-- View structure for v_inp_pattern_dl
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_pattern_dl" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_padl, inp_pattern.factor_1, inp_pattern.factor_2, inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7 FROM SCHEMA_NAME.inp_pattern WHERE ((inp_pattern.pattern_type)::text = 'DAILY'::text);

-- ----------------------------
-- View structure for v_inp_pattern_ho
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_pattern_ho" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_paho, inp_pattern.factor_1, inp_pattern.factor_2, inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7, inp_pattern.factor_8, inp_pattern.factor_9, inp_pattern.factor_10, inp_pattern.factor_11, inp_pattern.factor_12, inp_pattern.factor_13, inp_pattern.factor_14, inp_pattern.factor_15, inp_pattern.factor_16, inp_pattern.factor_17, inp_pattern.factor_18, inp_pattern.factor_19, inp_pattern.factor_20, inp_pattern.factor_21, inp_pattern.factor_22, inp_pattern.factor_23, inp_pattern.factor_24 FROM SCHEMA_NAME.inp_pattern WHERE ((inp_pattern.pattern_type)::text = 'HOURLY'::text);

-- ----------------------------
-- View structure for v_inp_pattern_mo
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_pattern_mo" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_pamo, inp_pattern.factor_1, inp_pattern.factor_2, inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7, inp_pattern.factor_8, inp_pattern.factor_9, inp_pattern.factor_10, inp_pattern.factor_11, inp_pattern.factor_12 FROM SCHEMA_NAME.inp_pattern WHERE ((inp_pattern.pattern_type)::text = 'MONTHLY'::text);

-- ----------------------------
-- View structure for v_inp_pattern_we
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_pattern_we" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_pawe, inp_pattern.factor_1, inp_pattern.factor_2, inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7, inp_pattern.factor_8, inp_pattern.factor_9, inp_pattern.factor_10, inp_pattern.factor_11, inp_pattern.factor_12, inp_pattern.factor_13, inp_pattern.factor_14, inp_pattern.factor_15, inp_pattern.factor_16, inp_pattern.factor_17, inp_pattern.factor_18, inp_pattern.factor_19, inp_pattern.factor_20, inp_pattern.factor_21, inp_pattern.factor_22, inp_pattern.factor_23, inp_pattern.factor_24 FROM SCHEMA_NAME.inp_pattern WHERE ((inp_pattern.pattern_type)::text = 'WEEKEND'::text);

-- ----------------------------
-- View structure for v_inp_pump
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_pump" AS 
SELECT arc.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, inp_pump.curve_id, inp_pump.status, inp_pump.startup, inp_pump.shutoff, sector_selection.sector_id FROM (((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_pump ON (((arc.arc_id)::text = (inp_pump.arc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_rdii
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_rdii" AS 
SELECT node.node_id, inp_rdii.hydro_id, inp_rdii.sewerarea, sector_selection.sector_id FROM ((SCHEMA_NAME.sector_selection JOIN SCHEMA_NAME.node ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_rdii ON (((inp_rdii.node_id)::text = (node.node_id)::text)));

-- ----------------------------
-- View structure for v_inp_rgage_fl
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_rgage_fl" AS 
SELECT raingage.rg_id, raingage.form_type, raingage.intvl, raingage.scf, raingage.rgage_type AS type_rgfl, raingage.fname, raingage.sta, raingage.units, (st_x(raingage.the_geom))::numeric(16,3) AS xcoord, (st_y(raingage.the_geom))::numeric(16,3) AS ycoord FROM SCHEMA_NAME.raingage WHERE ((raingage.rgage_type)::text = 'FILE'::text);

-- ----------------------------
-- View structure for v_inp_rgage_ts
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_rgage_ts" AS 
SELECT raingage.rg_id, raingage.form_type, raingage.intvl, raingage.scf, raingage.rgage_type AS type_rgts, raingage.timser_id, (st_x(raingage.the_geom))::numeric(16,3) AS xcoord, (st_y(raingage.the_geom))::numeric(16,3) AS ycoord FROM SCHEMA_NAME.raingage WHERE ((raingage.rgage_type)::text = 'TIMESERIES'::text);

-- ----------------------------
-- View structure for v_inp_snowpack
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_snowpack" AS 
SELECT inp_snowpack.snow_id, 'PLOWABLE'::text AS type_snpk1, inp_snowpack.cmin_1, inp_snowpack.cmax_1, inp_snowpack.tbase_1, inp_snowpack.fwf_1, inp_snowpack.sd0_1, inp_snowpack.fw0_1, inp_snowpack.snn0_1, 'IMPERVIOUS'::text AS type_snpk2, inp_snowpack.cmin_2, inp_snowpack.cmax_2, inp_snowpack.tbase_2, inp_snowpack.fwf_2, inp_snowpack.sd0_2, inp_snowpack.fw0_2, inp_snowpack.sd100_1, 'PERVIOUS'::text AS type_snpk3, inp_snowpack.cmin_3, inp_snowpack.cmax_3, inp_snowpack.tbase_3, inp_snowpack.fwf_3, inp_snowpack.sd0_3, inp_snowpack.fw0_3, inp_snowpack.sd100_2, 'REMOVAL'::text AS type_snpk4, inp_snowpack.sdplow, inp_snowpack.fout, inp_snowpack.fimp, inp_snowpack.fperv, inp_snowpack.fimelt, inp_snowpack.fsub, inp_snowpack.subc_id FROM SCHEMA_NAME.inp_snowpack;

-- ----------------------------
-- View structure for v_inp_storage_fc
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_storage_fc" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, node.ymax, inp_storage.y0, inp_storage.storage_type AS type_stfc, inp_storage.a1, inp_storage.a2, inp_storage.a0, inp_storage.apond, inp_storage.fevap, inp_storage.sh, inp_storage.hc, inp_storage.imd, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_storage ON (((node.node_id)::text = (inp_storage.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) WHERE ((inp_storage.storage_type)::text = 'FUNCTIONAL'::text);

-- ----------------------------
-- View structure for v_inp_storage_tb
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_storage_tb" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, node.ymax, inp_storage.y0, inp_storage.storage_type AS type_sttb, inp_storage.curve_id, inp_storage.apond, inp_storage.fevap, inp_storage.sh, inp_storage.hc, inp_storage.imd, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_storage ON (((node.node_id)::text = (inp_storage.node_id)::text))) WHERE ((inp_storage.storage_type)::text = 'TABULAR'::text);

-- ----------------------------
-- View structure for v_inp_subcatch
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_subcatch" AS 
SELECT subcatchment.subc_id, subcatchment.node_id, subcatchment.rg_id, subcatchment.area, subcatchment.imperv, subcatchment.width, subcatchment.slope, subcatchment.clength, subcatchment.snow_id, subcatchment.nimp, subcatchment.nperv, subcatchment.simp, subcatchment.sperv, subcatchment.zero, subcatchment.routeto, subcatchment.rted, sector_selection.sector_id FROM (SCHEMA_NAME.subcatchment JOIN SCHEMA_NAME.sector_selection ON (((subcatchment.sector_id)::text = (sector_selection.sector_id)::text)));

-- ----------------------------
-- View structure for v_inp_temp_fl
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_temp_fl" AS 
SELECT inp_temperature.temp_type AS type_tefl, inp_temperature.fname, inp_temperature.start FROM SCHEMA_NAME.inp_temperature WHERE ((inp_temperature.temp_type)::text = 'FILE'::text);

-- ----------------------------
-- View structure for v_inp_temp_sn
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_temp_sn" AS 
SELECT 'SNOWMELT'::text AS type_tesn, inp_snowmelt.stemp, inp_snowmelt.atiwt, inp_snowmelt.rnm, inp_snowmelt.elev, inp_snowmelt.lat, inp_snowmelt.dtlong, 'ADC IMPERVIOUS'::text AS type_teai, inp_snowmelt.i_f0, inp_snowmelt.i_f1, inp_snowmelt.i_f2, inp_snowmelt.i_f3, inp_snowmelt.i_f4, inp_snowmelt.i_f5, inp_snowmelt.i_f6, inp_snowmelt.i_f7, inp_snowmelt.i_f8, inp_snowmelt.i_f9, 'ADC PERVIOUS'::text AS type_teap, inp_snowmelt.p_f0, inp_snowmelt.p_f1, inp_snowmelt.p_f2, inp_snowmelt.p_f3, inp_snowmelt.p_f4, inp_snowmelt.p_f5, inp_snowmelt.p_f6, inp_snowmelt.p_f7, inp_snowmelt.p_f8, inp_snowmelt.p_f9 FROM SCHEMA_NAME.inp_snowmelt;

-- ----------------------------
-- View structure for v_inp_temp_ts
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_temp_ts" AS 
SELECT inp_temperature.temp_type AS type_tets, inp_temperature.timser_id FROM SCHEMA_NAME.inp_temperature WHERE ((inp_temperature.temp_type)::text = 'TIMESERIES'::text);

-- ----------------------------
-- View structure for v_inp_temp_wf
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_temp_wf" AS 
SELECT 'WINDSPEED'::text AS type_tews, inp_windspeed.wind_type AS type_tefl, inp_windspeed.fname FROM SCHEMA_NAME.inp_windspeed WHERE ((inp_windspeed.wind_type)::text = 'FILE'::text);

-- ----------------------------
-- View structure for v_inp_temp_wm
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_temp_wm" AS 
SELECT 'WINDSPEED'::text AS type_tews, inp_windspeed.wind_type AS type_temo, inp_windspeed.value_1, inp_windspeed.value_2, inp_windspeed.value_3, inp_windspeed.value_4, inp_windspeed.value_5, inp_windspeed.value_6, inp_windspeed.value_7, inp_windspeed.value_8, inp_windspeed.value_9, inp_windspeed.value_10, inp_windspeed.value_11, inp_windspeed.value_12 FROM SCHEMA_NAME.inp_windspeed WHERE ((inp_windspeed.wind_type)::text = 'MONTHLY'::text);

-- ----------------------------
-- View structure for v_inp_timser_abs
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_timser_abs" AS 
SELECT inp_timeseries.timser_id, inp_timeseries.date, inp_timeseries.hour, inp_timeseries.value FROM (SCHEMA_NAME.inp_timeseries JOIN SCHEMA_NAME.inp_timser_id ON (((inp_timeseries.timser_id)::text = (inp_timser_id.id)::text))) WHERE ((inp_timser_id.times_type)::text = 'ABSOLUTE'::text) ORDER BY inp_timeseries.id;

-- ----------------------------
-- View structure for v_inp_timser_fl
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_timser_fl" AS 
SELECT inp_timeseries.timser_id, 'FILE'::text AS type_times, inp_timeseries.fname FROM (SCHEMA_NAME.inp_timeseries JOIN SCHEMA_NAME.inp_timser_id ON (((inp_timeseries.timser_id)::text = (inp_timser_id.id)::text))) WHERE ((inp_timser_id.times_type)::text = 'FILE'::text);

-- ----------------------------
-- View structure for v_inp_timser_rel
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_timser_rel" AS 
SELECT inp_timeseries.timser_id, inp_timeseries."time", inp_timeseries.value FROM (SCHEMA_NAME.inp_timeseries JOIN SCHEMA_NAME.inp_timser_id ON (((inp_timeseries.timser_id)::text = (inp_timser_id.id)::text))) WHERE ((inp_timser_id.times_type)::text = 'RELATIVE'::text) ORDER BY inp_timeseries.id;

-- ----------------------------
-- View structure for v_inp_transects
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_transects" AS 
SELECT inp_transects.id, inp_transects.text FROM SCHEMA_NAME.inp_transects ORDER BY inp_transects.id;

-- ----------------------------
-- View structure for v_inp_treatment
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_treatment" AS 
SELECT node.node_id, inp_treatment_node_x_pol.poll_id, inp_treatment_node_x_pol.function, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_treatment_node_x_pol ON (((inp_treatment_node_x_pol.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)));

-- ----------------------------
-- View structure for v_inp_vertice
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_vertice" AS 
SELECT nextval('"SCHEMA_NAME".inp_vertice_id_seq' :: regclass) AS "id",arc.arc_id, st_x (point) :: NUMERIC (16, 3) AS xcoord,st_y (point) ::NUMERIC (16, 3) AS ycoord FROM((SELECT geom (st_dumppoints(arc.the_geom)) AS point,(st_startpoint(arc.the_geom)) AS startpoint,
(st_endpoint(arc.the_geom)) AS endpoint, sector_id, arc_id  FROM SCHEMA_NAME.arc) arc JOIN SCHEMA_NAME.sector_selection ON (		((arc.sector_id) :: TEXT = (sector_selection.sector_id) :: TEXT))) WHERE ((point < startpoint OR point > startpoint)AND (point < endpoint OR point > endpoint))ORDER BY id;

-- ----------------------------
-- View structure for v_inp_washoff
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_washoff" AS 
SELECT inp_washoff_land_x_pol.landus_id, inp_washoff_land_x_pol.poll_id, inp_washoff_land_x_pol.funcw_type, inp_washoff_land_x_pol.c1, inp_washoff_land_x_pol.c2, inp_washoff_land_x_pol.sweepeffic, inp_washoff_land_x_pol.bmpeffic FROM SCHEMA_NAME.inp_washoff_land_x_pol;

-- ----------------------------
-- View structure for v_inp_weir
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_weir" AS 
SELECT arc.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, inp_weir.weir_type, inp_weir."offset", inp_weir.cd, inp_weir.flap, inp_weir.ec, inp_weir.cd2, inp_value_weirs.shape, inp_weir.geom1, inp_weir.geom2, inp_weir.geom3, inp_weir.geom4, sector_selection.sector_id FROM ((((SCHEMA_NAME.arc JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.inp_weir ON (((inp_weir.arc_id)::text = (arc.arc_id)::text))) JOIN SCHEMA_NAME.inp_value_weirs ON (((inp_weir.weir_type)::text = (inp_value_weirs.id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text)));


-- ----------------------------
-- View structure for v_rpt_arcflow_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_arcflow_sum" AS 
SELECT rpt_arcflow_sum.id, result_selection.result_id, rpt_arcflow_sum.arc_id, rpt_arcflow_sum.arc_type, rpt_arcflow_sum.max_flow, rpt_arcflow_sum.time_days, rpt_arcflow_sum.time_hour, rpt_arcflow_sum.max_veloc, rpt_arcflow_sum.mfull_flow, rpt_arcflow_sum.mfull_dept, arc.sector_id, arc.the_geom FROM ((SCHEMA_NAME.arc JOIN SCHEMA_NAME.rpt_arcflow_sum ON ((((rpt_arcflow_sum.arc_id)::text = (arc.arc_id)::text) AND ((arc.arc_id)::text = (rpt_arcflow_sum.arc_id)::text)))) JOIN SCHEMA_NAME.result_selection ON (((rpt_arcflow_sum.result_id)::text = (result_selection.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_condsurcharge_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_condsurcharge_sum" AS 
SELECT rpt_condsurcharge_sum.id, rpt_condsurcharge_sum.result_id, rpt_condsurcharge_sum.arc_id, rpt_condsurcharge_sum.both_ends, rpt_condsurcharge_sum.upstream, rpt_condsurcharge_sum.dnstream, rpt_condsurcharge_sum.hour_nflow, rpt_condsurcharge_sum.hour_limit, arc.sector_id, arc.the_geom FROM ((SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_condsurcharge_sum ON ((((result_selection.result_id)::text = (rpt_condsurcharge_sum.result_id)::text) AND ((result_selection.result_id)::text = (rpt_condsurcharge_sum.result_id)::text)))) JOIN SCHEMA_NAME.arc ON (((arc.arc_id)::text = (rpt_condsurcharge_sum.arc_id)::text)));

-- ----------------------------
-- View structure for v_rpt_continuity_errors
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_continuity_errors" AS 
SELECT rpt_continuity_errors.id, rpt_continuity_errors.result_id, rpt_continuity_errors.text FROM (SCHEMA_NAME.rpt_continuity_errors JOIN SCHEMA_NAME.result_selection ON (((rpt_continuity_errors.result_id)::text = (result_selection.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_critical_elements
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_critical_elements" AS 
SELECT rpt_critical_elements.id, rpt_critical_elements.result_id, rpt_critical_elements.text FROM (SCHEMA_NAME.rpt_critical_elements JOIN SCHEMA_NAME.result_selection ON (((rpt_critical_elements.result_id)::text = (result_selection.result_id)::text)));


-- ----------------------------
-- View structure for v_rpt_flowclass_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_flowclass_sum" AS 
SELECT rpt_flowclass_sum.id, rpt_flowclass_sum.result_id, rpt_flowclass_sum.arc_id, rpt_flowclass_sum.length, rpt_flowclass_sum.dry, rpt_flowclass_sum.up_dry, rpt_flowclass_sum.down_dry, rpt_flowclass_sum.sub_crit, rpt_flowclass_sum.sub_crit_1, rpt_flowclass_sum.up_crit, arc.sector_id, arc.the_geom FROM ((SCHEMA_NAME.arc JOIN SCHEMA_NAME.rpt_flowclass_sum ON (((rpt_flowclass_sum.arc_id)::text = (arc.arc_id)::text))) JOIN SCHEMA_NAME.result_selection ON (((rpt_flowclass_sum.result_id)::text = (result_selection.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_flowrouting_cont
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_flowrouting_cont" AS 
SELECT rpt_flowrouting_cont.id, rpt_flowrouting_cont.result_id, rpt_flowrouting_cont.dryw_inf, rpt_flowrouting_cont.wetw_inf, rpt_flowrouting_cont.ground_inf, rpt_flowrouting_cont.rdii_inf, rpt_flowrouting_cont.ext_inf, rpt_flowrouting_cont.ext_out, rpt_flowrouting_cont.int_out, rpt_flowrouting_cont.stor_loss, rpt_flowrouting_cont.initst_vol, rpt_flowrouting_cont.finst_vol, rpt_flowrouting_cont.cont_error FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_flowrouting_cont ON (((result_selection.result_id)::text = (rpt_flowrouting_cont.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_groundwater_cont
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_groundwater_cont" AS 
SELECT rpt_groundwater_cont.id, rpt_groundwater_cont.result_id, rpt_groundwater_cont.init_stor, rpt_groundwater_cont.infilt, rpt_groundwater_cont.upzone_et, rpt_groundwater_cont.lowzone_et, rpt_groundwater_cont.deep_perc, rpt_groundwater_cont.groundw_fl, rpt_groundwater_cont.final_stor, rpt_groundwater_cont.cont_error FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_groundwater_cont ON (((result_selection.result_id)::text = (rpt_groundwater_cont.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_high_cont_errors
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_high_cont_errors" AS 
SELECT rpt_continuity_errors.id, rpt_continuity_errors.result_id, rpt_continuity_errors.text FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_continuity_errors ON (((result_selection.result_id)::text = (rpt_continuity_errors.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_high_flowinest_ind
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_high_flowinest_ind" AS 
SELECT rpt_high_flowinest_ind.id, rpt_high_flowinest_ind.result_id, rpt_high_flowinest_ind.text FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_high_flowinest_ind ON (((result_selection.result_id)::text = (rpt_high_flowinest_ind.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_instability_index
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_instability_index" AS 
SELECT rpt_instability_index.id, rpt_instability_index.result_id, rpt_instability_index.text FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_instability_index ON (((result_selection.result_id)::text = (rpt_instability_index.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_lidperfomance_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_lidperfomance_sum" AS 
SELECT rpt_lidperformance_sum.id, rpt_lidperformance_sum.result_id, rpt_lidperformance_sum.subc_id, rpt_lidperformance_sum.lidco_id, rpt_lidperformance_sum.tot_inflow, rpt_lidperformance_sum.evap_loss, rpt_lidperformance_sum.infil_loss, rpt_lidperformance_sum.surf_outf, rpt_lidperformance_sum.drain_outf, rpt_lidperformance_sum.init_stor, rpt_lidperformance_sum.final_stor, rpt_lidperformance_sum.per_error, subcatchment.sector_id, subcatchment.the_geom FROM ((SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_lidperformance_sum ON (((result_selection.result_id)::text = (rpt_lidperformance_sum.result_id)::text))) JOIN SCHEMA_NAME.subcatchment ON (((rpt_lidperformance_sum.subc_id)::text = (subcatchment.subc_id)::text)));

-- ----------------------------
-- View structure for v_rpt_nodedepth_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_nodedepth_sum" AS 
SELECT rpt_nodedepth_sum.id, rpt_nodedepth_sum.result_id, rpt_nodedepth_sum.node_id, rpt_nodedepth_sum.swnod_type, rpt_nodedepth_sum.aver_depth, rpt_nodedepth_sum.max_depth, rpt_nodedepth_sum.max_hgl, rpt_nodedepth_sum.time_days, rpt_nodedepth_sum.time_hour, node.sector_id, node.the_geom FROM ((SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_nodedepth_sum ON ((((rpt_nodedepth_sum.result_id)::text = (result_selection.result_id)::text) AND ((result_selection.result_id)::text = (rpt_nodedepth_sum.result_id)::text)))) JOIN SCHEMA_NAME.node ON (((rpt_nodedepth_sum.node_id)::text = (node.node_id)::text)));

-- ----------------------------
-- View structure for v_rpt_nodeflooding_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_nodeflooding_sum" AS 
SELECT rpt_nodeflooding_sum.id, result_selection.result_id, rpt_nodeflooding_sum.node_id, rpt_nodeflooding_sum.hour_flood, rpt_nodeflooding_sum.max_rate, rpt_nodeflooding_sum.time_days, rpt_nodeflooding_sum.time_hour, rpt_nodeflooding_sum.tot_flood, rpt_nodeflooding_sum.max_ponded, node.sector_id, node.the_geom FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.rpt_nodeflooding_sum ON (((rpt_nodeflooding_sum.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.result_selection ON (((rpt_nodeflooding_sum.result_id)::text = (result_selection.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_nodeinflow_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_nodeinflow_sum" AS 
SELECT rpt_nodeinflow_sum.id, rpt_nodeinflow_sum.result_id, rpt_nodeinflow_sum.node_id, rpt_nodeinflow_sum.swnod_type, rpt_nodeinflow_sum.max_latinf, rpt_nodeinflow_sum.max_totinf, rpt_nodeinflow_sum.time_days, rpt_nodeinflow_sum.time_hour, rpt_nodeinflow_sum.latinf_vol, rpt_nodeinflow_sum.totinf_vol, node.sector_id, node.the_geom FROM ((SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_nodeinflow_sum ON (((result_selection.result_id)::text = (rpt_nodeinflow_sum.result_id)::text))) JOIN SCHEMA_NAME.node ON (((rpt_nodeinflow_sum.node_id)::text = (node.node_id)::text)));

-- ----------------------------
-- View structure for v_rpt_nodesurcharge_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_nodesurcharge_sum" AS 
SELECT rpt_nodesurcharge_sum.id, rpt_nodesurcharge_sum.result_id, rpt_nodesurcharge_sum.swnod_type, rpt_nodesurcharge_sum.hour_surch, rpt_nodesurcharge_sum.max_height, rpt_nodesurcharge_sum.min_depth, node.sector_id, node.the_geom 	FROM ((SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_nodesurcharge_sum ON (((result_selection.result_id)::text = (rpt_nodesurcharge_sum.result_id)::text))) JOIN SCHEMA_NAME.node ON (((rpt_nodesurcharge_sum.node_id)::text = (node.node_id)::text)));

-- ----------------------------
-- View structure for v_rpt_outfallflow_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_outfallflow_sum" AS 
SELECT rpt_outfallflow_sum.id, rpt_outfallflow_sum.node_id, rpt_outfallflow_sum.result_id, rpt_outfallflow_sum.flow_freq, rpt_outfallflow_sum.avg_flow, rpt_outfallflow_sum.max_flow, rpt_outfallflow_sum.total_vol, node.the_geom, node.sector_id FROM ((SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_outfallflow_sum ON (((result_selection.result_id)::text = (rpt_outfallflow_sum.result_id)::text))) JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (rpt_outfallflow_sum.node_id)::text)));

-- ----------------------------
-- View structure for v_rpt_outfallload_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_outfallload_sum" AS 
SELECT rpt_outfallload_sum.id, rpt_outfallload_sum.result_id, rpt_outfallload_sum.poll_id, rpt_outfallload_sum.node_id, rpt_outfallload_sum.value, node.sector_id, node.the_geom FROM ((SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_outfallload_sum ON (((result_selection.result_id)::text = (rpt_outfallload_sum.result_id)::text))) JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (rpt_outfallload_sum.node_id)::text)));

-- ----------------------------
-- View structure for v_rpt_pumping_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_pumping_sum" AS 
SELECT rpt_pumping_sum.id, rpt_pumping_sum.result_id, rpt_pumping_sum.arc_id, rpt_pumping_sum.percent, rpt_pumping_sum.max_flow, rpt_pumping_sum.avg_flow, rpt_pumping_sum.vol_ltr, rpt_pumping_sum.powus_kwh, rpt_pumping_sum.timoff_cur, arc.sector_id, arc.the_geom FROM ((SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_pumping_sum ON (((result_selection.result_id)::text = (rpt_pumping_sum.result_id)::text))) JOIN SCHEMA_NAME.arc ON (((arc.arc_id)::text = (rpt_pumping_sum.arc_id)::text)));

-- ----------------------------
-- View structure for v_rpt_qualrouting
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_qualrouting" AS 
SELECT rpt_qualrouting_cont.id, rpt_qualrouting_cont.result_id, rpt_qualrouting_cont.poll_id, rpt_qualrouting_cont.dryw_inf, rpt_qualrouting_cont.wetw_inf, rpt_qualrouting_cont.ground_inf, rpt_qualrouting_cont.rdii_inf, rpt_qualrouting_cont.ext_inf, rpt_qualrouting_cont.int_inf, rpt_qualrouting_cont.ext_out, rpt_qualrouting_cont.mass_reac, rpt_qualrouting_cont.initst_mas, rpt_qualrouting_cont.finst_mas, rpt_qualrouting_cont.cont_error FROM (SCHEMA_NAME.rpt_qualrouting_cont JOIN SCHEMA_NAME.result_selection ON (((result_selection.result_id)::text = (rpt_qualrouting_cont.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_rainfall_dep
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_rainfall_dep" AS 
SELECT rpt_rainfall_dep.id, rpt_rainfall_dep.result_id, rpt_rainfall_dep.sewer_rain, rpt_rainfall_dep.rdiip_prod, rpt_rainfall_dep.rdiir_rat FROM (SCHEMA_NAME.rpt_rainfall_dep JOIN SCHEMA_NAME.result_selection ON (((result_selection.result_id)::text = (rpt_rainfall_dep.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_routing_timestep
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_routing_timestep" AS 
SELECT rpt_routing_timestep.id, rpt_routing_timestep.result_id, rpt_routing_timestep.text FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_routing_timestep ON (((result_selection.result_id)::text = (rpt_routing_timestep.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_runoff_qual
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_runoff_qual" AS 
SELECT rpt_runoff_qual.id, rpt_runoff_qual.result_id, rpt_runoff_qual.poll_id, rpt_runoff_qual.init_buil, rpt_runoff_qual.surf_buil, rpt_runoff_qual.wet_dep, rpt_runoff_qual.sweep_re, rpt_runoff_qual.infil_loss, rpt_runoff_qual.bmp_re, rpt_runoff_qual.surf_runof, rpt_runoff_qual.rem_buil, rpt_runoff_qual.cont_error FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_runoff_qual ON (((result_selection.result_id)::text = (rpt_runoff_qual.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_runoff_quant
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_runoff_quant" AS 
SELECT rpt_runoff_quant.id, rpt_runoff_quant.result_id, rpt_runoff_quant.initsw_co, rpt_runoff_quant.total_prec, rpt_runoff_quant.evap_loss, rpt_runoff_quant.infil_loss, rpt_runoff_quant.surf_runof, rpt_runoff_quant.snow_re, rpt_runoff_quant.finalsw_co, rpt_runoff_quant.finals_sto, rpt_runoff_quant.cont_error FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_runoff_quant ON (((result_selection.result_id)::text = (rpt_runoff_quant.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_storagevol_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_storagevol_sum" AS 
SELECT rpt_storagevol_sum.id, rpt_storagevol_sum.result_id, rpt_storagevol_sum.node_id, rpt_storagevol_sum.aver_vol, rpt_storagevol_sum.avg_full, rpt_storagevol_sum.ei_loss, rpt_storagevol_sum.max_vol, rpt_storagevol_sum.max_full, rpt_storagevol_sum.time_days, rpt_storagevol_sum.time_hour, rpt_storagevol_sum.max_out, node.sector_id, node.the_geom FROM ((SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_storagevol_sum ON (((result_selection.result_id)::text = (rpt_storagevol_sum.result_id)::text))) JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (rpt_storagevol_sum.node_id)::text)));

-- ----------------------------
-- View structure for v_rpt_subcatchrunoff_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_subcatchrunoff_sum" AS 
SELECT rpt_subcathrunoff_sum.id, rpt_subcathrunoff_sum.result_id, rpt_subcathrunoff_sum.subc_id, rpt_subcathrunoff_sum.tot_precip, rpt_subcathrunoff_sum.tot_runon, rpt_subcathrunoff_sum.tot_evap, rpt_subcathrunoff_sum.tot_infil, rpt_subcathrunoff_sum.tot_runoff, rpt_subcathrunoff_sum.tot_runofl, rpt_subcathrunoff_sum.peak_runof, rpt_subcathrunoff_sum.runoff_coe, subcatchment.sector_id, subcatchment.the_geom FROM ((SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_subcathrunoff_sum ON (((result_selection.result_id)::text = (rpt_subcathrunoff_sum.result_id)::text))) JOIN SCHEMA_NAME.subcatchment ON (((rpt_subcathrunoff_sum.subc_id)::text = (subcatchment.subc_id)::text)));

-- ----------------------------
-- View structure for v_rpt_subcatchwasoff_sum
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_subcatchwasoff_sum" AS 
SELECT rpt_subcatchwashoff_sum.id, rpt_subcatchwashoff_sum.result_id, rpt_subcatchwashoff_sum.subc_id, rpt_subcatchwashoff_sum.poll_id, rpt_subcatchwashoff_sum.value, subcatchment.sector_id, subcatchment.the_geom FROM ((SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_subcatchwashoff_sum ON (((result_selection.result_id)::text = (rpt_subcatchwashoff_sum.result_id)::text))) JOIN SCHEMA_NAME.subcatchment ON (((rpt_subcatchwashoff_sum.subc_id)::text = (subcatchment.subc_id)::text)));

-- ----------------------------
-- View structure for v_rpt_timestep_critelem
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_timestep_critelem" AS 
SELECT rpt_timestep_critelem.id, rpt_timestep_critelem.result_id, rpt_timestep_critelem.text FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_timestep_critelem ON (((result_selection.result_id)::text = (rpt_timestep_critelem.result_id)::text)));


-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table arc
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."arc" ADD PRIMARY KEY ("arc_id");

-- ----------------------------
-- Primary Key structure for table cat_arc
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table cat_mat
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."cat_mat" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_aquifer
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_aquifer" ADD PRIMARY KEY ("aquif_id");

-- ----------------------------
-- Primary Key structure for table inp_backdrop
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_backdrop" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_buildup_land_x_pol
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_buildup_land_x_pol" ADD PRIMARY KEY ("landus_id", "poll_id");

-- ----------------------------
-- Primary Key structure for table inp_conduit
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_conduit" ADD PRIMARY KEY ("arc_id");

-- ----------------------------
-- Primary Key structure for table inp_controls
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_controls" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_coverage_land_x_subc
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_coverage_land_x_subc" ADD PRIMARY KEY ("subc_id", "landus_id");

-- ----------------------------
-- Primary Key structure for table inp_curve
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_curve" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_curve_id
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_curve_id" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_divider
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_divider" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_dwf
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_dwf" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_dwf_pol_x_node
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_dwf_pol_x_node" ADD PRIMARY KEY ("poll_id", "node_id");

-- ----------------------------
-- Primary Key structure for table inp_evaporation
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_evaporation" ADD PRIMARY KEY ("evap_type");

-- ----------------------------
-- Primary Key structure for table inp_files
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_files" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_groundwater
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_groundwater" ADD PRIMARY KEY ("subc_id", "aquif_id");

-- ----------------------------
-- Primary Key structure for table inp_hydrograph
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_hydrograph" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_inflows
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_inflows" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_inflows_pol_x_node
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_inflows_pol_x_node" ADD PRIMARY KEY ("poll_id", "node_id");

-- ----------------------------
-- Primary Key structure for table inp_junction
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_junction" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_label
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_label" ADD PRIMARY KEY ("label");

-- ----------------------------
-- Primary Key structure for table inp_landuses
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_landuses" ADD PRIMARY KEY ("landus_id");

-- ----------------------------
-- Primary Key structure for table inp_lid_control
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_lid_control" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_lidusage_subc_x_lidco
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_lidusage_subc_x_lidco" ADD PRIMARY KEY ("subc_id", "lidco_id");

-- ----------------------------
-- Primary Key structure for table inp_loadings_pol_x_subc
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_loadings_pol_x_subc" ADD PRIMARY KEY ("poll_id", "subc_id");

-- ----------------------------
-- Primary Key structure for table inp_options
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD PRIMARY KEY ("flow_units");

-- ----------------------------
-- Primary Key structure for table inp_orifice
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_orifice" ADD PRIMARY KEY ("arc_id");

-- ----------------------------
-- Primary Key structure for table inp_outfall
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_outfall" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_outlet
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_outlet" ADD PRIMARY KEY ("arc_id");

-- ----------------------------
-- Primary Key structure for table inp_pattern
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_pattern" ADD PRIMARY KEY ("pattern_id");

-- ----------------------------
-- Primary Key structure for table inp_pollutant
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_pollutant" ADD PRIMARY KEY ("poll_id");

-- ----------------------------
-- Primary Key structure for table inp_landuses
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_project_id" ADD PRIMARY KEY ("title");

-- ----------------------------
-- Primary Key structure for table inp_pump
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_pump" ADD PRIMARY KEY ("arc_id");

-- ----------------------------
-- Primary Key structure for table inp_rdii
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_rdii" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_report
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD PRIMARY KEY ("input");

-- ----------------------------
-- Primary Key structure for table inp_snowmelt
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_snowmelt" ADD PRIMARY KEY ("stemp");

-- ----------------------------
-- Primary Key structure for table inp_snowpack
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_snowpack" ADD PRIMARY KEY ("snow_id");

-- ----------------------------
-- Primary Key structure for table inp_storage
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_storage" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_temperature
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_temperature" ADD PRIMARY KEY ("temp_type");

-- ----------------------------
-- Primary Key structure for table inp_timeseries
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_timeseries" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_timser_id
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_timser_id" ADD PRIMARY KEY ("id");

-- ----------------------------

-- Primary Key structure for table inp_transects
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_transects" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_treatment_node_x_pol
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_treatment_node_x_pol" ADD PRIMARY KEY ("node_id", "poll_id");

-- ----------------------------
-- Primary Key structure for table inp_type_arc
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_type_arc" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_type_node
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_type_node" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_divider
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_divider" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_evap
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_evap" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_orifice
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_orifice" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_outfall
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_outfall" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_outlet
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_outlet" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_pattern
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_pattern" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_raingage
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_raingage" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_storage
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_storage" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_temp
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_temp" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_timeseries
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_timeseries" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_windsp
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_windsp" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_allnone
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_allnone" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_buildup
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_buildup" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_curve
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_curve" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_files_actio
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_files_actio" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_files_type
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_files_type" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_inflows
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_inflows" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_lidcontrol
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_lidcontrol" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_mapunits
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_mapunits" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_options_fme
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_options_fme" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_options_fr
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_options_fr" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_options_fu
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_options_fu" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_options_id
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_options_id" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_options_in
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_options_in" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_options_lo
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_options_lo" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_options_nfl
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_options_nfl" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_orifice
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_orifice" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_pollutants
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_pollutants" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_raingage
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_raingage" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_timserid
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_timserid" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_treatment
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_treatment" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_washoff
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_washoff" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_weirs
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_weirs" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_yesno
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_yesno" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_washoff_land_x_pol
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_washoff_land_x_pol" ADD PRIMARY KEY ("landus_id", "poll_id");

-- ----------------------------
-- Primary Key structure for table inp_weir
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_weir" ADD PRIMARY KEY ("arc_id");

-- ----------------------------
-- Primary Key structure for table inp_windspeed
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_windspeed" ADD PRIMARY KEY ("wind_type");

-- ----------------------------
-- Primary Key structure for table node
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."node" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table raingage
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."raingage" ADD PRIMARY KEY ("rg_id");

-- ----------------------------
-- Primary Key structure for table result_selection
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."result_selection" ADD PRIMARY KEY ("result_id");

-- ----------------------------
-- Primary Key structure for table rpt_arcflow_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_arcflow_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_condsurcharge_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_condsurcharge_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_continuity_errors
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_continuity_errors" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_critical_elements
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_critical_elements" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_flowclass_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_flowclass_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_flowrouting_cont
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_flowrouting_cont" ADD PRIMARY KEY ("result_id");

-- ----------------------------
-- Primary Key structure for table rpt_groundwater_cont
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_groundwater_cont" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_high_conterrors
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_high_conterrors" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_high_flowinest_ind
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_high_flowinest_ind" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_instability_index
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_instability_index" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_lidperformance_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_lidperformance_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_nodedepth_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_nodedepth_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_nodeflooding_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_nodeflooding_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_nodeinflow_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_nodeinflow_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_nodesurcharge_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_nodesurcharge_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_outfallflow_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_outfallflow_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_outfallload_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_outfallload_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_pumping_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_pumping_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_qualrouting_cont
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_qualrouting_cont" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_rainfall_dep
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_rainfall_dep" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_result_cat
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_result_cat" ADD PRIMARY KEY ("result_id");

-- ----------------------------
-- Primary Key structure for table rpt_routing_timestep
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_routing_timestep" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_runoff_qual
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_runoff_qual" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_runoff_quant
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_runoff_quant" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_storagevol_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_storagevol_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_subcatchwashoff_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_subcatchwashoff_sum" ADD PRIMARY KEY ("result_id", "subc_id", "poll_id");

-- ----------------------------
-- Primary Key structure for table rpt_subcathrunoff_sum
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_subcathrunoff_sum" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_timestep_critelem
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_timestep_critelem" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table sector
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."sector" ADD PRIMARY KEY ("sector_id");

-- ----------------------------
-- Primary Key structure for table sector_selection
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."sector_selection" ADD PRIMARY KEY ("sector_id");

-- ----------------------------
-- Primary Key structure for table subcatchment
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."subcatchment" ADD PRIMARY KEY ("subc_id");

ALTER TABLE "SCHEMA_NAME"."version" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."arc"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("arccat_id") REFERENCES "SCHEMA_NAME"."cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("node_1") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("node_2") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_conduit"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_conduit" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_curve"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_curve" ADD FOREIGN KEY ("curve_id") REFERENCES "SCHEMA_NAME"."inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_divider"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_divider" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_dwf"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_dwf" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_dwf_pol_x_node"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_dwf_pol_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_inflows"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_inflows" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_inflows_pol_x_node"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_inflows_pol_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_junction"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_junction" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_orifice"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_orifice" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;


-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_options"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("infiltration") REFERENCES "SCHEMA_NAME"."inp_value_options_in" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("allow_ponding") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("normal_flow_limited") REFERENCES "SCHEMA_NAME"."inp_value_options_nfl" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("inertial_damping") REFERENCES "SCHEMA_NAME"."inp_value_options_id" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("skip_steady_state") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("ignore_quality") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("ignore_routing") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("ignore_groundwater") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("ignore_snowmelt") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("ignore_rainfall") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("force_main_equation") REFERENCES "SCHEMA_NAME"."inp_value_options_fme" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("link_offsets") REFERENCES "SCHEMA_NAME"."inp_value_options_lo" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("flow_routing") REFERENCES "SCHEMA_NAME"."inp_value_options_fr" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("flow_units") REFERENCES "SCHEMA_NAME"."inp_value_options_fu" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_outfall"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_outfall" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_outlet"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_outlet" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_pump"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_pump" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_rdii"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_rdii" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_report"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("controls") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("input") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("continuity") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("flowstats") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_storage"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_storage" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_timeseries"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_timeseries" ADD FOREIGN KEY ("timser_id") REFERENCES "SCHEMA_NAME"."inp_timser_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_treatment_node_x_pol"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_treatment_node_x_pol" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_weir"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_weir" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."node"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_arcflow_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_arcflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_condsurcharge_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_condsurcharge_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_continuity_errors"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_continuity_errors" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_critical_elements"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_critical_elements" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_flowclass_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_flowclass_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_flowrouting_cont"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_flowrouting_cont" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_groundwater_cont"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_groundwater_cont" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_high_conterrors"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_high_conterrors" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_high_flowinest_ind"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_high_flowinest_ind" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_instability_index"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_instability_index" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_lidperformance_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_lidperformance_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_nodedepth_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_nodedepth_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_nodeflooding_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_nodeflooding_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_nodeinflow_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_nodeinflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_nodesurcharge_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_nodesurcharge_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_outfallflow_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_outfallflow_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_outfallload_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_outfallload_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_pumping_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_pumping_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_qualrouting_cont"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_qualrouting_cont" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_rainfall_dep"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_rainfall_dep" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_routing_timestep"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_routing_timestep" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_runoff_qual"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_runoff_qual" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_runoff_quant"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_runoff_quant" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_storagevol_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_storagevol_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_subcatchwashoff_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_subcatchwashoff_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_subcathrunoff_sum"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_subcathrunoff_sum" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_timestep_critelem"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_timestep_critelem" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."subcatchment"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."subcatchment" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;




