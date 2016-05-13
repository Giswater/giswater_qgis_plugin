/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- temporals
-- ----------------------------

CREATE SEQUENCE "SCHEMA_NAME"."temp_node_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."temp_arc_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME"."temp_arcnodearc_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."temp_nodearcnode_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE "SCHEMA_NAME"."temp_node" (
"node_id" varchar(16)   NOT NULL,
"elevation" numeric(12,4),
"depth" numeric(12,4),
"nodecat_id" varchar(30)   NOT NULL,
"epa_type" varchar(16)   NOT NULL,
"sector_id" varchar(30)   NOT NULL,
"state" character varying(16) NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(16)   NOT NULL,
"the_geom" public.geometry (POINT, SRID_VALUE),
CONSTRAINT temp_node_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."temp_arc" (
"arc_id" varchar(16)   NOT NULL,
"node_1" varchar(16)  ,
"node_2" varchar(16)  ,
"arccat_id" varchar(30)   NOT NULL,
"epa_type" varchar(16)   NOT NULL,
"sector_id" varchar(30)   NOT NULL,
"state" character varying(16) NOT NULL,
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"custom_length" numeric (12,2),
"rotation" numeric (6,3),
"link" character varying(512),
"verified" varchar(16)   NOT NULL,
"the_geom" public.geometry (LINESTRING, SRID_VALUE),
CONSTRAINT temp_arc_pkey PRIMARY KEY (arc_id)
);


CREATE TABLE "SCHEMA_NAME"."temp_nodearcnode" (
node_id varchar(16)  ,
arc_id varchar(16)  ,
node_2 varchar(16)  ,
CONSTRAINT temp_nodearcnode_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."temp_arcnodearc" (
node_id varchar(16)  ,
arc_1 varchar(16)  ,
arc_2 varchar(16)  ,
CONSTRAINT temp_arcnodearc_pkey PRIMARY KEY (node_id)
);



-- ----------------------------
-- Sequence structure
-- ----------------------------

CREATE SEQUENCE "SCHEMA_NAME"."inp_backdrop_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."inp_controls_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."inp_curve_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."inp_demand_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."inp_labels_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."inp_pattern_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."inp_rules_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."inp_sector_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."inp_vertice_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."rpt_arc_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."rpt_energy_usage_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."rpt_hydraulic_status_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."rpt_node_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."rpt_nodearcnode_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."rpt_arcnodearc_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."rpt_cat_result_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

    

-- ----------------------------
-- Table structure INP
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."inp_arc_type" (
"id" varchar(16)   NOT NULL,
CONSTRAINT inp_arc_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."inp_node_type" (
"id" varchar(16)   NOT NULL,
CONSTRAINT inp_node_type_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."inp_backdrop" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_backdrop_id_seq'::regclass) NOT NULL,
"text" varchar(254)  
);


CREATE TABLE "SCHEMA_NAME"."inp_controls" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_controls_id_seq'::regclass) NOT NULL,
"text" varchar(254)  
);


CREATE TABLE "SCHEMA_NAME"."inp_curve" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_curve_id_seq'::regclass) NOT NULL,
"curve_id" varchar(16)   NOT NULL,
"x_value" numeric(12,4),
"y_value" numeric(12,4)
);


CREATE TABLE "SCHEMA_NAME"."inp_curve_id" (
"id" varchar(16)   NOT NULL,
"curve_type" varchar(20)  
);


CREATE TABLE "SCHEMA_NAME"."inp_demand" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_demand_id_seq'::regclass) NOT NULL,
"node_id" varchar(16)   NOT NULL,
"demand" numeric(12,6),
"pattern_id" varchar(16)  ,
"deman_type" varchar(18)  
);


CREATE TABLE "SCHEMA_NAME"."inp_emitter" (
"node_id" varchar(16)   NOT NULL,
"coef" numeric
);


