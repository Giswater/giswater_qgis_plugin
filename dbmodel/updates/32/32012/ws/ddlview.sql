/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS ve_inp_pipe;
DROP VIEW IF EXISTS ve_inp_valve;
DROP VIEW IF EXISTS ve_inp_tank;
DROP VIEW IF EXISTS ve_inp_reservoir;
DROP VIEW IF EXISTS ve_inp_junction;
DROP VIEW IF EXISTS ve_inp_shortpipe;
DROP VIEW IF EXISTS ve_inp_pump;
DROP VIEW IF EXISTS ve_inp_demand;

DROP VIEW IF EXISTS v_inp_backdrop;
DROP VIEW IF EXISTS v_inp_controls;
DROP VIEW IF EXISTS v_inp_curve;
DROP VIEW IF EXISTS v_inp_emitter;
DROP VIEW IF EXISTS v_inp_energy_el;
DROP VIEW IF EXISTS v_inp_energy_gl;
DROP VIEW IF EXISTS v_inp_junction;
DROP VIEW IF EXISTS v_inp_label;
DROP VIEW IF EXISTS v_inp_mixing;
DROP VIEW IF EXISTS v_inp_options;
DROP VIEW IF EXISTS v_inp_pattern;
DROP VIEW IF EXISTS v_inp_pipe;
DROP VIEW IF EXISTS v_inp_project_id;
DROP VIEW IF EXISTS v_inp_pump;
DROP VIEW IF EXISTS v_inp_quality;
DROP VIEW IF EXISTS v_inp_reactions_el;
DROP VIEW IF EXISTS v_inp_reactions_gl;
DROP VIEW IF EXISTS v_inp_report;
DROP VIEW IF EXISTS v_inp_reservoir;
DROP VIEW IF EXISTS v_inp_rules;
DROP VIEW IF EXISTS v_inp_source;
DROP VIEW IF EXISTS v_inp_status;
DROP VIEW IF EXISTS v_inp_tags;
DROP VIEW IF EXISTS v_inp_tank;
DROP VIEW IF EXISTS v_inp_times;
DROP VIEW IF EXISTS v_inp_valve_cu;
DROP VIEW IF EXISTS v_inp_valve_fl;
DROP VIEW IF EXISTS v_inp_valve_lc;
DROP VIEW IF EXISTS v_inp_valve_pr;
DROP VIEW IF EXISTS v_inp_vertice;
DROP VIEW IF EXISTS v_inp_demand;



DROP VIEW IF EXISTS vp_basic_arc;
CREATE OR REPLACE VIEW vp_basic_arc AS 
 SELECT v_edit_arc.arc_id AS nid,
    v_edit_arc.cat_arctype_id AS custom_type
   FROM v_edit_arc;
   
  
DROP VIEW IF EXISTS vp_basic_node;
CREATE OR REPLACE VIEW vp_basic_node AS 
 SELECT v_edit_node.node_id AS nid,
    v_edit_node.nodetype_id AS custom_type
   FROM v_edit_node;
   
   
DROP VIEW IF EXISTS vp_basic_connec ;
CREATE OR REPLACE VIEW vp_basic_connec AS 
 SELECT connec_id AS nid,
    v_edit_connec.connectype_id AS custom_type
   FROM v_edit_connec;
   
   
CREATE OR REPLACE VIEW vp_epa_arc AS 
 SELECT arc.arc_id AS nid,
    arc.epa_type,
        CASE
            WHEN arc.epa_type::text = 'PIPE'::text THEN 'v_edit_inp_pipe'::text
            WHEN arc.epa_type::text = 'NOT DEFINED'::text THEN NULL::text
            ELSE NULL::text
        END AS epatable
   FROM arc;


CREATE OR REPLACE VIEW vp_epa_node AS 
 SELECT node.node_id AS nid,
    node.epa_type,
        CASE
            WHEN node.epa_type::text = 'JUNCTION'::text THEN 'v_edit_inp_junction'::text
            WHEN node.epa_type::text = 'PUMP'::text THEN 'v_edit_inp_pump'::text
            WHEN node.epa_type::text = 'RESERVOIR'::text THEN 'v_edit_inp_reservoir'::text
            WHEN node.epa_type::text = 'TANK'::text THEN 'v_edit_inp_tank'::text
            WHEN node.epa_type::text = 'VALVE'::text THEN 'v_edit_inp_valve'::text
            WHEN node.epa_type::text = 'SHORTPIPE'::text THEN 'v_edit_inp_shortpipe'::text
            WHEN node.epa_type::text = 'NOT DEFINED'::text THEN NULL::text
            ELSE NULL::text
        END AS epatable
   FROM node;


