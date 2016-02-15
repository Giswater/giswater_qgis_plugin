/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



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


CREATE SEQUENCE "SCHEMA_NAME"."rpt_result_cat_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

	

-- ----------------------------
-- Table structure INP
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."inp_arc_type" (
"id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT inp_arc_type_pkey PRIMARY KEY (id)
) WITH (OIDS=FALSE) ;


CREATE TABLE "SCHEMA_NAME"."inp_node_type" (
"id" varchar(16) COLLATE "default" NOT NULL,
CONSTRAINT inp_arc_type_pkey PRIMARY KEY (id)
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_backdrop" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_backdrop_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_controls" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_controls_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_curve" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_curve_id_seq'::regclass) NOT NULL,
"curve_id" varchar(16) COLLATE "default" NOT NULL,
"x_value" numeric(12,4),
"y_value" numeric(12,4)
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_curve_id" (
"id" varchar(16) COLLATE "default" NOT NULL,
"curve_type" varchar(20) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_demand" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_demand_id_seq'::regclass) NOT NULL,
"node_id" varchar(16) COLLATE "default" NOT NULL,
"demand" numeric(12,6),
"pattern_id" varchar(16) COLLATE "default",
"deman_type" varchar(18) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_emitter" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"coef" numeric
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_energy_el" (
"pump_id" int4 NOT NULL,
"parameter" varchar(20) COLLATE "default",
"value" varchar(30) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_energy_gl" (
"energ_type" varchar(18) COLLATE "default",
"parameter" varchar(20) COLLATE "default",
"value" varchar(30) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_junction" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"demand" numeric(12,6),
"pattern_id" varchar(16) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_label" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_labels_id_seq'::regclass) NOT NULL,
"xcoord" numeric(18,6),
"ycoord" numeric(18,6),
"label" varchar(50) COLLATE "default",
"node_id" varchar(16) COLLATE "default"
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_mixing" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"mix_type" varchar(18) COLLATE "default",
"value" numeric
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_options" (
"units" varchar(20) COLLATE "default" NOT NULL,
"headloss" varchar(20) COLLATE "default",
"hydraulics" varchar(12) COLLATE "default",
"specific_gravity" numeric(12,6),
"viscosity" numeric(12,6),
"trials" numeric(12,6),
"accuracy" numeric(12,6),
"unbalanced" varchar(12) COLLATE "default",
"checkfreq" numeric(12,6),
"maxcheck" numeric(12,6),
"damplimit" numeric(12,6),
"pattern" varchar(16) COLLATE "default",
"demand_multiplier" numeric(12,6),
"emitter_exponent" numeric(12,6),
"quality" varchar(18) COLLATE "default",
"diffusivity" numeric(12,6),
"tolerance" numeric(12,6),
"hydraulics_fname" varchar(254) COLLATE "default",
"unbalanced_n" numeric(12,6),
"node_id" varchar(16) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_pattern" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_pattern_id_seq'::regclass) NOT NULL,
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

) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_pipe" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"minorloss" numeric(12,6),
"status" varchar(12) COLLATE "default"
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_project_id" (
"title" varchar(254) COLLATE "default",
"author" varchar(50) COLLATE "default",
"date" varchar(12) COLLATE "default"
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_pump" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"power" varchar COLLATE "default",
"curve_id" varchar COLLATE "default",
"speed" numeric(12,6),
"pattern" varchar COLLATE "default",
"status" varchar(12) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_quality" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"initqual" numeric
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_reactions_el" (
"parameter" varchar(20) COLLATE "default" NOT NULL,
"arc_id" varchar(16) COLLATE "default",
"value" numeric
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_reactions_gl" (
"react_type" varchar(30) COLLATE "default" NOT NULL,
"parameter" varchar(20) COLLATE "default",
"value" numeric
) WITH (OIDS=FALSE) ;




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
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_reservoir" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"head" numeric(12,4),
"pattern_id" varchar(16) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_rules" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".inp_rules_id_seq'::regclass) NOT NULL,
"text" varchar(254) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_source" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"sourc_type" varchar(18) COLLATE "default",
"quality" numeric(12,6),
"pattern_id" varchar(16) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_tags" (
"object" varchar(18) COLLATE "default",
"node_id" varchar(16) COLLATE "default" NOT NULL,
"tag" varchar(50) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_tank" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"initlevel" numeric(12,4),
"minlevel" numeric(12,4),
"maxlevel" numeric(12,4),
"diameter" numeric(12,4),
"minvol" numeric(12,4),
"curve_id" int4
) WITH (OIDS=FALSE) ;




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
) WITH (OIDS=FALSE) ;