CREATE TABLE "SCHEMA_NAME"."inp_energy_el" (
"id" int4 NOT NULL,
"pump_id" varchar(16)  ,
"parameter" varchar(20)  ,
"value" varchar(30)  ,
CONSTRAINT inp_energy_el_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."inp_energy_gl" (
"id" int4 NOT NULL,
"energ_type" varchar(18)  ,
"parameter" varchar(20)  ,
"value" varchar(30)  ,
CONSTRAINT inp_energy_gl_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."inp_junction" (
"node_id" varchar(16)   NOT NULL,
"demand" numeric(12,6),
"pattern_id" varchar(16)  
);


CREATE TABLE "SCHEMA_NAME"."inp_label" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_labels_id_seq'::regclass) NOT NULL,
"xcoord" numeric(18,6),
"ycoord" numeric(18,6),
"label" varchar(50)  ,
"node_id" varchar(16)  
);


CREATE TABLE "SCHEMA_NAME"."inp_mixing" (
"node_id" varchar(16)   NOT NULL,
"mix_type" varchar(18)  ,
"value" numeric
);


CREATE TABLE "SCHEMA_NAME"."inp_options" (
"units" varchar(20)   NOT NULL,
"headloss" varchar(20)  ,
"hydraulics" varchar(12)  ,
"specific_gravity" numeric(12,6),
"viscosity" numeric(12,6),
"trials" numeric(12,6),
"accuracy" numeric(12,6),
"unbalanced" varchar(12)  ,
"checkfreq" numeric(12,6),
"maxcheck" numeric(12,6),
"damplimit" numeric(12,6),
"pattern" varchar(16)  ,
"demand_multiplier" numeric(12,6),
"emitter_exponent" numeric(12,6),
"quality" varchar(18)  ,
"diffusivity" numeric(12,6),
"tolerance" numeric(12,6),
"hydraulics_fname" varchar(254)  ,
"unbalanced_n" numeric(12,6),
"node_id" varchar(16)  
);


CREATE TABLE "SCHEMA_NAME"."inp_pattern" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_pattern_id_seq'::regclass) NOT NULL,
"pattern_id" varchar(16)   NOT NULL,
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


CREATE TABLE "SCHEMA_NAME"."inp_pipe" (
"arc_id" varchar(16)   NOT NULL,
"minorloss" numeric(12,6),
"status" varchar(12)  
);


CREATE TABLE "SCHEMA_NAME"."inp_shortpipe" (
"node_id" varchar(16)   NOT NULL,
"minorloss" numeric(12,6),
"to_arc" varchar(16)  ,
"status" varchar(12)  ,
CONSTRAINT inp_shortpipe_pkey PRIMARY KEY (node_id)
);


CREATE TABLE "SCHEMA_NAME"."inp_project_id" (
"title" varchar(254)  ,
"author" varchar(50)  ,
"date" varchar(12)  
);


CREATE TABLE "SCHEMA_NAME"."inp_pump" (
"node_id" varchar(16)   NOT NULL,
"power" varchar  ,
"curve_id" varchar  ,
"speed" numeric(12,6),
"pattern" varchar  ,
"status" varchar(12)  
);


CREATE TABLE "SCHEMA_NAME"."inp_quality" (
"node_id" varchar(16)   NOT NULL,
"initqual" numeric
);


CREATE TABLE "SCHEMA_NAME"."inp_reactions_el" (
"id" int4 NOT NULL,
"parameter" varchar(20)   NOT NULL,
"arc_id" varchar(16)  ,
"value" numeric,
CONSTRAINT inp_reactions_el_pkey PRIMARY KEY (id)

);


CREATE TABLE "SCHEMA_NAME"."inp_reactions_gl" (
"id" int4 NOT NULL,
"react_type" varchar(30)   NOT NULL,
"parameter" varchar(20)  ,
"value" numeric,
CONSTRAINT inp_reactions_gl_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."inp_report" (
"pagesize" numeric NOT NULL,
"file" varchar(254)  ,
"status" varchar(4)  ,
"summary" varchar(3)  ,
"energy" varchar(3)  ,
"nodes" varchar(254)  ,
"links" varchar(254)  ,
"elevation" varchar(16)  ,
"demand" varchar(16)  ,
"head" varchar(16)  ,
"pressure" varchar(16)  ,
"quality" varchar(16)  ,
"length" varchar(16)  ,
"diameter" varchar(16)  ,
"flow" varchar(16)  ,
"velocity" varchar(16)  ,
"headloss" varchar(16)  ,
"setting" varchar(16)  ,
"reaction" varchar(16)  ,
"f_factor" varchar(16)  
);


CREATE TABLE "SCHEMA_NAME"."inp_reservoir" (
"node_id" varchar(16)   NOT NULL,
"head" numeric(12,4),
"pattern_id" varchar(16)  
);


CREATE TABLE "SCHEMA_NAME"."inp_rules" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_rules_id_seq'::regclass) NOT NULL,
"text" varchar(254)  
);


CREATE TABLE "SCHEMA_NAME"."inp_source" (
"node_id" varchar(16)   NOT NULL,
"sourc_type" varchar(18)  ,
"quality" numeric(12,6),
"pattern_id" varchar(16)  
);


CREATE TABLE "SCHEMA_NAME"."inp_tags" (
"object" varchar(18)  ,
"node_id" varchar(16)   NOT NULL,
"tag" varchar(50)  
);


CREATE TABLE "SCHEMA_NAME"."inp_tank" (
"node_id" varchar(16)   NOT NULL,
"initlevel" numeric(12,4),
"minlevel" numeric(12,4),
"maxlevel" numeric(12,4),
"diameter" numeric(12,4),
"minvol" numeric(12,4),
"curve_id" int4
);


CREATE TABLE "SCHEMA_NAME"."inp_times" (
"duration" varchar(10)   NOT NULL,
"hydraulic_timestep" varchar(10)  ,
"quality_timestep" varchar(10)  ,
"rule_timestep" varchar(10)  ,
"pattern_timestep" varchar(10)  ,
"pattern_start" varchar(10)  ,
"report_timestep" varchar(10)  ,
"report_start" varchar(10)  ,
"start_clocktime" varchar(10)  ,
"statistic" varchar(18)  
);


CREATE TABLE "SCHEMA_NAME"."inp_valve" (
"node_id" varchar(16)   NOT NULL,
"valv_type" varchar(18)  ,
"pressure" numeric(12,4),
"diameter" numeric(12,4),
"flow" numeric(12,4),
"coef_loss" numeric(12,4),
"curve_id" int4,
"minorloss" numeric(12,4),
"status" varchar(12)  
);



CREATE TABLE "SCHEMA_NAME"."inp_typevalue_energy" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_typevalue_pump" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_typevalue_reactions_gl" (
"id" varchar(30)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_typevalue_source" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_typevalue_valve" (
"id" varchar(18)   NOT NULL,
"descript" varchar(50)  ,
"meter" varchar(18)  
);


CREATE TABLE "SCHEMA_NAME"."inp_value_ampm" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_curve" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_mixing" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_noneall" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_opti_headloss" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_opti_hyd" (
"id" varchar(20)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_opti_qual" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_opti_unb" (
"id" varchar(20)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_opti_unbal" (
"id" varchar(20)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_opti_units" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_param_energy" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_reactions_el" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_reactions_gl" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_status_pipe" (
"id" varchar(18)   NOT NULL,
CONSTRAINT inp_value_status_pipe_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."inp_value_status_pump" (
"id" varchar(18)   NOT NULL,
CONSTRAINT inp_value_status_pump_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."inp_value_status_valve" (
"id" varchar(18)   NOT NULL,
CONSTRAINT inp_value_status_valve_pkey PRIMARY KEY (id)
);

CREATE TABLE "SCHEMA_NAME"."inp_value_times" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_yesno" (
"id" varchar(3)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_yesnofull" (
"id" varchar(18)   NOT NULL
);


CREATE TABLE "SCHEMA_NAME"."inp_value_plan" (
"id" varchar(16)   NOT NULL,
"observ" varchar(254)  

);


-- ----------------------------
-- Table structure for rpt
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."rpt_arc" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_arc_id_seq'::regclass) NOT NULL,
"result_id" varchar(16)   NOT NULL,
"arc_id" varchar(16)  ,
"length" numeric,
"diameter" numeric,
"flow" numeric,
"vel" numeric,
"headloss" numeric,
"setting" numeric,
"reaction" numeric,
"ffactor" numeric,
"other" varchar(100)  ,
"time" varchar(100)  ,
"status" varchar(16)  
);


CREATE TABLE "SCHEMA_NAME"."rpt_nodearcnode" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_nodearcnode_seq'::regclass) NOT NULL,
"result_id" varchar(16)   NOT NULL,
"node_id" varchar(16)  ,
"elevation_1" numeric,
"demand_1" numeric,
"head_1" numeric,
"press_1" numeric,
"other_1" varchar(100)  ,
"time_1" varchar(100)  ,
"quality_1" numeric(12,4),
"length" numeric,
"diameter" numeric,
"flow" numeric,
"vel" numeric,
"headloss" numeric,
"setting" numeric,
"reaction" numeric,
"ffactor" numeric,
"other" varchar(100)  ,
"time" varchar(100)  ,
"status" varchar(16)  ,
"node_2" varchar(16)  ,
"elevation_2" numeric,
"demand_2" numeric,
"head_2" numeric,
"press_2" numeric,
"other_2" varchar(100)  ,
"time_2" varchar(100)  ,
"quality_2" numeric(12,4),
CONSTRAINT rpt_nodearc_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."rpt_arcnodearc" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_arcnodearc_seq'::regclass) NOT NULL,
"result_id" varchar(16)   NOT NULL,
"node_id" varchar(16)  ,
"arc_1" varchar(16)  ,
"length_1" numeric,
"diameter_1" numeric,
"flow_1" numeric,
"vel_1" numeric,
"headloss_1" numeric,
"setting_1" numeric,
"reaction_1" numeric,
"ffactor_1" numeric,
"other_1" varchar(100)  ,
"time_1" varchar(100)  ,
"status_1" varchar(16)  ,
"elevation" numeric,
"demand" numeric,
"head" numeric,
"press" numeric,
"other" varchar(100)  ,
"time" varchar(100)  ,
"quality" numeric(12,4),
"arc_2" varchar(16)  ,
"length_2" numeric,
"diameter_2" numeric,
"flow_2" numeric,
"vel_2" numeric,
"headloss_2" numeric,
"setting_2" numeric,
"reaction_2" numeric,
"ffactor_2" numeric,
"other_2" varchar(100)  ,
"time_2" varchar(100)  ,
"status_2" varchar(16)  ,
CONSTRAINT rpt_arcnodearc_pkey PRIMARY KEY (id)
);


CREATE TABLE "SCHEMA_NAME"."rpt_energy_usage" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_energy_usage_id_seq'::regclass) NOT NULL,
"result_id" varchar(16)   NOT NULL,
"node_id" varchar(16),
"usage_fact" numeric,
"avg_effic" numeric,
"kwhr_mgal" numeric,
"avg_kw" numeric,
"peak_kw" numeric,
"cost_day" numeric
);


