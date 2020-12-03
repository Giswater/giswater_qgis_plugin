/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 22/11/2019

CREATE OR REPLACE VIEW v_edit_inp_pipe AS 
 SELECT arc.arc_id,
    arc.node_1,
    arc.node_2,
    arc.arccat_id,
    arc.sector_id,
    arc.macrosector_id,
    arc.state,
    arc.annotation,
    arc.custom_length,
    arc.the_geom,
    inp_pipe.minorloss,
    inp_pipe.status,
    inp_pipe.custom_roughness,
    inp_pipe.custom_dint
   FROM inp_selector_sector, v_arc arc
     JOIN inp_pipe USING (arc_id)
     JOIN value_state_type ON arc.state_type=id
  WHERE arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text
  AND is_operative IS TRUE;


CREATE OR REPLACE VIEW vp_epa_arc AS 
 SELECT arc.arc_id AS nid,
    arc.epa_type,
        CASE
            WHEN arc.epa_type::text = 'PIPE'::text THEN 'v_edit_inp_pipe'::text
            WHEN arc.epa_type::text = 'NOT DEFINED'::text THEN NULL::text
            ELSE NULL::text
        END AS epatable,
	node_1,
	node_2,
	sector_id
   FROM arc;
   

 CREATE OR REPLACE VIEW v_edit_inp_inlet AS 
 SELECT DISTINCT ON (node_id) * FROM (
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id
   FROM node v_node
     JOIN inp_inlet USING (node_id)
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text OR a.node_2::text = v_node.node_id::text
UNION
SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id
   FROM node v_node
     JOIN inp_inlet USING (node_id)
     JOIN vi_parent_arc a ON a.node_2::text = v_node.node_id::text)a;
 
     
CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT DISTINCT ON (node_id) * FROM (
 SELECT v_node.node_id,
    elevation,
    depth,
    nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_junction.demand,
    inp_junction.pattern_id
   FROM node v_node
     JOIN inp_junction USING (node_id)
     JOIN vi_parent_arc a ON a.node_1=v_node.node_id
    UNION
    SELECT v_node.node_id,
    elevation,
    depth,
    nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_junction.demand,
    inp_junction.pattern_id
   FROM node v_node
     JOIN inp_junction USING (node_id)
     JOIN vi_parent_arc a ON a.node_2=v_node.node_id)a;

       
CREATE OR REPLACE VIEW v_edit_inp_pump AS 
 SELECT DISTINCT ON (node_id) * FROM (
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status,
    inp_pump.pump_type
   FROM node v_node
     JOIN inp_pump USING (node_id)
     JOIN vi_parent_arc a ON a.node_1=v_node.node_id
     UNION
      SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status,
    inp_pump.pump_type
   FROM node v_node
     JOIN inp_pump USING (node_id)
     JOIN vi_parent_arc a ON a.node_2=v_node.node_id)a;
     
CREATE OR REPLACE VIEW v_edit_inp_reservoir AS 
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_reservoir.pattern_id
   FROM node v_node
     JOIN inp_reservoir USING (node_id)
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text
     UNION
     SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_reservoir.pattern_id
   FROM node v_node
     JOIN inp_reservoir USING (node_id)
     JOIN vi_parent_arc a ON a.node_2::text = v_node.node_id::text;
     
     
CREATE OR REPLACE VIEW v_edit_inp_shortpipe AS 
 SELECT DISTINCT ON (node_id) * FROM (
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_shortpipe.minorloss,
    inp_shortpipe.to_arc,
    inp_shortpipe.status
   FROM node v_node
     JOIN inp_shortpipe USING (node_id)
     JOIN vi_parent_arc a ON a.node_1=v_node.node_id
    UNION	
    SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_shortpipe.minorloss,
    inp_shortpipe.to_arc,
    inp_shortpipe.status
   FROM node v_node
     JOIN inp_shortpipe USING (node_id)
     JOIN vi_parent_arc a ON a.node_2=v_node.node_id)a;


 
CREATE OR REPLACE VIEW v_edit_inp_tank AS 
 SELECT DISTINCT ON (node_id) * FROM (
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
    FROM node v_node
     JOIN inp_tank USING (node_id)
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text
    UNION
SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
    FROM node v_node
     JOIN inp_tank USING (node_id)
     JOIN vi_parent_arc a ON a.node_2::text = v_node.node_id::text)a;
 

     
     
CREATE OR REPLACE VIEW v_edit_inp_valve AS 
 SELECT DISTINCT ON (node_id) * FROM (
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status
   FROM v_node
     JOIN inp_valve USING (node_id)
     JOIN vi_parent_arc a ON a.node_1=v_node.node_id
UNION
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status
   FROM v_node
     JOIN inp_valve USING (node_id)
     JOIN vi_parent_arc a ON a.node_2=v_node.node_id)a;
     

 CREATE OR REPLACE VIEW vi_pumps AS 
