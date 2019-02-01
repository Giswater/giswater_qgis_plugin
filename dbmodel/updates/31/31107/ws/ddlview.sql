/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/01/30
CREATE OR REPLACE VIEW v_inp_pump AS 
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

union
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



--mincut
DROP VIEW IF EXISTS ve_ui_mincut_result_cat;
CREATE VIEW ve_ui_mincut_result_cat AS 
 SELECT anl_mincut_result_cat.id,
    anl_mincut_result_cat.work_order,
    anl_mincut_cat_state.name AS state,
    anl_mincut_cat_class.name AS class,
    anl_mincut_result_cat.mincut_type,
    anl_mincut_result_cat.received_date,
    anl_mincut_result_cat.expl_id,
    anl_mincut_result_cat.macroexpl_id,
    anl_mincut_result_cat.muni_id,
    anl_mincut_result_cat.postcode,
    anl_mincut_result_cat.streetaxis_id,
    anl_mincut_result_cat.postnumber,
    anl_mincut_result_cat.anl_cause,
    anl_mincut_result_cat.anl_tstamp,
    anl_mincut_result_cat.anl_user,
    anl_mincut_result_cat.anl_descript,
    anl_mincut_result_cat.anl_feature_id,
    anl_mincut_result_cat.anl_feature_type,
    anl_mincut_result_cat.anl_the_geom,
    anl_mincut_result_cat.forecast_start,
    anl_mincut_result_cat.forecast_end,
    anl_mincut_result_cat.assigned_to,
    anl_mincut_result_cat.exec_start,
    anl_mincut_result_cat.exec_end,
    anl_mincut_result_cat.exec_user,
    anl_mincut_result_cat.exec_descript,
    anl_mincut_result_cat.exec_the_geom,
    anl_mincut_result_cat.exec_from_plot,
    anl_mincut_result_cat.exec_depth,
    anl_mincut_result_cat.exec_appropiate
   FROM anl_mincut_result_cat
     LEFT JOIN anl_mincut_cat_class ON anl_mincut_cat_class.id = anl_mincut_result_cat.mincut_class
     LEFT JOIN anl_mincut_cat_state ON anl_mincut_cat_state.id = anl_mincut_result_cat.mincut_state;




-----------------------
-- create inp views
-----------------------


DROP VIEW IF EXISTS vi_title CASCADE;
CREATE OR REPLACE VIEW vi_title AS 
 SELECT inp_project_id.title,
    inp_project_id.date
   FROM inp_project_id
  ORDER BY inp_project_id.title;


DROP VIEW IF EXISTS vi_junctions CASCADE;
CREATE OR REPLACE VIEW vi_junctions AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    inp_junction.pattern_id
   FROM inp_selector_result,   rpt_inp_node
   LEFT JOIN inp_junction ON inp_junction.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.epa_type::text = 'JUNCTION'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
  ORDER BY rpt_inp_node.node_id;


DROP VIEW IF EXISTS vi_reservoirs CASCADE;
CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT inp_reservoir.node_id,
    rpt_inp_node.elevation AS head,
    inp_reservoir.pattern_id
   FROM inp_selector_result, inp_reservoir
   JOIN rpt_inp_node ON inp_reservoir.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_tanks CASCADE;
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


DROP VIEW IF EXISTS vi_pipes CASCADE;
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
  AND inp_typevalue.typevalue='inp_value_status_pipe'
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
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  AND inp_typevalue.typevalue='inp_value_status_pipe';


