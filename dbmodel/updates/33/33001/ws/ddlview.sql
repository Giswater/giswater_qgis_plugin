/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



CREATE OR REPLACE VIEW vi_pipes AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
        CASE
            WHEN rpt_inp_arc.minorloss IS NULL THEN 0::numeric(12,6)
            ELSE rpt_inp_arc.minorloss
        END AS minorloss,
    inp_typevalue.idval AS status
   FROM inp_selector_result,
    rpt_inp_arc
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = rpt_inp_arc.status::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_status_pipe'::text AND (rpt_inp_arc.arc_type::text = 'VARC'::text OR rpt_inp_arc.arc_type::text = 'PIPE'::text)
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
        CASE
            WHEN inp_shortpipe.minorloss IS NULL THEN 0::numeric(12,6)
            ELSE inp_shortpipe.minorloss
        END AS minorloss,
    inp_typevalue.idval AS status
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_shortpipe ON rpt_inp_arc.arc_id::text = concat(inp_shortpipe.node_id, '_n2a')
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_shortpipe.status::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_status_pipe'::text;

  
  
CREATE OR REPLACE VIEW v_rpt_arc AS 
 SELECT arc.arc_id,
    rpt_selector_result.result_id,
    arc.arc_type,
    arc.arccat_id,
    max(rpt_arc.flow) AS max_flow,
    min(rpt_arc.flow) AS min_flow,
    max(rpt_arc.vel) AS max_vel,
    min(rpt_arc.vel) AS min_vel,
    max(rpt_arc.headloss) AS max_headloss,
    min(rpt_arc.headloss) AS min_headloss,
    max(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision + 0.1::double precision))::numeric(12,2) AS max_uheadloss,
    min(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision + 0.1::double precision))::numeric(12,2) AS min_uheadloss,
    max(rpt_arc.setting) AS max_setting,
    min(rpt_arc.setting) AS min_setting,
    max(rpt_arc.reaction) AS max_reaction,
    min(rpt_arc.reaction) AS min_reaction,
    max(rpt_arc.ffactor) AS max_ffactor,
    min(rpt_arc.ffactor) AS min_ffactor,
    arc.the_geom
   FROM rpt_selector_result,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text AND arc.result_id::text = rpt_selector_result.result_id::text
  GROUP BY arc.arc_id, arc.arc_type, arc.arccat_id, rpt_selector_result.result_id, arc.the_geom
  ORDER BY arc.arc_id;

   
  
CREATE OR REPLACE VIEW v_rpt_arc_all AS 
 SELECT rpt_arc.id,
    arc.arc_id,
    rpt_selector_result.result_id,
    arc.arc_type,
    arc.arccat_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    now()::date + rpt_arc."time"::interval AS "time",
    arc.the_geom
   FROM rpt_selector_result,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text AND arc.result_id::text = rpt_selector_result.result_id::text
  ORDER BY rpt_arc.setting, arc.arc_id;


  
CREATE OR REPLACE VIEW v_rpt_comp_arc AS 
 SELECT arc.arc_id,
    rpt_selector_compare.result_id,
    max(rpt_arc.flow) AS max_flow,
    min(rpt_arc.flow) AS min_flow,
    max(rpt_arc.vel) AS max_vel,
    min(rpt_arc.vel) AS min_vel,
    max(rpt_arc.headloss) AS max_headloss,
    min(rpt_arc.headloss) AS min_headloss,
    max(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision + 0.1::double precision))::numeric(12,2) AS max_uheadloss,
    min(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision + 0.1::double precision))::numeric(12,2) AS min_uheadloss,
    max(rpt_arc.setting) AS max_setting,
    min(rpt_arc.setting) AS min_setting,
    max(rpt_arc.reaction) AS max_reaction,
    min(rpt_arc.reaction) AS min_reaction,
    max(rpt_arc.ffactor) AS max_ffactor,
    min(rpt_arc.ffactor) AS min_ffactor,
    arc.the_geom
   FROM rpt_selector_compare,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text AND arc.result_id::text = rpt_selector_compare.result_id::text
  GROUP BY arc.arc_id, arc.arc_type, arc.arccat_id, rpt_selector_compare.result_id, arc.the_geom
  ORDER BY arc.arc_id;


  
CREATE OR REPLACE VIEW v_rpt_comp_node AS 
 SELECT node.node_id,
    rpt_selector_compare.result_id,
    node.node_type,
    node.nodecat_id,
    max(rpt_node.elevation) AS elevation,
    max(rpt_node.demand) AS max_demand,
    min(rpt_node.demand) AS min_demand,
    max(rpt_node.head) AS max_head,
    min(rpt_node.head) AS min_head,
    max(rpt_node.press) AS max_pressure,
    min(rpt_node.press) AS min_pressure,
    max(rpt_node.quality) AS max_quality,
    min(rpt_node.quality) AS min_quality,
    node.the_geom
   FROM rpt_selector_compare,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text AND node.result_id::text = rpt_selector_compare.result_id::text
  GROUP BY node.node_id, node.node_type, node.nodecat_id, rpt_selector_compare.result_id, node.the_geom
  ORDER BY node.node_id;

  

CREATE OR REPLACE VIEW v_rpt_node AS 
 SELECT node.node_id,
    rpt_selector_result.result_id,
    node.node_type,
    node.nodecat_id,
    max(rpt_node.elevation) AS elevation,
    max(rpt_node.demand) AS max_demand,
    min(rpt_node.demand) AS min_demand,
    max(rpt_node.head) AS max_head,
    min(rpt_node.head) AS min_head,
    max(rpt_node.press) AS max_pressure,
    min(rpt_node.press) AS min_pressure,
    max(rpt_node.quality) AS max_quality,
    min(rpt_node.quality) AS min_quality,
    node.the_geom
   FROM rpt_selector_result,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text AND node.result_id::text = rpt_selector_result.result_id::text
  GROUP BY node.node_id, node.node_type, node.nodecat_id, rpt_selector_result.result_id, node.the_geom
  ORDER BY node.node_id;

  
  
CREATE OR REPLACE VIEW v_rpt_node_all AS 
 SELECT rpt_node.id,
    node.node_id,
    node.node_type,
    node.nodecat_id,
    rpt_selector_result.result_id,
    rpt_node.elevation,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    now()::date + rpt_node."time"::interval AS "time",
    node.the_geom
   FROM rpt_selector_result,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text AND node.result_id::text = rpt_selector_result.result_id::text
  ORDER BY rpt_node.press, node.node_id;