CREATE TABLE "SCHEMA_NAME"."rpt_hydraulic_status" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_hydraulic_status_id_seq'::regclass) NOT NULL,
"result_id" varchar(16)   NOT NULL,
"time" varchar(10)  ,
"text" varchar(100)  
);


CREATE TABLE "SCHEMA_NAME"."rpt_node" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_node_id_seq'::regclass) NOT NULL,
"result_id" varchar(16)   NOT NULL,
"node_id" varchar(16)   NOT NULL,
"elevation" numeric,
"demand" numeric,
"head" numeric,
"press" numeric,
"other" varchar(100)  ,
"time" varchar(100)  ,
"quality" numeric(12,4)
);


CREATE TABLE "SCHEMA_NAME"."rpt_cat_result" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_cat_result_id_seq'::regclass) NOT NULL,
"result_id" varchar(16)   NOT NULL,
"n_junction" numeric,
"n_reservoir" numeric,
"n_tank" numeric,
"n_pipe" numeric,
"n_pump" numeric,
"n_valve" numeric,
"head_form" varchar(20)  ,
"hydra_time" varchar(10)  ,
"hydra_acc" numeric,
"st_ch_freq" numeric,
"max_tr_ch" numeric,
"dam_li_thr" numeric,
"max_trials" numeric,
"q_analysis" varchar(20)  ,
"spec_grav" numeric,
"r_kin_visc" numeric,
"r_che_diff" numeric,
"dem_multi" numeric,
"total_dura" varchar(10)  ,
"exec_date" timestamp(6) DEFAULT now(),
"q_timestep" varchar(16)  ,
"q_tolerance" varchar(16)  
);