CREATE OR REPLACE VIEW vi_pumps AS 
 SELECT concat(inp_pump.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    concat('POWER '::text || inp_pump.power::text) AS power,
    concat('HEAD '::text || inp_pump.curve_id::text) AS curve_id,
    concat('SPEED '::text || inp_pump.speed) AS speed,
    concat('PATTERN '::text || inp_pump.pattern::text) AS pattern
   FROM inp_selector_result,
    inp_pump
     JOIN rpt_inp_arc ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_valves CASCADE;
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



DROP VIEW IF EXISTS vi_tags CASCADE;
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


DROP VIEW IF EXISTS vi_status CASCADE;
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


DROP VIEW IF EXISTS vi_patterns CASCADE;
CREATE OR REPLACE VIEW vi_patterns AS 
 SELECT inp_pattern_value.pattern_id,
    concat(inp_pattern_value.factor_1,' ',inp_pattern_value.factor_2,' ',inp_pattern_value.factor_3,' ',inp_pattern_value.factor_4,' ',
    inp_pattern_value.factor_5,' ',inp_pattern_value.factor_6,' ',inp_pattern_value.factor_7,' ',inp_pattern_value.factor_8,' ',
    inp_pattern_value.factor_9,' ',inp_pattern_value.factor_10,' ',inp_pattern_value.factor_11,' ', inp_pattern_value.factor_12,' ',
    inp_pattern_value.factor_13,' ', inp_pattern_value.factor_14,' ',inp_pattern_value.factor_15,' ', inp_pattern_value.factor_16,' ',
    inp_pattern_value.factor_17,' ', inp_pattern_value.factor_18,' ',inp_pattern_value.factor_19,' ',inp_pattern_value.factor_20,' ',
    inp_pattern_value.factor_21,' ',inp_pattern_value.factor_22,' ',inp_pattern_value.factor_23,' ',inp_pattern_value.factor_24) as multipliers
   FROM inp_pattern_value
  ORDER BY inp_pattern_value.pattern_id;


DROP VIEW IF EXISTS vi_curves CASCADE;
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


DROP VIEW IF EXISTS vi_controls CASCADE;
CREATE OR REPLACE VIEW vi_controls AS 
 SELECT  inp_controls_x_arc.text
   FROM inp_selector_result,  inp_controls_x_arc
     JOIN rpt_inp_arc ON inp_controls_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_controls_x_node.text
   FROM inp_selector_result, inp_controls_x_node
   JOIN rpt_inp_node ON inp_controls_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_rules CASCADE;
CREATE OR REPLACE VIEW vi_rules AS 
 SELECT inp_rules_x_arc.text
   FROM inp_selector_result,  inp_rules_x_arc
     JOIN rpt_inp_arc ON inp_rules_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_rules_x_node.text
   FROM inp_selector_result, inp_rules_x_node
   JOIN rpt_inp_node ON inp_rules_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_energy CASCADE;
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



DROP VIEW IF EXISTS vi_emitters CASCADE;
CREATE OR REPLACE VIEW vi_emitters AS 
 SELECT inp_emitter.node_id,
    inp_emitter.coef
    FROM inp_selector_result, inp_emitter
     JOIN rpt_inp_node ON inp_emitter.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_quality CASCADE;
CREATE OR REPLACE VIEW vi_quality AS 
 SELECT inp_quality.node_id,
    inp_quality.initqual
   FROM inp_quality
  ORDER BY inp_quality.node_id;


DROP VIEW IF EXISTS vi_sources CASCADE;
CREATE OR REPLACE VIEW vi_sources AS 
 SELECT inp_source.node_id,
    inp_source.sourc_type,
    inp_source.quality,
    inp_source.pattern_id
   FROM inp_selector_result,  inp_source
     JOIN rpt_inp_node ON inp_source.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_reactions;
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



DROP VIEW IF EXISTS vi_mixing CASCADE;
CREATE OR REPLACE VIEW vi_mixing AS 
 SELECT inp_mixing.node_id,
    inp_mixing.mix_type,
    inp_mixing.value
   FROM inp_selector_result,
    inp_mixing
     JOIN rpt_inp_node ON inp_mixing.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_times CASCADE;
CREATE OR REPLACE VIEW vi_times AS 
 SELECT 
unnest(array['duration','hydraulic timestep','quality timestep','rule timestep','pattern timestep','pattern start','report timeste',
    'report start','start clocktime','statistic']) as "parameter",
unnest(array[inp_times.duration::text,inp_times.hydraulic_timestep,inp_times.quality_timestep,inp_times.rule_timestep,inp_times.pattern_timestep,
    inp_times.pattern_start,inp_times.report_timestep,inp_times.report_start,inp_times.start_clocktime,inp_typevalue.idval]) as "value"
   FROM inp_times
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_times.statistic
   WHERE inp_typevalue.typevalue='inp_value_times';


DROP VIEW IF EXISTS vi_report CASCADE;
CREATE OR REPLACE VIEW vi_report AS 
 SELECT unnest(array['pagesize','status','summary','energy','nodes','links','elevation','demand','head','pressure','quality','length',
        'diameter','flow','velocity','headloss','setting','reaction','f_factor']) as "parameter",
        unnest(array[inp_report.pagesize::text,inp_typevalue.idval, inp_report.summary, inp_report.energy, inp_report.nodes, inp_report.links,
        inp_report.elevation, inp_report.demand, inp_report.head, inp_report.pressure, inp_report.quality, inp_report.length, inp_report.diameter, 
        inp_report.flow, inp_report.velocity, inp_report.headloss, inp_report.setting, inp_report.reaction, inp_report.f_factor]) as "value"
   FROM inp_report
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_report.status
   WHERE inp_typevalue.typevalue='inp_value_yesnofull';


DROP VIEW IF EXISTS vi_options CASCADE;
CREATE OR REPLACE VIEW vi_options AS 
SELECT
   unnest(array['units','headloss','hydraulics','specific gravity','viscosity','trials','accuracy','unbalanced','checkfreq','maxcheck','damplimit','pattern','demand multiplier','emitter exponent','quality',
   'diffusivity','tolerance']) as "parameter",
      unnest(array[units, headloss,((inp_options.hydraulics::text || ' '::text) || inp_options.hydraulics_fname::text),specific_gravity::text, viscosity::text,trials::text,accuracy::text,((inp_options.unbalanced::text || ' '::text) || inp_options.unbalanced_n),
   checkfreq::text, maxcheck::text, damplimit::text, pattern, demand_multiplier::text, emitter_exponent::text,inp_typevalue.idval, diffusivity::text,tolerance::text]) as "value"
   FROM inp_options 
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_options.quality
   WHERE inp_typevalue.typevalue='inp_value_opti_qual'
   AND quality!='TRACE'
  UNION
SELECT
   unnest(array['units','headloss','hydraulics','specific gravity','viscosity','trials','accuracy','unbalanced','checkfreq','maxcheck','damplimit','pattern','demand multiplier','emitter exponent','quality',
   'diffusivity','tolerance']) as "parameter",
      unnest(array[units, headloss,((inp_options.hydraulics::text || ' '::text) || inp_options.hydraulics_fname::text),specific_gravity::text,viscosity::text,trials::text,accuracy::text,((inp_options.unbalanced::text || ' '::text) || inp_options.unbalanced_n),
   checkfreq::text, maxcheck::text, damplimit::text, pattern, demand_multiplier::text, emitter_exponent::text,((inp_typevalue.idval::text || ' '::text) || inp_options.node_id::text) ,diffusivity::text,tolerance::text]) as "value"
   FROM inp_options 
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_options.quality
   WHERE inp_typevalue.typevalue='inp_value_opti_qual'
   AND quality='TRACE';

DROP VIEW IF EXISTS vi_coordinates CASCADE;
CREATE OR REPLACE VIEW vi_coordinates AS 
SELECT  rpt_inp_node.node_id,
    st_x(rpt_inp_node.the_geom)::numeric(16,3) AS xcoord,
    st_y(rpt_inp_node.the_geom)::numeric(16,3) AS ycoord
FROM rpt_inp_node;


DROP VIEW IF EXISTS vi_vertices CASCADE;
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


DROP VIEW IF EXISTS vi_labels CASCADE;
CREATE OR REPLACE VIEW vi_labels AS 
 SELECT  inp_label.xcoord,
    inp_label.ycoord,
    inp_label.label,
    inp_label.node_id
   FROM inp_label;

DROP VIEW IF EXISTS vi_backdrop CASCADE;
CREATE OR REPLACE VIEW vi_backdrop AS 
 SELECT  inp_backdrop.text
   FROM inp_backdrop;



-- ----------------------------
-- View structure for v_inp
-- ----------------------------

DROP VIEW IF EXISTS vi_title CASCADE;
CREATE OR REPLACE VIEW vi_title AS 
 SELECT inp_project_id.title,
    inp_project_id.date
   FROM inp_project_id
  ORDER BY inp_project_id.title;


DROP VIEW IF EXISTS vi_junctions CASCADE;
CREATE OR REPLACE VIEW vi_junctions AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    inp_junction.pattern_id
   FROM inp_selector_result,   rpt_inp_node
   LEFT JOIN inp_junction ON inp_junction.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.epa_type::text = 'JUNCTION'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
  ORDER BY rpt_inp_node.node_id;


DROP VIEW IF EXISTS vi_reservoirs CASCADE;
CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT inp_reservoir.node_id,
    rpt_inp_node.elevation AS head,
    inp_reservoir.pattern_id
   FROM inp_selector_result, inp_reservoir
   JOIN rpt_inp_node ON inp_reservoir.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_tanks CASCADE;
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


DROP VIEW IF EXISTS vi_pipes CASCADE;
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
  AND inp_typevalue.typevalue='inp_value_status_pipe'
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
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  AND inp_typevalue.typevalue='inp_value_status_pipe';


CREATE OR REPLACE VIEW vi_pumps AS 
 SELECT concat(inp_pump.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    concat('POWER '::text || inp_pump.power::text) AS power,
    concat('HEAD '::text || inp_pump.curve_id::text) AS curve_id,
    concat('SPEED '::text || inp_pump.speed) AS speed,
    concat('PATTERN '::text || inp_pump.pattern::text) AS pattern
   FROM inp_selector_result,
    inp_pump
     JOIN rpt_inp_arc ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_valves CASCADE;
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



DROP VIEW IF EXISTS vi_tags CASCADE;
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


DROP VIEW IF EXISTS vi_status CASCADE;
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


DROP VIEW IF EXISTS vi_patterns CASCADE;
CREATE OR REPLACE VIEW vi_patterns AS 
 SELECT inp_pattern_value.pattern_id,
    concat(inp_pattern_value.factor_1,' ',inp_pattern_value.factor_2,' ',inp_pattern_value.factor_3,' ',inp_pattern_value.factor_4,' ',
    inp_pattern_value.factor_5,' ',inp_pattern_value.factor_6,' ',inp_pattern_value.factor_7,' ',inp_pattern_value.factor_8,' ',
    inp_pattern_value.factor_9,' ',inp_pattern_value.factor_10,' ',inp_pattern_value.factor_11,' ', inp_pattern_value.factor_12,' ',
    inp_pattern_value.factor_13,' ', inp_pattern_value.factor_14,' ',inp_pattern_value.factor_15,' ', inp_pattern_value.factor_16,' ',
    inp_pattern_value.factor_17,' ', inp_pattern_value.factor_18,' ',inp_pattern_value.factor_19,' ',inp_pattern_value.factor_20,' ',
    inp_pattern_value.factor_21,' ',inp_pattern_value.factor_22,' ',inp_pattern_value.factor_23,' ',inp_pattern_value.factor_24) as multipliers
   FROM inp_pattern_value
  ORDER BY inp_pattern_value.pattern_id;


DROP VIEW IF EXISTS vi_curves CASCADE;
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


DROP VIEW IF EXISTS vi_controls CASCADE;
CREATE OR REPLACE VIEW vi_controls AS 
 SELECT  inp_controls_x_arc.text
   FROM inp_selector_result,  inp_controls_x_arc
     JOIN rpt_inp_arc ON inp_controls_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_controls_x_node.text
   FROM inp_selector_result, inp_controls_x_node
   JOIN rpt_inp_node ON inp_controls_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_rules CASCADE;
CREATE OR REPLACE VIEW vi_rules AS 
 SELECT inp_rules_x_arc.text
   FROM inp_selector_result,  inp_rules_x_arc
     JOIN rpt_inp_arc ON inp_rules_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_rules_x_node.text
   FROM inp_selector_result, inp_rules_x_node
   JOIN rpt_inp_node ON inp_rules_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_energy CASCADE;
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



DROP VIEW IF EXISTS vi_emitters CASCADE;
CREATE OR REPLACE VIEW vi_emitters AS 
 SELECT inp_emitter.node_id,
    inp_emitter.coef
    FROM inp_selector_result, inp_emitter
     JOIN rpt_inp_node ON inp_emitter.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_quality CASCADE;
CREATE OR REPLACE VIEW vi_quality AS 
 SELECT inp_quality.node_id,
    inp_quality.initqual
   FROM inp_quality
  ORDER BY inp_quality.node_id;


DROP VIEW IF EXISTS vi_sources CASCADE;
CREATE OR REPLACE VIEW vi_sources AS 
 SELECT inp_source.node_id,
    inp_source.sourc_type,
    inp_source.quality,
    inp_source.pattern_id
   FROM inp_selector_result,  inp_source
     JOIN rpt_inp_node ON inp_source.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_reactions;
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



DROP VIEW IF EXISTS vi_mixing CASCADE;
CREATE OR REPLACE VIEW vi_mixing AS 
 SELECT inp_mixing.node_id,
    inp_mixing.mix_type,
    inp_mixing.value
   FROM inp_selector_result,
    inp_mixing
     JOIN rpt_inp_node ON inp_mixing.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_times CASCADE;
CREATE OR REPLACE VIEW vi_times AS 
 SELECT 
unnest(array['duration','hydraulic timestep','quality timestep','rule timestep','pattern timestep','pattern start','report timeste',
    'report start','start clocktime','statistic']) as "parameter",
unnest(array[inp_times.duration::text,inp_times.hydraulic_timestep,inp_times.quality_timestep,inp_times.rule_timestep,inp_times.pattern_timestep,
    inp_times.pattern_start,inp_times.report_timestep,inp_times.report_start,inp_times.start_clocktime,inp_typevalue.idval]) as "value"
   FROM inp_times
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_times.statistic
   WHERE inp_typevalue.typevalue='inp_value_times';


DROP VIEW IF EXISTS vi_report CASCADE;
CREATE OR REPLACE VIEW vi_report AS 
 SELECT unnest(array['pagesize','status','summary','energy','nodes','links','elevation','demand','head','pressure','quality','length',
        'diameter','flow','velocity','headloss','setting','reaction','f_factor']) as "parameter",
        unnest(array[inp_report.pagesize::text,inp_typevalue.idval, inp_report.summary, inp_report.energy, inp_report.nodes, inp_report.links,
        inp_report.elevation, inp_report.demand, inp_report.head, inp_report.pressure, inp_report.quality, inp_report.length, inp_report.diameter, 
        inp_report.flow, inp_report.velocity, inp_report.headloss, inp_report.setting, inp_report.reaction, inp_report.f_factor]) as "value"
   FROM inp_report
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_report.status
   WHERE inp_typevalue.typevalue='inp_value_yesnofull';


DROP VIEW IF EXISTS vi_options CASCADE;
CREATE OR REPLACE VIEW vi_options AS 
SELECT
   unnest(array['units','headloss','hydraulics','specific gravity','viscosity','trials','accuracy','unbalanced','checkfreq','maxcheck','damplimit','pattern','demand multiplier','emitter exponent','quality',
   'diffusivity','tolerance']) as "parameter",
      unnest(array[units, headloss,((inp_options.hydraulics::text || ' '::text) || inp_options.hydraulics_fname::text),specific_gravity::text, viscosity::text,trials::text,accuracy::text,((inp_options.unbalanced::text || ' '::text) || inp_options.unbalanced_n),
   checkfreq::text, maxcheck::text, damplimit::text, pattern, demand_multiplier::text, emitter_exponent::text,inp_typevalue.idval, diffusivity::text,tolerance::text]) as "value"
   FROM inp_options 
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_options.quality
   WHERE inp_typevalue.typevalue='inp_value_opti_qual'
   AND quality!='TRACE'
  UNION
SELECT
   unnest(array['units','headloss','hydraulics','specific gravity','viscosity','trials','accuracy','unbalanced','checkfreq','maxcheck','damplimit','pattern','demand multiplier','emitter exponent','quality',
   'diffusivity','tolerance']) as "parameter",
      unnest(array[units, headloss,((inp_options.hydraulics::text || ' '::text) || inp_options.hydraulics_fname::text),specific_gravity::text,viscosity::text,trials::text,accuracy::text,((inp_options.unbalanced::text || ' '::text) || inp_options.unbalanced_n),
   checkfreq::text, maxcheck::text, damplimit::text, pattern, demand_multiplier::text, emitter_exponent::text,((inp_typevalue.idval::text || ' '::text) || inp_options.node_id::text) ,diffusivity::text,tolerance::text]) as "value"
   FROM inp_options 
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_options.quality
   WHERE inp_typevalue.typevalue='inp_value_opti_qual'
   AND quality='TRACE';

DROP VIEW IF EXISTS vi_coordinates CASCADE;
CREATE OR REPLACE VIEW vi_coordinates AS 
SELECT  rpt_inp_node.node_id,
    st_x(rpt_inp_node.the_geom)::numeric(16,3) AS xcoord,
    st_y(rpt_inp_node.the_geom)::numeric(16,3) AS ycoord
FROM rpt_inp_node;


DROP VIEW IF EXISTS vi_vertices CASCADE;
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


DROP VIEW IF EXISTS vi_labels CASCADE;
CREATE OR REPLACE VIEW vi_labels AS 
 SELECT  inp_label.xcoord,
    inp_label.ycoord,
    inp_label.label,
    inp_label.node_id
   FROM inp_label;

DROP VIEW IF EXISTS vi_backdrop CASCADE;
CREATE OR REPLACE VIEW vi_backdrop AS 
 SELECT  inp_backdrop.text
   FROM inp_backdrop;