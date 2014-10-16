/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- ----------------------------
-- Sequence structure for inp_node_id_seq
-- --------------------------

CREATE SEQUENCE "SCHEMA_NAME"."inp_node_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	
	
-- ----------------------------
-- Sequence structure for inp_arc_id_seq
-- --------------------------

CREATE SEQUENCE "SCHEMA_NAME"."inp_arc_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- ----------------------------
-- Sequence structure for version_seq
-- --------------------------
CREATE SEQUENCE "SCHEMA_NAME"."version_seq"
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
-- Sequence structure for inp_demand_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_demand_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- ----------------------------
-- Sequence structure for inp_labels_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_labels_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- ----------------------------
-- Sequence structure for inp_rules_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_rules_id_seq"
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
-- Sequence structure for inp_vertice_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."inp_vertice_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_arc_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_arc_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_energy_usage_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_energy_usage_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_hydraulic_status_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_hydraulic_status_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- ----------------------------
-- Sequence structure for rpt_node_id_seq
-- ----------------------------
CREATE SEQUENCE "SCHEMA_NAME"."rpt_node_id_seq"
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
"diameter" numeric(12,4),
"matcat_id" varchar(16) COLLATE "default",
"enet_type" varchar(18) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"the_geom" geometry (LINESTRING, SRID_VALUE)
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for cat_mat
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."cat_mat" (
"id" varchar(16) COLLATE "default",
"descript" varchar(100) COLLATE "default",
"roughness" numeric(12,4)
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
-- Table structure for inp_controls
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_controls" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_controls_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_curve
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_curve" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_curve_id_seq'::regclass) NOT NULL,
"curve_id" varchar(16) COLLATE "default" NOT NULL,
"x_value" numeric,
"y_value" numeric
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
-- Table structure for inp_demand
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_demand" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_demand_id_seq'::regclass) NOT NULL,
"node_id" varchar(16) COLLATE "default" NOT NULL,
"demand" numeric,
"pattern_id" varchar(16) COLLATE "default",
"deman_type" varchar(18) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_emitter
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_emitter" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"coef" numeric
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_energy_el
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_energy_el" (
"pump_id" int4 NOT NULL,
"parameter" varchar(20) COLLATE "default",
"value" varchar(30) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_energy_gl
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_energy_gl" (
"energ_type" varchar(18) COLLATE "default",
"parameter" varchar(20) COLLATE "default",
"value" varchar(30) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_junction
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_junction" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"demand" numeric,
"pattern_id" varchar(16) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_label
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_label" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_labels_id_seq'::regclass) NOT NULL,
"xcoord" numeric(18,6),
"ycoord" numeric(18,6),
"label" varchar(50) COLLATE "default",
"node_id" varchar(16) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_mixing
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_mixing" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"mix_type" varchar(18) COLLATE "default",
"value" numeric
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_options
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_options" (
"units" varchar(20) COLLATE "default" NOT NULL,
"headloss" varchar(20) COLLATE "default",
"hydraulics" varchar(12) COLLATE "default",
"specific_gravity" numeric,
"viscosity" numeric,
"trials" numeric,
"accuracy" numeric,
"unbalanced" varchar(12) COLLATE "default",
"checkfreq" numeric,
"maxcheck" numeric,
"damplimit" numeric,
"pattern" varchar(16) COLLATE "default",
"demand_multiplier" numeric,
"emitter_exponent" numeric,
"quality" varchar(18) COLLATE "default",
"diffusivity" numeric,
"tolerance" numeric,
"hydraulics_fname" varchar(254) COLLATE "default",
"unbalanced_n" numeric,
"node_id" varchar(16) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_pattern
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_pattern" (
"pattern_id" varchar(16) COLLATE "default" NOT NULL,
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
-- Table structure for inp_pipe
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_pipe" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"minorloss" numeric,
"status" varchar(12) COLLATE "default"
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
"power" varchar COLLATE "default",
"curve_id" varchar COLLATE "default",
"speed" numeric,
"pattern" varchar COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_quality
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_quality" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"initqual" numeric
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_reactions_el
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_reactions_el" (
"parameter" varchar(20) COLLATE "default" NOT NULL,
"arc_id" varchar(16) COLLATE "default",
"value" numeric
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_reactions_gl
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_reactions_gl" (
"react_type" varchar(30) COLLATE "default" NOT NULL,
"parameter" varchar(20) COLLATE "default",
"value" numeric
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_report
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_report" (
"pagesize" numeric NOT NULL,
"file" varchar(254) COLLATE "default",
"status" varchar(4) COLLATE "default",
"summary" varchar(3) COLLATE "default",
"energy" varchar(3) COLLATE "default",
"nodes" varchar(254) COLLATE "default",
"links" varchar(254) COLLATE "default",
"elevation" varchar(16) COLLATE "default",
"demand" varchar(16) COLLATE "default",
"head" varchar(16) COLLATE "default",
"pressure" varchar(16) COLLATE "default",
"quality" varchar(16) COLLATE "default",
"length" varchar(16) COLLATE "default",
"diameter" varchar(16) COLLATE "default",
"flow" varchar(16) COLLATE "default",
"velocity" varchar(16) COLLATE "default",
"headloss" varchar(16) COLLATE "default",
"setting" varchar(16) COLLATE "default",
"reaction" varchar(16) COLLATE "default",
"f_factor" varchar(16) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_reservoir
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_reservoir" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"head" numeric,
"pattern_id" varchar(16) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_rules
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_rules" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_rules_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_source
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_source" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"sourc_type" varchar(18) COLLATE "default",
"quality" numeric,
"pattern_id" varchar(16) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_tags
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_tags" (
"object" varchar(18) COLLATE "default",
"node_id" varchar(16) COLLATE "default" NOT NULL,
"tag" varchar(50) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_tank
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_tank" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"initlevel" numeric,
"minlevel" numeric,
"maxlevel" numeric,
"diameter" numeric,
"minvol" numeric,
"curve_id" int4
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_times
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_times" (
"duration" varchar(10) COLLATE "default" NOT NULL,
"hydraulic_timestep" varchar(10) COLLATE "default",
"quality_timestep" varchar(10) COLLATE "default",
"rule_timestep" varchar(10) COLLATE "default",
"pattern_timestep" varchar(10) COLLATE "default",
"pattern_start" varchar(10) COLLATE "default",
"report_timestep" varchar(10) COLLATE "default",
"report_start" varchar(10) COLLATE "default",
"start_clocktime" varchar(10) COLLATE "default",
"statistic" varchar(18) COLLATE "default"
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
-- Table structure for inp_typevalue_energy
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_energy" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_pump
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_pump" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_reactions_gl
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_reactions_gl" (
"id" varchar(30) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_source
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_source" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_typevalue_valve
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_typevalue_valve" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(50) COLLATE "default",
"meter" varchar(18) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_ampm
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_ampm" (
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
-- Table structure for inp_value_mixing
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_mixing" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_noneall
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_noneall" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_opti_headloss
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_opti_headloss" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_opti_hyd
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_opti_hyd" (
"id" varchar(20) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_opti_qual
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_opti_qual" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_opti_unb
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_opti_unb" (
"id" varchar(20) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_opti_unbal
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_opti_unbal" (
"id" varchar(20) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_opti_units
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_opti_units" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_param_energy
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_param_energy" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_reactions_el
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_reactions_el" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_reactions_gl
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_reactions_gl" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_st_pipe
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_st_pipe" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_status
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_status" (
"id" varchar(16) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_value_times
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_times" (
"id" varchar(18) COLLATE "default" NOT NULL
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
-- Table structure for inp_value_yesnofull
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_value_yesnofull" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for inp_valve
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."inp_valve" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"valv_type" varchar(18) COLLATE "default",
"pressure" numeric,
"flow" numeric,
"coef_loss" numeric,
"curve_id" int4,
"minorloss" numeric,
"status" varchar(12) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for node
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."node" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"elevation" numeric(12,4),
"enet_type" varchar(18) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
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
-- Table structure for rpt_arc
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_arc" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_arc_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"arc_id" varchar(16) COLLATE "default",
"length" numeric,
"diameter" numeric,
"flow" numeric,
"vel" numeric,
"headloss" numeric,
"setting" numeric,
"reaction" numeric,
"ffactor" numeric,
"other" varchar(100) COLLATE "default",
"time" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_energy_usage
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_energy_usage" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_energy_usage_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"pump_id" int4,
"usage_fact" numeric,
"avg_effic" numeric,
"kwhr_mgal" numeric,
"avg_kw" numeric,
"peak_kw" numeric,
"cost_day" numeric
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_hydraulic_status
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_hydraulic_status" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_hydraulic_status_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"time" varchar(10) COLLATE "default",
"text" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_node
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_node" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_node_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"node_id" varchar(16) COLLATE "default" NOT NULL,
"elevation" numeric,
"demand" numeric,
"head" numeric,
"press" numeric,
"other" varchar(100) COLLATE "default",
"time" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for rpt_result_cat
-- ----------------------------
CREATE TABLE "SCHEMA_NAME"."rpt_result_cat" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_result_cat_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"n_junction" numeric,
"n_reservoir" numeric,
"n_tank" numeric,
"n_pipe" numeric,
"n_pump" numeric,
"n_valve" numeric,
"head_form" varchar(20) COLLATE "default",
"hydra_time" varchar(10) COLLATE "default",
"hydra_acc" numeric,
"st_ch_freq" numeric,
"max_tr_ch" numeric,
"dam_li_thr" numeric,
"max_trials" numeric,
"q_analysis" varchar(20) COLLATE "default",
"spec_grav" numeric,
"r_kin_visc" numeric,
"r_che_diff" numeric,
"dem_multi" numeric,
"total_dura" varchar(10) COLLATE "default",
"exec_date" timestamp(6) DEFAULT now()
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
-- View structure for v_inp_arc_x_node
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_arc_x_node" AS 
SELECT arc_id, node_1, node_2 FROM SCHEMA_NAME.arc;



-- ----------------------------
-- View structure for v_inp_curve
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_curve" AS 
SELECT inp_curve.curve_id, inp_curve.x_value, inp_curve.y_value FROM SCHEMA_NAME.inp_curve ORDER BY inp_curve.id;

-- ----------------------------
-- View structure for v_inp_demand
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_demand" AS 
SELECT inp_demand.node_id, inp_demand.demand, inp_demand.pattern_id, inp_demand.deman_type, sector_selection.sector_id FROM ((SCHEMA_NAME.inp_demand JOIN SCHEMA_NAME.node ON (((inp_demand.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_junction
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_junction" AS 
SELECT node.node_id, node.elevation, inp_junction.demand, inp_junction.pattern_id, node.sector_id, node.the_geom FROM (SCHEMA_NAME.inp_junction JOIN SCHEMA_NAME.node ON ((((inp_junction.node_id)::text = (node.node_id)::text) AND ((inp_junction.node_id)::text = (node.node_id)::text))));

-- ----------------------------
-- View structure for v_inp_edit_pipe
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_pipe" AS 
SELECT arc.arc_id, arc.diameter, arc.matcat_id, inp_pipe.minorloss, inp_pipe.status, arc.sector_id, arc.the_geom FROM (SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_pipe ON (((inp_pipe.arc_id)::text = (arc.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_pump
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_pump" AS 
SELECT inp_pump.arc_id, arc.diameter, arc.matcat_id, inp_pump.power, inp_pump.curve_id, inp_pump.speed, inp_pump.pattern, arc.sector_id, arc.the_geom FROM (SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_pump ON (((arc.arc_id)::text = (inp_pump.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_reservoir
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_reservoir" AS 
SELECT inp_reservoir.node_id, node.elevation, inp_reservoir.head, inp_reservoir.pattern_id, node.sector_id, node.the_geom FROM (SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_reservoir ON (((inp_reservoir.node_id)::text = (node.node_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_tank
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_tank" AS 
SELECT node.node_id, node.elevation, inp_tank.initlevel, inp_tank.minlevel, inp_tank.maxlevel, inp_tank.diameter, inp_tank.minvol, inp_tank.curve_id, node.sector_id, node.the_geom FROM (SCHEMA_NAME.inp_tank JOIN SCHEMA_NAME.node ON (((inp_tank.node_id)::text = (node.node_id)::text)));

-- ----------------------------
-- View structure for v_inp_edit_valve
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_valve" AS 
SELECT inp_valve.arc_id, arc.diameter, arc.matcat_id, inp_valve.valv_type, inp_valve.pressure, inp_valve.flow, inp_valve.coef_loss, inp_valve.curve_id, inp_valve.minorloss, inp_valve.status, arc.sector_id, arc.the_geom FROM (SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_valve ON (((arc.arc_id)::text = (inp_valve.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_emitter
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_emitter" AS 
SELECT inp_emitter.node_id, inp_emitter.coef, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.inp_emitter JOIN SCHEMA_NAME.node ON (((inp_emitter.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)));

-- ----------------------------
-- View structure for v_inp_energy_el
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_energy_el" AS 
SELECT 'PUMP'::text AS type_pump, inp_energy_el.pump_id, inp_energy_el.parameter, inp_energy_el.value FROM SCHEMA_NAME.inp_energy_el;

-- ----------------------------
-- View structure for v_inp_junction
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_junction" AS 
SELECT inp_junction.node_id, node.elevation, inp_junction.demand, inp_junction.pattern_id, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.inp_junction JOIN SCHEMA_NAME.node ON ((((inp_junction.node_id)::text = (node.node_id)::text) AND ((inp_junction.node_id)::text = (node.node_id)::text)))) JOIN SCHEMA_NAME.sector_selection ON ((((node.sector_id)::text = (sector_selection.sector_id)::text) AND ((node.sector_id)::text = (sector_selection.sector_id)::text)))) ORDER BY inp_junction.node_id;

-- ----------------------------
-- View structure for v_inp_mixing
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_mixing" AS 
SELECT inp_mixing.node_id, inp_mixing.mix_type, inp_mixing.value, sector_selection.sector_id FROM ((SCHEMA_NAME.inp_mixing JOIN SCHEMA_NAME.node ON (((inp_mixing.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)));

-- ----------------------------
-- View structure for v_inp_options
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_options" AS 
SELECT inp_options.units, inp_options.headloss, (((inp_options.hydraulics)::text || ' '::text) || (inp_options.hydraulics_fname)::text) AS hydraulics, inp_options.specific_gravity AS "specific gravity", inp_options.viscosity, inp_options.trials, inp_options.accuracy, (((inp_options.unbalanced)::text || ' '::text) || (inp_options.unbalanced_n)::text) AS unbalanced, inp_options.checkfreq, inp_options.maxcheck, inp_options.damplimit, inp_options.pattern, inp_options.demand_multiplier AS "demand multiplier", inp_options.emitter_exponent AS "emitter exponent", (((inp_options.quality) :: TEXT || ' ' :: TEXT) || (inp_options.node_id) :: TEXT) AS quality, inp_options.diffusivity, inp_options.tolerance FROM SCHEMA_NAME.inp_options;

-- ----------------------------
-- View structure for v_inp_pipe
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_pipe" AS 
SELECT arc.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, (st_length2d(arc.the_geom))::numeric(16,3) AS length, arc.diameter, cat_mat.roughness, inp_pipe.minorloss, inp_pipe.status, sector_selection.sector_id FROM ((((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_pipe ON (((arc.arc_id)::text = (inp_pipe.arc_id)::text))) JOIN SCHEMA_NAME.cat_mat ON (((arc.matcat_id)::text = (cat_mat.id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_pump
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_pump" AS 
SELECT inp_pump.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, (('POWER'::text || ' '::text) || (inp_pump.power)::text) AS power, (('HEAD'::text || ' '::text) || (inp_pump.curve_id)::text) AS head, (('SPEED'::text || ' '::text) || inp_pump.speed) AS speed, (('PATTERN'::text || ' '::text) || (inp_pump.pattern)::text) AS pattern, sector_selection.sector_id FROM (((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_pump ON (((arc.arc_id)::text = (inp_pump.arc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text)));

-- ----------------------------
-- View structure for v_inp_report
-- ----------------------------

CREATE VIEW "SCHEMA_NAME"."v_inp_report" AS 
SELECT inp_report.pagesize,inp_report.status,inp_report.summary,inp_report.energy,inp_report.nodes,inp_report.links,inp_report.elevation,inp_report.demand,inp_report.head,inp_report.pressure,inp_report.quality,inp_report."length",inp_report.diameter,inp_report.flow,inp_report.velocity,inp_report.headloss,inp_report.setting,inp_report.reaction,inp_report.f_factor AS "f-factor" FROM SCHEMA_NAME.inp_report;

-- ----------------------------
-- View structure for v_inp_reservoir
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_reservoir" AS 
SELECT inp_reservoir.node_id, inp_reservoir.head, inp_reservoir.pattern_id, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_reservoir ON (((inp_reservoir.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)));

-- ----------------------------
-- View structure for v_inp_rules
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_rules" AS 
SELECT inp_rules.text FROM SCHEMA_NAME.inp_rules ORDER BY inp_rules.id;

-- ----------------------------
-- View structure for v_inp_source
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_source" AS 
SELECT inp_source.node_id, inp_source.sourc_type, inp_source.quality, inp_source.pattern_id, sector_selection.sector_id FROM ((SCHEMA_NAME.inp_source JOIN SCHEMA_NAME.node ON (((inp_source.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)));

-- ----------------------------
-- View structure for v_inp_status
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_status" AS 
SELECT inp_valve.arc_id, inp_valve.status FROM SCHEMA_NAME.inp_valve WHERE inp_valve.status::text = 'OPEN'::text OR inp_valve.status::text = 'CLOSED'::text;

-- ----------------------------
-- View structure for v_inp_tank
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_tank" AS 
SELECT inp_tank.node_id, node.elevation, inp_tank.initlevel, inp_tank.minlevel, inp_tank.maxlevel, inp_tank.diameter, inp_tank.minvol, inp_tank.curve_id, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id FROM ((SCHEMA_NAME.inp_tank JOIN SCHEMA_NAME.node ON (((inp_tank.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)));

-- ----------------------------
-- View structure for v_inp_times
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_times" AS 
SELECT inp_times.duration, inp_times.hydraulic_timestep AS "hydraulic timestep", inp_times.quality_timestep AS "quality timestep", inp_times.rule_timestep AS "rule timestep", inp_times.pattern_timestep AS "pattern timestep", inp_times.pattern_start AS "pattern start", inp_times.report_timestep AS "report timestep", inp_times.report_start AS "report start", inp_times.start_clocktime AS "start clocktime", inp_times.statistic FROM SCHEMA_NAME.inp_times;

-- ----------------------------
-- View structure for v_inp_valve_cu
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_valve_cu" AS 
SELECT inp_valve.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, arc.diameter, inp_valve.valv_type, inp_valve.curve_id, inp_valve.minorloss, sector_selection.sector_id FROM (((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_valve ON (((arc.arc_id)::text = (inp_valve.arc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text))) WHERE ((inp_valve.valv_type)::text = 'GPV'::text);

-- ----------------------------
-- View structure for v_inp_valve_fl
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_valve_fl" AS 
SELECT inp_valve.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, arc.diameter, inp_valve.valv_type, inp_valve.flow, inp_valve.minorloss, sector_selection.sector_id FROM (((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_valve ON (((arc.arc_id)::text = (inp_valve.arc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text))) WHERE ((inp_valve.valv_type)::text = 'FCV'::text);

-- ----------------------------
-- View structure for v_inp_valve_lc
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_valve_lc" AS 
SELECT inp_valve.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, arc.diameter, inp_valve.valv_type, inp_valve.coef_loss, inp_valve.minorloss, sector_selection.sector_id FROM (((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_valve ON (((arc.arc_id)::text = (inp_valve.arc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text))) WHERE ((inp_valve.valv_type)::text = 'TCV'::text);

-- ----------------------------
-- View structure for v_inp_valve_pr
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_valve_pr" AS 
SELECT inp_valve.arc_id, v_inp_arc_x_node.node_1, v_inp_arc_x_node.node_2, arc.diameter, inp_valve.valv_type, inp_valve.pressure, inp_valve.minorloss, sector_selection.sector_id FROM (((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_valve ON (((arc.arc_id)::text = (inp_valve.arc_id)::text))) JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) JOIN SCHEMA_NAME.v_inp_arc_x_node ON (((v_inp_arc_x_node.arc_id)::text = (arc.arc_id)::text))) WHERE ((((inp_valve.valv_type)::text = 'PRV'::text) OR ((inp_valve.valv_type)::text = 'PSV'::text)) OR ((inp_valve.valv_type)::text = 'PBV'::text));

-- ----------------------------
-- View structure for v_inp_vertice
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_vertice" AS 
SELECT nextval('"SCHEMA_NAME".inp_vertice_id_seq' :: regclass) AS "id",arc.arc_id, st_x (point) :: NUMERIC (16, 3) AS xcoord,st_y (point) ::NUMERIC (16, 3) AS ycoord FROM((SELECT geom (st_dumppoints(arc.the_geom)) AS point,(st_startpoint(arc.the_geom)) AS startpoint,
(st_endpoint(arc.the_geom)) AS endpoint, sector_id, arc_id  FROM SCHEMA_NAME.arc) arc JOIN SCHEMA_NAME.sector_selection ON (		((arc.sector_id) :: TEXT = (sector_selection.sector_id) :: TEXT))) WHERE ((point < startpoint OR point > startpoint)AND (point < endpoint OR point > endpoint))ORDER BY id;

-- ----------------------------
-- View structure for v_rpt_arc
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_arc" AS 
SELECT arc.arc_id, result_selection.result_id, max(rpt_arc.flow) AS max_flow, min(rpt_arc.flow) AS min_flow, max(rpt_arc.vel) AS max_vel, min(rpt_arc.vel) AS min_vel, max(rpt_arc.headloss) AS max_headloss, min(rpt_arc.headloss) AS min_headloss, max(rpt_arc.setting) AS max_setting, min(rpt_arc.setting) AS min_setting, max(rpt_arc.reaction) AS max_reaction, min(rpt_arc.reaction) AS min_reaction, max(rpt_arc.ffactor) AS max_ffactor, min(rpt_arc.ffactor) AS min_ffactor, arc.the_geom FROM ((SCHEMA_NAME.arc JOIN SCHEMA_NAME.rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text))) JOIN SCHEMA_NAME.result_selection ON (((rpt_arc.result_id)::text = (result_selection.result_id)::text))) GROUP BY arc.arc_id, result_selection.result_id, arc.the_geom ORDER BY arc.arc_id;

-- ----------------------------
-- View structure for v_rpt_energy_usage
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_energy_usage" AS 
SELECT rpt_energy_usage.id, rpt_energy_usage.result_id, rpt_energy_usage.pump_id, rpt_energy_usage.usage_fact, rpt_energy_usage.avg_effic, rpt_energy_usage.kwhr_mgal, rpt_energy_usage.avg_kw, rpt_energy_usage.peak_kw, rpt_energy_usage.cost_day FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_energy_usage ON (((result_selection.result_id)::text = (rpt_energy_usage.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_hydraulic_status
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_hydraulic_status" AS 
SELECT rpt_hydraulic_status.id, rpt_hydraulic_status.result_id, rpt_hydraulic_status."time", rpt_hydraulic_status.text FROM (SCHEMA_NAME.rpt_hydraulic_status JOIN SCHEMA_NAME.result_selection ON (((result_selection.result_id)::text = (rpt_hydraulic_status.result_id)::text)));

-- ----------------------------
-- View structure for v_rpt_node
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_rpt_node" AS 
SELECT node.node_id, result_selection.result_id, max(rpt_node.elevation) AS elevation, max(rpt_node.demand) AS max_demand, min(rpt_node.demand) AS min_demand, max(rpt_node.head) AS max_head, min(rpt_node.head) AS min_head, max(rpt_node.press) AS max_pressure, min(rpt_node.press) AS min_pressure, node.the_geom FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.result_selection ON (((rpt_node.result_id)::text = (result_selection.result_id)::text))) GROUP BY node.node_id, result_selection.result_id, node.the_geom ORDER BY node.node_id;

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table arc
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."arc" ADD PRIMARY KEY ("arc_id");

-- ----------------------------
-- Primary Key structure for table cat_mat
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."cat_mat" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_backdrop
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_backdrop" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_controls
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_controls" ADD PRIMARY KEY ("id");

-- Primary Key structure for table inp_curve
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_curve" ADD PRIMARY KEY ("id");	

-- Primary Key structure for table inp_curve_id
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_curve_id" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_demand
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_demand" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_emitter
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_emitter" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_junction
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_junction" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_label
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_label" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_mixing
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_mixing" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_options
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD PRIMARY KEY ("units");

-- ----------------------------
-- Primary Key structure for table inp_pattern
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_pattern" ADD PRIMARY KEY ("pattern_id");

-- ----------------------------
-- Primary Key structure for table inp_pipe
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_pipe" ADD PRIMARY KEY ("arc_id");

-- ----------------------------
-- Primary Key structure for table inp_landuses
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_project_id" ADD PRIMARY KEY ("title");

-- ----------------------------
-- Primary Key structure for table inp_pump
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_pump" ADD PRIMARY KEY ("arc_id");

-- ----------------------------
-- Primary Key structure for table inp_quality
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_quality" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_report
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD PRIMARY KEY ("pagesize");

-- ----------------------------
-- Primary Key structure for table inp_reservoir
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_reservoir" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_rules
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_rules" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_source
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_source" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_tags
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_tags" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_tank
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_tank" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table inp_times
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_times" ADD PRIMARY KEY ("duration");

-- ----------------------------
-- Primary Key structure for table inp_type_arc
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_type_arc" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_type_node
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_type_node" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_energy
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_energy" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_pump
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_pump" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_reactions_gl
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_reactions_gl" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_source
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_source" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_typevalue_valve
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_valve" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_ampm
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_ampm" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_curve
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_curve" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_mixing
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_mixing" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_noneall
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_noneall" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_opti_headloss
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_headloss" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_opti_hyd
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_hyd" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_opti_qual
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_qual" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_opti_unb
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_unb" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_opti_unbal
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_unbal" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_opti_units
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_units" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_param_energy
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_param_energy" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_reactions_el
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_reactions_el" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_reactions_gl
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_reactions_gl" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_st_pipe
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_st_pipe" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_status
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_status" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_times
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_times" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_yesno
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_yesno" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_value_yesnofull
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_value_yesnofull" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table inp_valve
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_valve" ADD PRIMARY KEY ("arc_id");

-- ----------------------------
-- Primary Key structure for table node
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."node" ADD PRIMARY KEY ("node_id");

-- ----------------------------
-- Primary Key structure for table result_selection
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."result_selection" ADD PRIMARY KEY ("result_id");

-- ----------------------------
-- Primary Key structure for table rpt_result_cat
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_result_cat" ADD PRIMARY KEY ("result_id");

-- ----------------------------
-- Primary Key structure for table rpt_arc
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_arc" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_energy_usage
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_energy_usage" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_hydraulic_status
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_hydraulic_status" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table rpt_node
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_node" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table sector
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."sector" ADD PRIMARY KEY ("sector_id");

-- ----------------------------
-- Primary Key structure for table sector_selection
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."sector_selection" ADD PRIMARY KEY ("sector_id");

ALTER TABLE "SCHEMA_NAME"."version" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."arc"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("node_1") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("node_2") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;


-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_curve"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_curve" ADD FOREIGN KEY ("curve_id") REFERENCES "SCHEMA_NAME"."inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_demand"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_demand" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_emitter"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_emitter" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_junction"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_junction" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_mixing"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_mixing" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_options"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("units") REFERENCES "SCHEMA_NAME"."inp_value_opti_units" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("hydraulics") REFERENCES "SCHEMA_NAME"."inp_value_opti_hyd" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("headloss") REFERENCES "SCHEMA_NAME"."inp_value_opti_headloss" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("quality") REFERENCES "SCHEMA_NAME"."inp_value_opti_qual" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("unbalanced") REFERENCES "SCHEMA_NAME"."inp_value_opti_unbal" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_pipe"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_pipe" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_pump"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_pump" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_report"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("pressure") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("demand") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("status") REFERENCES "SCHEMA_NAME"."inp_value_yesnofull" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("summary") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("energy") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("elevation") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("head") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("quality") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("length") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("diameter") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("flow") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("velocity") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("headloss") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("setting") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("reaction") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD FOREIGN KEY ("f_factor") REFERENCES "SCHEMA_NAME"."inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_reservoir"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_reservoir" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_source"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_source" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_tank"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_tank" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_times"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_times" ADD FOREIGN KEY ("statistic") REFERENCES "SCHEMA_NAME"."inp_value_times" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."inp_valve"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."inp_valve" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."node"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_arc"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_arc" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_energy_usage"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_energy_usage" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_hydraulic_status"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_hydraulic_status" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Key structure for table "SCHEMA_NAME"."rpt_node"
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."rpt_node" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