SELECT rpt_inp_arc.arc_id::text AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    ('POWER'::text || ' '::text) || inp_pump.power::text AS power,
    ('HEAD'::text || ' '::text) || inp_pump.curve_id::text AS head,
    ('SPEED'::text || ' '::text) || inp_pump.speed AS speed,
    ('PATTERN'::text || ' '::text) || inp_pump.pattern::text AS pattern
   FROM inp_selector_result,
    inp_pump
     JOIN rpt_inp_arc ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id::text AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    ('POWER'::text || ' '::text) || inp_pump_additional.power::text AS power,
    ('HEAD'::text || ' '::text) || inp_pump_additional.curve_id::text AS head,
    ('SPEED'::text || ' '::text) || inp_pump_additional.speed AS speed,
    ('PATTERN'::text || ' '::text) || inp_pump_additional.pattern::text AS pattern
   FROM inp_selector_result,
    inp_pump_additional
     JOIN rpt_inp_arc ON rpt_inp_arc.flw_code = concat(inp_pump_additional.node_id, '_n2a')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;

  
-- 23/11/2019
 CREATE OR REPLACE VIEW vi_valves AS 
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.pressure::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE (inp_valve.valv_type::text = 'PRV'::text OR inp_valve.valv_type::text = 'PSV'::text OR inp_valve.valv_type::text = 'PBV'::text) AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.flow::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE inp_valve.valv_type::text = 'FCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.coef_loss::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE inp_valve.valv_type::text = 'TCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.curve_id::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE inp_valve.valv_type::text = 'GPV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  UNION
   SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    'PRV'::varchar(18) AS valv_type,
    0::text AS setting,
    0::numeric(12,4) AS minorloss
   FROM inp_selector_result, rpt_inp_arc
   JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a_4')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
 UNION
   SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    'GPV'::varchar(18) AS valv_type,
    inp_pump.curve_id::text AS setting,
    0::numeric(12,4) AS minorloss
   FROM inp_selector_result, rpt_inp_arc
   JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a_5')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  UNION
   SELECT arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.pressure::text AS setting,
    inp_virtualvalve.minorloss
   FROM inp_selector_result,  rpt_inp_arc
   JOIN inp_virtualvalve USING (arc_id)
   WHERE (inp_virtualvalve.valv_type::text = 'PRV'::text OR inp_virtualvalve.valv_type::text = 'PSV'::text OR inp_virtualvalve.valv_type::text = 'PBV'::text) AND rpt_inp_arc.result_id::text =   	inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.flow::text AS setting,
    inp_virtualvalve.minorloss
   FROM inp_selector_result, rpt_inp_arc
  JOIN inp_virtualvalve USING (arc_id)
  WHERE inp_virtualvalve.valv_type::text = 'FCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.coef_loss::text AS setting,
    inp_virtualvalve.minorloss
   FROM inp_selector_result, rpt_inp_arc
  JOIN inp_virtualvalve USING (arc_id)
  WHERE inp_virtualvalve.valv_type::text = 'TCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    cat_arc.dint AS diameter,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.curve_id::text AS setting,
    inp_virtualvalve.minorloss
   FROM inp_selector_result, rpt_inp_arc
   JOIN inp_virtualvalve USING (arc_id)
  JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
  WHERE inp_virtualvalve.valv_type::text = 'GPV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;

  
  -- 23/11/2019
  CREATE OR REPLACE VIEW v_edit_inp_virtualvalve AS 
 SELECT v_arc.arc_id,
    (v_arc.elevation1 + v_arc.elevation2) / 2::numeric AS elevation,
    (v_arc.depth1 + v_arc.depth2) / 2::numeric AS depth,
    v_arc.arccat_id,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.annotation,
    v_arc.the_geom,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.pressure,
    inp_virtualvalve.flow,
    inp_virtualvalve.coef_loss,
    inp_virtualvalve.curve_id,
    inp_virtualvalve.minorloss,
    inp_virtualvalve.to_arc,
    inp_virtualvalve.status
   FROM inp_selector_sector, v_arc
     JOIN inp_virtualvalve USING (arc_id)
     JOIN value_state_type ON v_arc.state_type=id
  WHERE v_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text
  AND is_operative IS TRUE;


  
CREATE OR REPLACE VIEW vi_junctions AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_junction ON inp_junction.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  UNION
SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_valve ON inp_valve.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
  SELECT rpt_inp_node.node_id, 
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_pump ON inp_pump.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
SELECT rpt_inp_node.node_id, 
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_tank ON inp_tank.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
SELECT rpt_inp_node.node_id, 
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_inlet ON inp_inlet.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
SELECT rpt_inp_node.node_id, 
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_shortpipe ON inp_shortpipe.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
SELECT rpt_inp_node.node_id, 
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result, rpt_inp_node
   WHERE (rpt_inp_node.epa_type::text = ANY (ARRAY['JUNCTION'::character varying::text, 'SHORTPIPE'::character varying::text])) 
   AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  ORDER by node_id;
  