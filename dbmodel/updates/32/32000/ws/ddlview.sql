/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_edit_typevalue AS 
 SELECT row_number() OVER (ORDER BY cat_arc.id) + 1000 AS rid,
    'cat_arc'::text AS catalog,
    cat_arc.id,
    cat_arc.id AS idval
   FROM cat_arc
UNION
 SELECT row_number() OVER (ORDER BY cat_builder.id) + 2000 AS rid,
    'cat_builder'::text AS catalog,
    cat_builder.id,
    cat_builder.descript AS idval
   FROM cat_builder
UNION
 SELECT row_number() OVER (ORDER BY cat_element.id) + 3000 AS rid,
    'cat_element'::text AS catalog,
    cat_element.id,
    cat_element.id AS idval
   FROM cat_element
UNION
 SELECT row_number() OVER (ORDER BY cat_node.id) + 4000 AS rid,
    'cat_node'::text AS catalog,
    cat_node.id,
    cat_node.id AS idval
   FROM cat_node
UNION
 SELECT row_number() OVER (ORDER BY cat_owner.id) + 5000 AS rid,
    'cat_owner'::text AS catalog,
    cat_owner.id,
    cat_owner.descript AS idval
   FROM cat_owner
UNION
 SELECT row_number() OVER (ORDER BY cat_presszone.id) + 6000 AS rid,
    'cat_presszone'::text AS catalog,
    cat_presszone.id,
    cat_presszone.descript AS idval
   FROM cat_presszone
UNION
 SELECT row_number() OVER (ORDER BY cat_soil.id) + 7000 AS rid,
    'cat_soil'::text AS catalog,
    cat_soil.id,
    cat_soil.descript AS idval
   FROM cat_soil
UNION
 SELECT row_number() OVER (ORDER BY cat_work.id) + 8000 AS rid,
    'cat_work'::text AS catalog,
    cat_work.id,
    cat_work.descript AS idval
   FROM cat_work
UNION
 SELECT row_number() OVER (ORDER BY ext_streetaxis.id) + 9000 AS rid,
    'ext_streetaxis'::text AS catalog,
    ext_streetaxis.id,
    ext_streetaxis.name AS idval
   FROM ext_streetaxis
UNION
 SELECT row_number() OVER (ORDER BY ext_plot.id) + 10000 AS rid,
    'ext_plot'::text AS catalog,
    ext_plot.id,
    ext_plot.postnumber AS idval
   FROM ext_plot
UNION
 SELECT row_number() OVER (ORDER BY man_type_category.id) + 11000 AS rid,
    concat('category_', lower(man_type_category.feature_type::text)) AS catalog,
    man_type_category.id::character varying AS id,
    man_type_category.category_type AS idval
   FROM man_type_category
UNION
 SELECT row_number() OVER (ORDER BY man_type_fluid.id) + 12000 AS rid,
    'man_type_function'::text AS catalog,
    man_type_fluid.id::character varying AS id,
    man_type_fluid.fluid_type AS idval
   FROM man_type_fluid
UNION
 SELECT row_number() OVER (ORDER BY man_type_function.id) + 13000 AS rid,
    'man_type_location'::text AS catalog,
    man_type_function.id::character varying AS id,
    man_type_function.function_type AS idval
   FROM man_type_function
UNION
 SELECT row_number() OVER (ORDER BY man_type_location.id) + 14000 AS rid,
    'cat_builder'::text AS catalog,
    man_type_location.id::character varying AS id,
    man_type_location.location_type AS idval
   FROM man_type_location
UNION
 SELECT row_number() OVER (ORDER BY value_state.id) + 15000 AS rid,
    'value_state'::text AS catalog,
    value_state.id::character varying AS id,
    value_state.name AS idval
   FROM value_state
UNION
 SELECT row_number() OVER (ORDER BY value_state_type.id) + 16000 AS rid,
    'value_state_type'::text AS catalog,
    value_state_type.id::character varying AS id,
    value_state_type.name AS idval
   FROM value_state_type
UNION
 SELECT row_number() OVER (ORDER BY value_verified.id) + 17000 AS rid,
    'value_verified'::text AS catalog,
    value_verified.id,
    value_verified.id AS idval
   FROM value_verified
  ORDER BY 2, 4;

  

 
 