-- ----------------------------
-- Table structure for SELECTORS
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."rpt_selector_result" (
"result_id" varchar(16)   NOT NULL
)WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."inp_selector_sector" (
"sector_id" varchar(30)   NOT NULL
)WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."inp_selector_state" (
"id" varchar(16)   NOT NULL,
"observ" varchar(254)  ,
CONSTRAINT inp_selector_state_pkey PRIMARY KEY (id),
CONSTRAINT inp_selector_state_id_fkey FOREIGN KEY (id) REFERENCES "SCHEMA_NAME".value_state (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT
);



-- ----------------------------
-- Primary Key structure
-- ----------------------------

ALTER TABLE "SCHEMA_NAME"."inp_backdrop" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_controls" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_curve" ADD PRIMARY KEY ("id");	
ALTER TABLE "SCHEMA_NAME"."inp_curve_id" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_demand" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_emitter" ADD PRIMARY KEY ("node_id");
ALTER TABLE "SCHEMA_NAME"."inp_junction" ADD PRIMARY KEY ("node_id");
ALTER TABLE "SCHEMA_NAME"."inp_label" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_mixing" ADD PRIMARY KEY ("node_id");
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD PRIMARY KEY ("units");
ALTER TABLE "SCHEMA_NAME"."inp_pattern" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_pipe" ADD PRIMARY KEY ("arc_id");
ALTER TABLE "SCHEMA_NAME"."inp_project_id" ADD PRIMARY KEY ("title");
ALTER TABLE "SCHEMA_NAME"."inp_pump" ADD PRIMARY KEY ("node_id");
ALTER TABLE "SCHEMA_NAME"."inp_quality" ADD PRIMARY KEY ("node_id");
ALTER TABLE "SCHEMA_NAME"."inp_report" ADD PRIMARY KEY ("pagesize");
ALTER TABLE "SCHEMA_NAME"."inp_reservoir" ADD PRIMARY KEY ("node_id");
ALTER TABLE "SCHEMA_NAME"."inp_rules" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_source" ADD PRIMARY KEY ("node_id");
ALTER TABLE "SCHEMA_NAME"."inp_tags" ADD PRIMARY KEY ("node_id");
ALTER TABLE "SCHEMA_NAME"."inp_tank" ADD PRIMARY KEY ("node_id");
ALTER TABLE "SCHEMA_NAME"."inp_times" ADD PRIMARY KEY ("duration");
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_energy" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_pump" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_reactions_gl" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_source" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_typevalue_valve" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_ampm" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_curve" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_mixing" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_noneall" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_headloss" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_hyd" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_qual" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_unb" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_unbal" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_opti_units" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_param_energy" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_reactions_el" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_reactions_gl" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_times" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_yesno" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_yesnofull" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_valve" ADD PRIMARY KEY ("node_id");
ALTER TABLE "SCHEMA_NAME"."rpt_selector_result" ADD PRIMARY KEY ("result_id");
ALTER TABLE "SCHEMA_NAME"."rpt_cat_result" ADD PRIMARY KEY ("result_id");
ALTER TABLE "SCHEMA_NAME"."rpt_arc" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."rpt_energy_usage" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."rpt_hydraulic_status" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."rpt_node" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_selector_sector" ADD PRIMARY KEY ("sector_id");



-- ----------------------------
-- Foreign Key system structure
-- ----------------------------

ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("epa_type") REFERENCES "SCHEMA_NAME"."inp_arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("epa_type") REFERENCES "SCHEMA_NAME"."inp_node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;



-- ----------------------------
-- Foreign Key structure
-- ----------------------------

ALTER TABLE "SCHEMA_NAME"."inp_curve" ADD FOREIGN KEY ("curve_id") REFERENCES "SCHEMA_NAME"."inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_demand" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_emitter" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_junction" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_mixing" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("units") REFERENCES "SCHEMA_NAME"."inp_value_opti_units" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("hydraulics") REFERENCES "SCHEMA_NAME"."inp_value_opti_hyd" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("headloss") REFERENCES "SCHEMA_NAME"."inp_value_opti_headloss" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("quality") REFERENCES "SCHEMA_NAME"."inp_value_opti_qual" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."inp_options" ADD FOREIGN KEY ("unbalanced") REFERENCES "SCHEMA_NAME"."inp_value_opti_unbal" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_pipe" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_pump" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

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

ALTER TABLE "SCHEMA_NAME"."inp_reservoir" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_source" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_tank" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_times" ADD FOREIGN KEY ("statistic") REFERENCES "SCHEMA_NAME"."inp_value_times" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."inp_valve" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_arc" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rpt_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_nodearcnode" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rpt_nodearcnode" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_arcnodearc" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rpt_arcnodearc" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_energy_usage" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rpt_energy_usage" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_hydraulic_status" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_node" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."rpt_node" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;





----------------
-- SPATIAL INDEX
----------------

CREATE INDEX temp_arc_index ON temp_arc USING GIST (the_geom);
CREATE INDEX temp_node_index ON temp_node USING GIST (the_geom);