CREATE TABLE "SCHEMA_NAME"."inp_typevalue_energy" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_typevalue_pump" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_typevalue_reactions_gl" (
"id" varchar(30) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_typevalue_source" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_typevalue_valve" (
"id" varchar(18) COLLATE "default" NOT NULL,
"descript" varchar(50) COLLATE "default",
"meter" varchar(18) COLLATE "default"
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_value_ampm" (
"id" varchar(18) COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;




CREATE TABLE "SCHEMA_NAME"."inp_value_curve" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_value_mixing" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_value_noneall" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_value_opti_headloss" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_value_opti_hyd" (
"id" varchar(20) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_value_opti_qual" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_value_opti_unb" (
"id" varchar(20) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_value_opti_unbal" (
"id" varchar(20) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_value_opti_units" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_value_param_energy" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_value_reactions_el" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_value_reactions_gl" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_value_st_pipe" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."inp_value_status" (
"id" varchar(16) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_value_times" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_value_yesno" (
"id" varchar(3) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;




CREATE TABLE "SCHEMA_NAME"."inp_value_yesnofull" (
"id" varchar(18) COLLATE "default" NOT NULL
) WITH (OIDS=FALSE) ;





CREATE TABLE "SCHEMA_NAME"."inp_value_plan" (
"id" varchar(16) COLLATE "default" NOT NULL,
"observ" varchar(254) COLLATE "default"

) WITH (OIDS=FALSE) ;





CREATE TABLE "SCHEMA_NAME"."inp_valve" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"valv_type" varchar(18) COLLATE "default",
"pressure" numeric(12,4),
"flow" numeric(12,4),
"coef_loss" numeric(12,4),
"curve_id" int4,
"minorloss" numeric(12,4),
"status" varchar(12) COLLATE "default"
) WITH (OIDS=FALSE) ;




-- ----------------------------
-- Table structure for rpt
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
"time" varchar(100) COLLATE "default",
"status" varchar(16) COLLATE "default"
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."rpt_energy_usage" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_energy_usage_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"pump_id" varchar(16),
"usage_fact" numeric,
"avg_effic" numeric,
"kwhr_mgal" numeric,
"avg_kw" numeric,
"peak_kw" numeric,
"cost_day" numeric
) WITH (OIDS=FALSE) ;


CREATE TABLE "SCHEMA_NAME"."rpt_hydraulic_status" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_hydraulic_status_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"time" varchar(10) COLLATE "default",
"text" varchar(100) COLLATE "default"
) WITH (OIDS=FALSE) ;



CREATE TABLE "SCHEMA_NAME"."rpt_node" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".rpt_node_id_seq'::regclass) NOT NULL,
"result_id" varchar(16) COLLATE "default" NOT NULL,
"node_id" varchar(16) COLLATE "default" NOT NULL,
"elevation" numeric,
"demand" numeric,
"head" numeric,
"press" numeric,
"other" varchar(100) COLLATE "default",
"time" varchar(100) COLLATE "default",
"quality" numeric(12,4)
) WITH (OIDS=FALSE) ;



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
"exec_date" timestamp(6) DEFAULT now(),
"q_timestep" varchar(16) COLLATE "default",
"q_tolerance" varchar(16) COLLATE "default"
) WITH (OIDS=FALSE) ;






-- ----------------------------
-- Table structure for SELECTORS
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."result_selection" (
"result_id" varchar(16) COLLATE "default" NOT NULL
)WITH (OIDS=FALSE)
;