-----------------------
-- inp edit views
-----------------------
DROP VIEW IF EXISTS ve_inp_demand;
CREATE VIEW ve_inp_demand AS 
 SELECT inp_demand.id,
    node.node_id,
    inp_demand.demand,
    inp_demand.pattern_id,
    inp_demand.deman_type,
    inp_demand.dscenario_id
   FROM inp_selector_sector,
    inp_selector_dscenario,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_demand ON inp_demand.node_id::text = node.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text 
  AND inp_demand.dscenario_id = inp_selector_dscenario.dscenario_id AND inp_selector_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_inp_junction;
CREATE VIEW ve_inp_junction AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_junction.demand,
    inp_junction.pattern_id
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_junction ON inp_junction.node_id::text = node.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_inp_pipe;
CREATE VIEW ve_inp_pipe AS 
 SELECT arc.arc_id,
    arc.arccat_id,
    arc.sector_id,
    v_arc.macrosector_id,
    arc.state,
    arc.annotation,
    arc.custom_length,
    arc.the_geom,
    inp_pipe.minorloss,
    inp_pipe.status,
    inp_pipe.custom_roughness,
    inp_pipe.custom_dint
   FROM inp_selector_sector,
    arc
     JOIN v_arc ON v_arc.arc_id::text = arc.arc_id::text
     JOIN inp_pipe ON inp_pipe.arc_id::text = arc.arc_id::text
  WHERE arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS ve_inp_pump;
CREATE VIEW ve_inp_pump AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_pump ON node.node_id::text = inp_pump.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS ve_inp_reservoir;
CREATE VIEW ve_inp_reservoir AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_reservoir.pattern_id
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_reservoir ON inp_reservoir.node_id::text = node.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_inp_shortpipe;
CREATE VIEW ve_inp_shortpipe AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_shortpipe.minorloss,
    inp_shortpipe.to_arc,
    inp_shortpipe.status
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_shortpipe ON inp_shortpipe.node_id::text = node.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_inp_tank;
CREATE VIEW ve_inp_tank AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_tank ON inp_tank.node_id::text = node.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_inp_valve;
CREATE VIEW ve_inp_valve AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_valve ON node.node_id::text = inp_valve.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


	 
-- ----------------------------
-- View structure for v_inp
-- ----------------------------

CREATE OR REPLACE VIEW vi_title AS 
 SELECT inp_project_id.title,
    inp_project_id.date
   FROM inp_project_id
  ORDER BY inp_project_id.title;


CREATE OR REPLACE VIEW vi_junctions AS 
SELECT 
rpt_inp_node.node_id, 
elev as elevation, 
rpt_inp_node.demand, 
rpt_inp_node.pattern_id
FROM inp_selector_result, rpt_inp_node
   LEFT JOIN inp_junction ON inp_junction.node_id = rpt_inp_node.node_id
   WHERE epa_type IN ('JUNCTION', 'SHORTPIPE') AND rpt_inp_node.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"()
   ORDER BY rpt_inp_node.node_id;


CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT inp_reservoir.node_id,
    rpt_inp_node.elevation AS head,
    inp_reservoir.pattern_id
   FROM inp_selector_result, inp_reservoir
   JOIN rpt_inp_node ON inp_reservoir.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT inp_tank.node_id,
    rpt_inp_node.elevation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
   FROM inp_selector_result, inp_tank
   JOIN rpt_inp_node ON inp_tank.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_pipes AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
    inp_pipe.minorloss,
    inp_typevalue.idval as status
   FROM inp_selector_result, rpt_inp_arc
   JOIN inp_pipe ON rpt_inp_arc.arc_id::text = inp_pipe.arc_id::text
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_pipe.status
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text 
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
    inp_shortpipe.minorloss,
    inp_typevalue.idval as status
   FROM inp_selector_result, rpt_inp_arc
   JOIN inp_shortpipe ON rpt_inp_arc.arc_id::text = concat(inp_shortpipe.node_id, '_n2a')
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_shortpipe.status
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


 
CREATE OR REPLACE VIEW vi_pumps AS 
SELECT arc_id::text,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    ('POWER'::text || ' '::text) || inp_pump.power::text AS power,
    ('HEAD'::text || ' '::text) || inp_pump.curve_id::text AS head,
    ('SPEED'::text || ' '::text) || inp_pump.speed AS speed,
    ('PATTERN'::text || ' '::text) || inp_pump.pattern::text AS pattern
   FROM inp_selector_result, inp_pump
     JOIN rpt_inp_arc ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
