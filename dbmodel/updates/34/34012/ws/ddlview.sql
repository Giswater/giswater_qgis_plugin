/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/31

CREATE OR REPLACE VIEW vi_junctions AS 
SELECT distinct on (node_id) * FROM (
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev as elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result,
    rpt_inp_node
     JOIN inp_junction ON inp_junction.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND epa_type='JUNCTION'
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result,
    rpt_inp_node
     JOIN inp_valve ON inp_valve.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND epa_type='JUNCTION'
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result,
    rpt_inp_node
     JOIN inp_pump ON inp_pump.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND epa_type='JUNCTION'
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result,
    rpt_inp_node
     JOIN inp_tank ON inp_tank.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND epa_type='JUNCTION'
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result,
    rpt_inp_node
     JOIN inp_inlet ON inp_inlet.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND epa_type='JUNCTION' 
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result,
    rpt_inp_node
     JOIN inp_shortpipe ON inp_shortpipe.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND epa_type='JUNCTION'
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result,
    rpt_inp_node
  WHERE (rpt_inp_node.epa_type::text = ANY (ARRAY['JUNCTION'::character varying::text, 'SHORTPIPE'::character varying::text])) AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  ) a 
  ORDER BY 1;