CREATE TABLE "SCHEMA_NAME"."sector_selection" (
"sector_id" varchar(30) COLLATE "default" NOT NULL
)WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."state_selection" (
"id" varchar(16) COLLATE "default" NOT NULL,
"observ" varchar(254) COLLATE "default",
CONSTRAINT state_selection_pkey PRIMARY KEY (id)
  CONSTRAINT state_selection_id_fkey FOREIGN KEY (id) REFERENCES "SCHEMA_NAME".value_state (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT
)WITH (OIDS=FALSE)
;








-- ----------------------------
-- View structure for v_arc_x_node
-- ----------------------------
CREATE OR REPLACE VIEW SCHEMA_NAME.v_arc_x_node1 AS 
 SELECT arc.arc_id, arc.node_1, 
node.elevation AS elevation1, 
node.depth AS depth1,
(cat_arc.dext)/1000 AS dext, 
node.depth - (cat_arc.dext)/1000 AS r1
 FROM SCHEMA_NAME.arc
JOIN SCHEMA_NAME.node ON arc.node_1::text = node.node_id::text
JOIN SCHEMA_NAME.cat_arc ON arc.arccat_id::text = cat_arc.id::text AND arc.arccat_id::text = cat_arc.id::text;




CREATE OR REPLACE VIEW SCHEMA_NAME.v_arc_x_node2 AS 
 SELECT arc.arc_id, arc.node_2, 
node.elevation AS elevation2, 
node.depth AS depth2,
(cat_arc.dext)/1000 AS dext, 
node.depth - (cat_arc.dext)/1000 AS r2
  FROM SCHEMA_NAME.arc
JOIN SCHEMA_NAME.node ON arc.node_2::text = node.node_id::text
JOIN SCHEMA_NAME.cat_arc ON arc.arccat_id::text = cat_arc.id::text AND arc.arccat_id::text = cat_arc.id::text;



CREATE OR REPLACE VIEW SCHEMA_NAME.v_inp_arc_x_node AS 
 SELECT 
v_arc_x_node1.arc_id,
v_arc_x_node1.node_1,
v_arc_x_node1.elevation1,
v_arc_x_node1.depth1,
v_arc_x_node1.r1,
v_arc_x_node2.node_2,
v_arc_x_node2.elevation2,
v_arc_x_node2.depth2,
v_arc_x_node2.r2,
arc."state",
arc.sector_id,
arc.the_geom
FROM SCHEMA_NAME.v_arc_x_node1
   JOIN SCHEMA_NAME.v_arc_x_node2 ON v_arc_x_node1.arc_id::text = v_arc_x_node2.arc_id::text
   JOIN SCHEMA_NAME.arc ON v_arc_x_node2.arc_id::text = arc.arc_id::text; 
   




-- ----------------------------
-- View structure for v_inp
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_curve" AS 
SELECT inp_curve.curve_id, inp_curve.x_value, inp_curve.y_value FROM SCHEMA_NAME.inp_curve ORDER BY inp_curve.id;


CREATE VIEW "SCHEMA_NAME"."v_inp_energy_el" AS 
SELECT 'PUMP'::text AS type_pump, inp_energy_el.pump_id, inp_energy_el.parameter, inp_energy_el.value FROM SCHEMA_NAME.inp_energy_el;


CREATE VIEW "SCHEMA_NAME"."v_inp_options" AS 
SELECT inp_options.units, inp_options.headloss, (((inp_options.hydraulics)::text || ' '::text) || (inp_options.hydraulics_fname)::text) AS hydraulics, inp_options.specific_gravity AS "specific gravity", inp_options.viscosity, inp_options.trials, inp_options.accuracy, (((inp_options.unbalanced)::text || ' '::text) || (inp_options.unbalanced_n)::text) AS unbalanced, inp_options.checkfreq, inp_options.maxcheck, inp_options.damplimit, inp_options.pattern, inp_options.demand_multiplier AS "demand multiplier", inp_options.emitter_exponent AS "emitter exponent", CASE WHEN inp_options.quality::text = 'TRACE'::text THEN ((inp_options.quality::text || ' '::text) || inp_options.node_id::text)::character varying ELSE inp_options.quality END AS quality, inp_options.diffusivity, inp_options.tolerance FROM SCHEMA_NAME.inp_options;


CREATE VIEW "SCHEMA_NAME"."v_inp_report" AS 
SELECT inp_report.pagesize,inp_report.status,inp_report.summary,inp_report.energy,inp_report.nodes,inp_report.links,inp_report.elevation,inp_report.demand,inp_report.head,inp_report.pressure,inp_report.quality,inp_report."length",inp_report.diameter,inp_report.flow,inp_report.velocity,inp_report.headloss,inp_report.setting,inp_report.reaction,inp_report.f_factor AS "f-factor" FROM SCHEMA_NAME.inp_report;


CREATE VIEW "SCHEMA_NAME"."v_inp_rules" AS 
SELECT inp_rules.text FROM SCHEMA_NAME.inp_rules ORDER BY inp_rules.id;


CREATE VIEW "SCHEMA_NAME"."v_inp_times" AS 
SELECT inp_times.duration, inp_times.hydraulic_timestep AS "hydraulic timestep", inp_times.quality_timestep AS "quality timestep", inp_times.rule_timestep AS "rule timestep", inp_times.pattern_timestep AS "pattern timestep", inp_times.pattern_start AS "pattern start", inp_times.report_timestep AS "report timestep", inp_times.report_start AS "report start", inp_times.start_clocktime AS "start clocktime", inp_times.statistic FROM SCHEMA_NAME.inp_times;






-- ------------------------------------------------------------------
-- View structure for v_inp ARC & NODE  (SELECTED BY STATE SELECTION)
-- ------------------------------------------------------------------


CREATE VIEW "SCHEMA_NAME"."v_inp_mixing" AS 
SELECT inp_mixing.node_id, inp_mixing.mix_type, inp_mixing.value, sector_selection.sector_id 
FROM (((SCHEMA_NAME.inp_mixing JOIN SCHEMA_NAME.node ON (((inp_mixing.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_demand" AS 
SELECT inp_demand.node_id, inp_demand.demand, inp_demand.pattern_id, inp_demand.deman_type, sector_selection.sector_id FROM (((SCHEMA_NAME.inp_demand 
JOIN SCHEMA_NAME.node ON (((inp_demand.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_source" AS 
SELECT inp_source.node_id, inp_source.sourc_type, inp_source.quality, inp_source.pattern_id, sector_selection.sector_id FROM (((SCHEMA_NAME.inp_source JOIN SCHEMA_NAME.node ON (((inp_source.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_status" AS 
SELECT inp_valve.arc_id, inp_valve.status FROM ((SCHEMA_NAME.inp_valve
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)))
WHERE inp_valve.status::text = 'OPEN'::text OR inp_valve.status::text = 'CLOSED'::text;


CREATE VIEW "SCHEMA_NAME"."v_inp_status_pump" AS 
SELECT inp_pump.arc_id, inp_pump.status FROM ((SCHEMA_NAME.inp_pump 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)))
WHERE inp_pump.status::text = 'OPEN'::text OR inp_pump.status::text = 'CLOSED'::text;



CREATE VIEW "SCHEMA_NAME"."v_inp_emitter" AS 
SELECT inp_emitter.node_id, inp_emitter.coef, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id 
FROM (((SCHEMA_NAME.inp_emitter 
JOIN SCHEMA_NAME.node ON (((inp_emitter.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text))); 



CREATE VIEW "SCHEMA_NAME"."v_inp_junction" AS 
SELECT inp_junction.node_id, (node.elevation-node."depth")::numeric(12,4), elevation, inp_junction.demand, inp_junction.pattern_id, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id 
FROM (((SCHEMA_NAME.inp_junction JOIN SCHEMA_NAME.node ON ((((inp_junction.node_id)::text = (node.node_id)::text) AND ((inp_junction.node_id)::text = (node.node_id)::text)))) 
JOIN SCHEMA_NAME.sector_selection ON ((((node.sector_id)::text = (sector_selection.sector_id)::text) AND ((node.sector_id)::text = (sector_selection.sector_id)::text))))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)))  
ORDER BY inp_junction.node_id;




CREATE VIEW "SCHEMA_NAME"."v_inp_reservoir" AS 
SELECT inp_reservoir.node_id, inp_reservoir.head, inp_reservoir.pattern_id, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id 
FROM (((SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_reservoir ON (((inp_reservoir.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text))) ;




CREATE VIEW "SCHEMA_NAME"."v_inp_tank" AS 
SELECT inp_tank.node_id, node.elevation, inp_tank.initlevel, inp_tank.minlevel, inp_tank.maxlevel, inp_tank.diameter, inp_tank.minvol, inp_tank.curve_id, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id 
FROM (((SCHEMA_NAME.inp_tank JOIN SCHEMA_NAME.node ON (((inp_tank.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text))) ;



CREATE VIEW "SCHEMA_NAME"."v_inp_pipe" AS 
SELECT arc.arc_id, arc.node_1, arc.node_2, (st_length2d(arc.the_geom))::numeric(16,3) AS length, cat_arc.dint AS diameter, cat_mat.roughness, inp_pipe.minorloss, inp_pipe.status, sector_selection.sector_id 
FROM (((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_pipe ON (((arc.arc_id)::text = (inp_pipe.arc_id)::text)))
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)))  
JOIN SCHEMA_NAME.cat_mat ON (((cat_arc.matcat_id)::text = (cat_mat.id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((arc."state")::text = (state_selection.id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text)));



CREATE VIEW "SCHEMA_NAME"."v_inp_pump" AS 
SELECT inp_pump.arc_id, arc.node_1, arc.node_2, (('POWER'::text || ' '::text) || (inp_pump.power)::text) AS power, (('HEAD'::text || ' '::text) || (inp_pump.curve_id)::text) AS head, (('SPEED'::text || ' '::text) || inp_pump.speed) AS speed, (('PATTERN'::text || ' '::text) || (inp_pump.pattern)::text) AS pattern, sector_selection.sector_id 
FROM (((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_pump ON (((arc.arc_id)::text = (inp_pump.arc_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((arc."state")::text = (state_selection.id)::text)));



CREATE VIEW "SCHEMA_NAME"."v_inp_valve_cu" AS 
SELECT inp_valve.arc_id, arc.node_1, arc.node_2, cat_arc.dint AS diameter, inp_valve.valv_type, inp_valve.curve_id, inp_valve.minorloss, sector_selection.sector_id 
FROM ((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_valve ON (((arc.arc_id)::text = (inp_valve.arc_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((arc."state")::text = (state_selection.id)::text)))  
WHERE ((inp_valve.valv_type)::text = 'GPV'::text);



CREATE VIEW "SCHEMA_NAME"."v_inp_valve_fl" AS 
SELECT inp_valve.arc_id, arc.node_1, arc.node_2, cat_arc.dint AS diameter, inp_valve.valv_type, inp_valve.flow, inp_valve.minorloss, sector_selection.sector_id 
FROM ((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_valve ON (((arc.arc_id)::text = (inp_valve.arc_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) 
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((arc."state")::text = (state_selection.id)::text)))
WHERE ((inp_valve.valv_type)::text = 'FCV'::text);



CREATE VIEW "SCHEMA_NAME"."v_inp_valve_lc" AS 
SELECT inp_valve.arc_id, arc.node_1, arc.node_2, cat_arc.dint AS diameter, inp_valve.valv_type, inp_valve.coef_loss, inp_valve.minorloss, sector_selection.sector_id 
FROM ((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_valve ON (((arc.arc_id)::text = (inp_valve.arc_id)::text)))
JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) 
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((arc."state")::text = (state_selection.id)::text))) 
WHERE ((inp_valve.valv_type)::text = 'TCV'::text);



CREATE VIEW "SCHEMA_NAME"."v_inp_valve_pr" AS 
SELECT inp_valve.arc_id, arc.node_1, arc.node_2, cat_arc.dint AS diameter, inp_valve.valv_type, inp_valve.pressure, inp_valve.minorloss, sector_selection.sector_id 
FROM ((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_valve ON (((arc.arc_id)::text = (inp_valve.arc_id)::text)))
JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))) 
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((arc."state")::text = (state_selection.id)::text)))
WHERE ((((inp_valve.valv_type)::text = 'PRV'::text) OR ((inp_valve.valv_type)::text = 'PSV'::text)) OR ((inp_valve.valv_type)::text = 'PBV'::text));



CREATE OR REPLACE VIEW SCHEMA_NAME.v_inp_vertice AS 
 SELECT nextval('SCHEMA_NAME.inp_vertice_id_seq'::regclass) AS id,
    arc.arc_id,
    st_x(arc.point)::numeric(16,3) AS xcoord,
    st_y(arc.point)::numeric(16,3) AS ycoord
   FROM (( SELECT (st_dumppoints(arc_1.the_geom)).geom AS point,
            st_startpoint(arc_1.the_geom) AS startpoint,
            st_endpoint(arc_1.the_geom) AS endpoint,
            arc_1.sector_id,
			arc_1."state",
            arc_1.arc_id
           FROM SCHEMA_NAME.arc arc_1) arc
   JOIN SCHEMA_NAME.sector_selection ON arc.sector_id::text = sector_selection.sector_id::text
   JOIN SCHEMA_NAME.state_selection ON (((arc."state")::text = (state_selection.id)::text)))
  WHERE (arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint)
  ORDER BY nextval('SCHEMA_NAME.inp_vertice_id_seq'::regclass);








-- ----------------------------
-- View structure for v_rpt_
-- ----------------------------


CREATE VIEW "SCHEMA_NAME"."v_rpt_arc" AS 
SELECT arc.arc_id, result_selection.result_id, max(rpt_arc.flow) AS max_flow, min(rpt_arc.flow) AS min_flow, max(rpt_arc.vel) AS max_vel, min(rpt_arc.vel) AS min_vel, max(rpt_arc.headloss) AS max_headloss, min(rpt_arc.headloss) AS min_headloss, max(rpt_arc.setting) AS max_setting, min(rpt_arc.setting) AS min_setting, max(rpt_arc.reaction) AS max_reaction, min(rpt_arc.reaction) AS min_reaction, max(rpt_arc.ffactor) AS max_ffactor, min(rpt_arc.ffactor) AS min_ffactor, arc.the_geom FROM ((SCHEMA_NAME.arc JOIN SCHEMA_NAME.rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text))) JOIN SCHEMA_NAME.result_selection ON (((rpt_arc.result_id)::text = (result_selection.result_id)::text))) GROUP BY arc.arc_id, result_selection.result_id, arc.the_geom ORDER BY arc.arc_id;


CREATE VIEW "SCHEMA_NAME"."v_rpt_energy_usage" AS 
SELECT rpt_energy_usage.id, rpt_energy_usage.result_id, rpt_energy_usage.pump_id, rpt_energy_usage.usage_fact, rpt_energy_usage.avg_effic, rpt_energy_usage.kwhr_mgal, rpt_energy_usage.avg_kw, rpt_energy_usage.peak_kw, rpt_energy_usage.cost_day FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_energy_usage ON (((result_selection.result_id)::text = (rpt_energy_usage.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_hydraulic_status" AS 
SELECT rpt_hydraulic_status.id, rpt_hydraulic_status.result_id, rpt_hydraulic_status."time", rpt_hydraulic_status.text FROM (SCHEMA_NAME.rpt_hydraulic_status JOIN SCHEMA_NAME.result_selection ON (((result_selection.result_id)::text = (rpt_hydraulic_status.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_node" AS 
SELECT node.node_id, result_selection.result_id, max(rpt_node.elevation) AS elevation, max(rpt_node.demand) AS max_demand, min(rpt_node.demand) AS min_demand, max(rpt_node.head) AS max_head, min(rpt_node.head) AS min_head, max(rpt_node.press) AS max_pressure, min(rpt_node.press) AS min_pressure, max(rpt_node.quality) AS max_quality, min(rpt_node.quality) AS min_quality, node.the_geom FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.result_selection ON (((rpt_node.result_id)::text = (result_selection.result_id)::text))) GROUP BY node.node_id, result_selection.result_id, node.the_geom ORDER BY node.node_id;





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
ALTER TABLE "SCHEMA_NAME"."inp_pump" ADD PRIMARY KEY ("arc_id");
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
ALTER TABLE "SCHEMA_NAME"."inp_value_st_pipe" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_status" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_times" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_yesno" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_value_yesnofull" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."inp_valve" ADD PRIMARY KEY ("arc_id");
ALTER TABLE "SCHEMA_NAME"."result_selection" ADD PRIMARY KEY ("result_id");
ALTER TABLE "SCHEMA_NAME"."rpt_result_cat" ADD PRIMARY KEY ("result_id");
ALTER TABLE "SCHEMA_NAME"."rpt_arc" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."rpt_energy_usage" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."rpt_hydraulic_status" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."rpt_node" ADD PRIMARY KEY ("id");
ALTER TABLE "SCHEMA_NAME"."sector_selection" ADD PRIMARY KEY ("sector_id");





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

ALTER TABLE "SCHEMA_NAME"."inp_pump" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

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

ALTER TABLE "SCHEMA_NAME"."inp_valve" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_arc" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_energy_usage" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_hydraulic_status" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."rpt_node" ADD FOREIGN KEY ("result_id") REFERENCES "SCHEMA_NAME"."rpt_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