SELECT arc_id::text,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    ('POWER'::text || ' '::text) || inp_pump.power::text AS power,
    ('HEAD'::text || ' '::text) || inp_pump.curve_id::text AS head,
    ('SPEED'::text || ' '::text) || inp_pump.speed AS speed,
    ('PATTERN'::text || ' '::text) || inp_pump.pattern::text AS pattern
   FROM inp_selector_result, inp_pump
     JOIN rpt_inp_arc ON rpt_inp_arc.flw_code::text = concat(inp_pump.node_id, '_n2a')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;

 
  
CREATE OR REPLACE VIEW vi_valves AS 
SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.pressure::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result,rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE (inp_valve.valv_type::text = 'PRV'::text OR inp_valve.valv_type::text = 'PSV'::text OR inp_valve.valv_type::text = 'PBV'::text) 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.flow::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE inp_valve.valv_type::text = 'FCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.coef_loss::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE inp_valve.valv_type::text = 'TCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    cat_arc.dint AS diameter,
    inp_valve.valv_type,
    inp_valve.curve_id::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result, rpt_inp_arc
    JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
    JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
WHERE inp_valve.valv_type::text = 'GPV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
AND inp_selector_result.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_tags AS 
SELECT inp_tags.object,
   inp_tags.node_id,
   inp_tags.tag
FROM inp_tags
ORDER BY inp_tags.object;

DROP VIEW IF EXISTS vi_demands CASCADE;
CREATE OR REPLACE VIEW vi_demands AS 
SELECT inp_demand.node_id,
   inp_demand.demand,
   inp_demand.pattern_id,
   inp_demand.deman_type
 FROM inp_selector_dscenario, inp_selector_result, inp_demand
 JOIN rpt_inp_node ON inp_demand.node_id::text = rpt_inp_node.node_id::text
WHERE inp_selector_dscenario.dscenario_id = inp_demand.dscenario_id AND inp_selector_dscenario.cur_user = "current_user"()::text 
AND inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_status AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.status
   FROM inp_selector_result,  rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE rpt_inp_arc.status::text = 'OPEN'::text OR rpt_inp_arc.status::text = 'CLOSED'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_pump.status
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
  WHERE inp_pump.status::text = 'OPEN'::text OR inp_pump.status::text = 'CLOSED'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text
   AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_pump_additional.status
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_pump_additional ON rpt_inp_arc.arc_id::text = concat(inp_pump_additional.node_id, '_n2a', inp_pump_additional.order_id)
  WHERE inp_pump_additional.status::text = 'OPEN'::text OR inp_pump_additional.status::text = 'CLOSED'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_patterns AS 
 SELECT inp_pattern_value.pattern_id,
    concat(inp_pattern_value.factor_1,' ',inp_pattern_value.factor_2,' ',inp_pattern_value.factor_3,' ',inp_pattern_value.factor_4,' ',
    inp_pattern_value.factor_5,' ',inp_pattern_value.factor_6,' ',inp_pattern_value.factor_7,' ',inp_pattern_value.factor_8,' ',
    inp_pattern_value.factor_9,' ',inp_pattern_value.factor_10,' ',inp_pattern_value.factor_11,' ', inp_pattern_value.factor_12,' ',
    inp_pattern_value.factor_13,' ', inp_pattern_value.factor_14,' ',inp_pattern_value.factor_15,' ', inp_pattern_value.factor_16,' ',
    inp_pattern_value.factor_17,' ', inp_pattern_value.factor_18) as multipliers
   FROM inp_pattern_value
  ORDER BY inp_pattern_value.pattern_id;


