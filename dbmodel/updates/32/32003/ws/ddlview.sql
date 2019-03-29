 /*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
 
CREATE OR REPLACE VIEW vi_junctions AS 
SELECT 
rpt_inp_node.node_id, 
elevation, 
rpt_inp_node.demand, 
pattern_id
FROM inp_selector_result, rpt_inp_node
   LEFT JOIN inp_junction ON inp_junction.node_id = rpt_inp_node.node_id
   WHERE epa_type IN ('JUNCTION', 'SHORTPIPE') AND rpt_inp_node.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"()
   ORDER BY rpt_inp_node.node_id;