-----------------------
-- polygon views
-----------------------

DROP VIEW IF EXISTS ve_pol_tank CASCADE;
CREATE OR REPLACE VIEW ve_pol_tank AS 
SELECT 
man_tank.pol_id,
v_node.node_id,
polygon.the_geom
FROM v_node
    JOIN man_tank ON man_tank.node_id = v_node.node_id
    JOIN polygon ON polygon.pol_id=man_tank.pol_id;
    
DROP VIEW IF EXISTS ve_pol_register CASCADE;
CREATE OR REPLACE VIEW ve_pol_register AS 
SELECT 
man_register.pol_id,
v_node.node_id,
polygon.the_geom
FROM v_node
    JOIN man_register ON v_node.node_id = man_register.node_id
    JOIN polygon ON polygon.pol_id = man_register.pol_id;


DROP VIEW IF EXISTS ve_pol_fountain CASCADE;
CREATE OR REPLACE VIEW ve_pol_fountain AS 
SELECT 
man_fountain.pol_id,
connec.connec_id,
polygon.the_geom
FROM connec
    JOIN man_fountain ON man_fountain.connec_id = connec.connec_id
    JOIN polygon ON polygon.pol_id=man_fountain.pol_id;


--old views with new fields
DROP VIEW IF EXISTS v_anl_connec;
CREATE VIEW v_anl_connec AS 
 SELECT anl_connec.id,
    anl_connec.connec_id,
    anl_connec.connecat_id,
    anl_connec.state,
    anl_connec.connec_id_aux,
    anl_connec.connecat_id_aux,
    anl_connec.state_aux,
    sys_fprocess_cat.fprocess_i18n AS fprocess,
    exploitation.name AS expl_name,
    anl_connec.the_geom
   FROM selector_expl,
    anl_connec
     JOIN exploitation ON anl_connec.expl_id = exploitation.expl_id
     JOIN sys_fprocess_cat ON anl_connec.fprocesscat_id = sys_fprocess_cat.id
  WHERE anl_connec.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND anl_connec.cur_user::name = "current_user"();


-----------------------
-- plan edit views
-----------------------

DROP VIEW IF EXISTS v_ui_plan_arc_cost;
CREATE OR REPLACE VIEW v_ui_plan_arc_cost AS 
 SELECT arc.arc_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    2 AS orderby,
    'm2bottom'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mlbottom AS measurement,
    v_plan_arc.m2mlbottom * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.m2bottom_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    3 AS orderby,
    'm3protec'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlprotec AS measurement,
    v_plan_arc.m3mlprotec * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.m3protec_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    4 AS orderby,
    'm3exc'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlexc AS measurement,
    v_plan_arc.m3mlexc * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3exc_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    5 AS orderby,
    'm3fill'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlfill AS measurement,
    v_plan_arc.m3mlfill * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3fill_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    6 AS orderby,
    'm3excess'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlexcess AS measurement,
    v_plan_arc.m3mlexcess * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3excess_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    7 AS orderby,
    'm2trenchl'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mltrenchl AS measurement,
    v_plan_arc.m2mltrenchl * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m2trenchl_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    8 AS orderby,
    'pavement'::text AS identif,
    cat_pavement.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mlpav * plan_arc_x_pavement.percent AS measurement,
    v_plan_arc.m2mlpav * plan_arc_x_pavement.percent * v_price_compost.price AS total_cost
   FROM arc
     JOIN plan_arc_x_pavement ON plan_arc_x_pavement.arc_id::text = arc.arc_id::text
     JOIN cat_pavement ON cat_pavement.id::text = plan_arc_x_pavement.pavcat_id::text
     JOIN v_price_compost ON cat_pavement.m2_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT connec.arc_id,
    9 AS orderby,
    'connec'::text AS identif,
    'Various catalog'::character varying AS catalog_id,
    'Various prices'::character varying AS price_id,
    'ut'::character varying AS unit,
    'Sumatory of connecs cost related to arc. The cost is calculated in combination of parameters depth/length from connec table and catalog price from cat_connec table'::character varying AS descript,
    NULL::numeric AS cost,
    count(connec.connec_id) AS measurement,
    sum(connec.connec_length * (v_price_x_catconnec.cost_mlconnec + v_price_x_catconnec.cost_m3trench * connec.depth * 0.333) + v_price_x_catconnec.cost_ut)::numeric(12,2) AS total_cost
   FROM connec
     JOIN v_price_x_catconnec ON v_price_x_catconnec.id::text = connec.connecat_id::text
  GROUP BY connec.arc_id
  ORDER BY 1, 2;