CREATE OR REPLACE VIEW vi_curves AS 
SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value
   FROM ( SELECT DISTINCT ON (inp_curve.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve sub
                  WHERE sub.curve_id::text = inp_curve.curve_id::text) AS id,
            inp_curve.curve_id,
            concat(';', inp_curve_id.curve_type, ':') AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve_id
             JOIN inp_curve ON inp_curve.curve_id::text = inp_curve_id.id::text
        UNION
         SELECT inp_curve.id,
            inp_curve.curve_id,
            inp_curve_id.curve_type,
            inp_curve.x_value,
            inp_curve.y_value
           FROM inp_curve
             JOIN inp_curve_id ON inp_curve.curve_id::text = inp_curve_id.id::text
  ORDER BY 1, 4 DESC) a;


CREATE OR REPLACE VIEW vi_controls AS 
SELECT  text
   FROM ( SELECT a.id,
            a.text
           FROM ( SELECT inp_controls_x_arc.id,
                    inp_controls_x_arc.text
                   FROM inp_selector_result,
                    inp_controls_x_arc
                     JOIN rpt_inp_arc ON inp_controls_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
                  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
                  ORDER BY inp_controls_x_arc.id) a
        UNION
         SELECT b.id,
            b.text
           FROM ( SELECT (inp_controls_x_node.id+1000000) as id,
                    inp_controls_x_node.text
                   FROM inp_selector_result,
                    inp_controls_x_node
                     JOIN rpt_inp_node ON inp_controls_x_node.node_id::text = rpt_inp_node.node_id::text
                  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
                  ORDER BY inp_controls_x_node.id) b) c
                  ORDER BY id;
          


CREATE OR REPLACE VIEW vi_rules AS 
SELECT  text
   FROM ( SELECT a.id,
            a.text
           FROM ( SELECT inp_rules_x_arc.id,
                    inp_rules_x_arc.text
                   FROM inp_selector_result,
                    inp_rules_x_arc
                     JOIN rpt_inp_arc ON inp_rules_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
                  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
                  ORDER BY inp_rules_x_arc.id) a
        UNION
         SELECT b.id,
            b.text
           FROM ( SELECT (inp_rules_x_node.id+1000000) as id,
                    inp_rules_x_node.text
                   FROM inp_selector_result,
                    inp_rules_x_node
                     JOIN rpt_inp_node ON inp_rules_x_node.node_id::text = rpt_inp_node.node_id::text
                  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
                  ORDER BY inp_rules_x_node.id) b) c
                  ORDER BY id; 


CREATE OR REPLACE VIEW vi_energy AS 
 SELECT 
    inp_energy_el.parameter,
    inp_energy_el.value
   FROM inp_selector_result, inp_energy_el
     JOIN rpt_inp_node ON inp_energy_el.pump_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  UNION
 SELECT
    inp_energy_gl.parameter,
    inp_energy_gl.value
   FROM inp_energy_gl;


CREATE OR REPLACE VIEW vi_emitters AS 
 SELECT inp_emitter.node_id,
    inp_emitter.coef
    FROM inp_selector_result, inp_emitter
     JOIN rpt_inp_node ON inp_emitter.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_quality AS 
 SELECT inp_quality.node_id,
    inp_quality.initqual
   FROM inp_quality
  ORDER BY inp_quality.node_id;


CREATE OR REPLACE VIEW vi_sources AS 
 SELECT inp_source.node_id,
    inp_source.sourc_type,
    inp_source.quality,
    inp_source.pattern_id
   FROM inp_selector_result,  inp_source
     JOIN rpt_inp_node ON inp_source.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_reactions AS 
 SELECT inp_typevalue_react.idval AS react_type,
    inp_typevalue_param.idval AS parameter,
    inp_reactions_gl.value
   FROM inp_reactions_gl
     LEFT JOIN inp_typevalue inp_typevalue_react ON inp_reactions_gl.react_type::text = inp_typevalue_react.id::text AND inp_typevalue_react.typevalue::text = 'inp_typevalue_reactions_gl'::text
     LEFT JOIN inp_typevalue inp_typevalue_param ON inp_reactions_gl.parameter::text = inp_typevalue_param.id::text AND inp_typevalue_param.typevalue::text = 'inp_value_reactions_gl'::text
UNION
 SELECT inp_typevalue_param.idval AS react_type,
    inp_reactions_el.arc_id AS parameter,
    inp_reactions_el.value
   FROM inp_selector_result,
    inp_reactions_el
     JOIN rpt_inp_arc ON inp_reactions_el.arc_id::text = rpt_inp_arc.arc_id::text
     LEFT JOIN inp_typevalue inp_typevalue_param ON inp_reactions_el.parameter::text = inp_typevalue_param.id::text AND inp_typevalue_param.typevalue::text = 'inp_value_reactions_el'::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_mixing AS 
 SELECT inp_mixing.node_id,
    inp_mixing.mix_type,
    inp_mixing.value
   FROM inp_selector_result,
    inp_mixing
     JOIN rpt_inp_node ON inp_mixing.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_options AS 
SELECT a.idval as parameter,
	     case when (a.idval ='UNBALANCED' AND value='CONTINUE') THEN concat(value,' ',(SELECT value FROM config_param_user WHERE parameter='inp_options_unbalanced_n' AND cur_user=current_user)) 
		  when (a.idval ='QUALITY' AND value='TRACE') THEN concat(value,' ',(SELECT value FROM config_param_user WHERE parameter='inp_options_node_id' AND cur_user=current_user)) 
  		  when (a.idval ='HYDRAULICS' AND (value='USE' OR value='SAVE')) THEN concat(value,' ',(SELECT value FROM config_param_user WHERE parameter='inp_options_hydraulics_fname' AND cur_user=current_user)) 
		  else value END AS value
   FROM audit_cat_param_user a
     JOIN config_param_user b ON a.id = b.parameter::text
  WHERE (a.layout_name = ANY (ARRAY['grl_general_1'::text, 'grl_general_2'::text, 'grl_hyd_3'::text, 'grl_hyd_4'::text, 'grl_quality_5'::text, 'grl_quality_6'::text])) 
  AND a.idval NOT IN ('UNBALANCED_N', 'NODE_ID', 'HYDRAULICS_FNAME') AND b.cur_user::name = "current_user"()
  AND cur_user=current_user
  AND value is not null
  AND b.value IS NOT NULL AND (parameter !='PATTERN' AND value !='NULLVALUE');


CREATE OR REPLACE VIEW vi_times AS 
SELECT idval as parameter, value
from audit_cat_param_user a
join config_param_user b on a.id=b.parameter
where layout_name IN ('grl_date_13', 'grl_date_14') 
AND cur_user=current_user
AND value is not null;


CREATE OR REPLACE VIEW vi_report AS 
SELECT idval as parameter, value
from audit_cat_param_user a
join config_param_user b on a.id=b.parameter
where layout_name IN ('grl_reports_17', 'grl_reports_18')
AND cur_user=current_user
AND value is not null;
  

CREATE OR REPLACE VIEW vi_coordinates AS 
SELECT  rpt_inp_node.node_id,
    st_x(rpt_inp_node.the_geom)::numeric(16,3) AS xcoord,
    st_y(rpt_inp_node.the_geom)::numeric(16,3) AS ycoord
FROM rpt_inp_node;


CREATE OR REPLACE VIEW vi_vertices AS 
 SELECT arc.arc_id,
    st_x(arc.point)::numeric(16,3) AS xcoord,
    st_y(arc.point)::numeric(16,3) AS ycoord
   FROM ( SELECT (st_dumppoints(rpt_inp_arc.the_geom)).geom AS point,
            st_startpoint(rpt_inp_arc.the_geom) AS startpoint,
            st_endpoint(rpt_inp_arc.the_geom) AS endpoint,
            rpt_inp_arc.sector_id,
            rpt_inp_arc.arc_id
           FROM inp_selector_result,
            rpt_inp_arc
          WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text) arc
  WHERE (arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint);


CREATE OR REPLACE VIEW vi_labels AS 
 SELECT  inp_label.xcoord,
    inp_label.ycoord,
    inp_label.label,
    inp_label.node_id
   FROM inp_label;


CREATE OR REPLACE VIEW vi_backdrop AS 
 SELECT  inp_backdrop.text
   FROM inp_backdrop;